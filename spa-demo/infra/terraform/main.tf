terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region                   = var.region
  shared_credentials_files = ["C:/Users/qyang/.aws/credentials"]
  profile                  = "deployer"
}

data "aws_subnet_ids" "default" {
  vpc_id = var.vpc
}

## resources list
### security group
### load balancer
### IAM Roles for ECS
### ECS task definition
### ECS cluster and service
### cloudwatch
### cloudfront
### s3
### waf2

# ============================== security group =============================
resource "aws_security_group" "lb" {
  name        = "${var.app_name}-lb-sg-${var.env}"
  description = "controls access to the Application Load Balancer (ALB)"
  vpc_id      = var.vpc
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.app_name}-ecs-tasks-sg-${var.env}"
  description = "allow inbound access from the ALB only"

  ingress {
    protocol        = "tcp"
    from_port       = 4000
    to_port         = 4000
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# ============================= Load Balancer =========================
resource "aws_lb" "lb" {
  name               = "${var.app_name}-alb-${var.env}"
  subnets            = data.aws_subnet_ids.default.ids
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  tags = var.tags
}

resource "aws_lb_target_group" "tg" {
  name        = "${var.app_name}-alb-tg-${var.env}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc
  target_type = "ip"
  tags = var.tags
  health_check {
    healthy_threshold   = "3"
    interval            = "90"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "20"
    path                = "/api/health"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "https_forward" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
  tags = var.tags
}

# ======================== IAM Role for ECS execution ======================
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.app_name}-ecs-${var.env}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ==================== ECS Task Definition ====================
data "template_file" "task_definition_template" {
  template = file("./task.json.tpl")
  vars = {
    aws_ecr_repository = var.ecr
    image_tag          = var.image_tag
    app_port           = 80
    app_name           = var.app_name
    env                = var.env
    region             = var.region
  }
}

resource "aws_ecs_task_definition" "taskdef" {
  family                   = "${var.app_name}-task-def-${var.env}"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.task_definition_template.rendered
  tags = var.tags
}

# ================= ECS Cluster & Service ======================================
resource "aws_ecs_cluster" "cluster" {
  name = "${var.app_name}-cluster-${var.env}"
  tags = var.tags
}

resource "aws_ecs_service" "service" {
  name            = "${var.app_name}-service-${var.env}"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.taskdef.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  tags = var.tags
  propagate_tags  = "SERVICE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = data.aws_subnet_ids.default.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "${var.app_name}-container-${var.env}"
    container_port   = 4000
  }

  depends_on = [aws_lb_listener.https_forward, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

# ===== CloudWatch ==========
resource "aws_cloudwatch_log_group" "appcloudwatch" {
  name = "${var.app_name}-awslogs-${var.env}"
  tags = var.tags
}

# ===== cloudfront and s3 ==================
resource "aws_s3_bucket" "b" {
  bucket = "s3-spademo-public-${var.env}"
  tags = var.tags
}

# resource "aws_s3_bucket_acl" "b_acl" {
  # bucket = aws_s3_bucket.b.id
  # acl    = "private"
# }

locals {
  s3_origin_id = "s3Origin"
  api_origin_id = "apiOrigin"
}

# for cloudfront to access s3
resource "aws_cloudfront_origin_access_control" "access_control" {
  name                              = "${var.app_name}-s3-${var.region}-origin-access-control"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin {
    domain_name              = aws_s3_bucket.b.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.access_control.id
    origin_id                = local.s3_origin_id
  }

  origin {
    domain_name              = aws_lb.lb.dns_name
    origin_id                = local.api_origin_id
    custom_origin_config {
      http_port               = 80
      https_port              = 443
      origin_protocol_policy  = "http-only"
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"
  tags = var.tags

#  logging_config {
#    include_cookies = false
#    bucket          = "mylogs.s3.amazonaws.com"
#    prefix          = "myprefix"
#  }

#  aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior
  ordered_cache_behavior {
    path_pattern     = "api/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT", "GET", "HEAD"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = local.api_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    # available values
    # allow-all https-only redirect-to-https
    viewer_protocol_policy = "allow-all"
  }

  # Cache behavior
  ordered_cache_behavior {
    path_pattern     = "auth/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT", "GET", "HEAD"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = local.api_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "allow-all"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# ================ update s3 policy for cloudfront to access =====================
resource "aws_s3_bucket_policy" "cloudfront_s3_bucket_policy" {
  bucket = aws_s3_bucket.b.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.b.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cloudfront_distribution.arn
          }
        }
      }
    ]
  })
}

# ==================== WAF =====================================
module "waf2" {
  source = "./modules/waf2"
  app_name = var.app_name
  env = var.env
  lb_arn = aws_lb.lb.arn
  tags = var.tags
}