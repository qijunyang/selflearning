
# ========================= WAF =====================================

# enable ip set if it needs for non prod
# resource "aws_wafv2_ip_set" "ip_set" {
#   name               = "${var.app_name}-${var.env}-ip_set"
#   description        = "Example IP set"
#   scope              = "REGIONAL"
#   ip_address_version = "IPV4"
#   addresses          = ["1.2.3.4/32", "5.6.7.8/32"]

#   tags = {
#     Tag1 = "Value1"
#     Tag2 = "Value2"
#   }
# }

resource "aws_wafv2_web_acl" "waf" {
  name  = "${var.app_name}-${var.env}-web-acl"
  scope = "REGIONAL"
  tags = var.tags

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.app_name}-${var.env}-metric-name"
    sampled_requests_enabled   = true
  }
  
  # enable it if it needs ip set rule for non prod
  # rule {
  #   name     = "${var.app_name}-${var.env}-ip-set"
  #   priority = 0

  #   action {
  #     allow {}
  #   }

  #   statement {
  #     ip_set_reference_statement {
  #       arn = aws_wafv2_ip_set.ip_set.arn
  #     }
  #   }

  #   visibility_config {
  #     cloudwatch_metrics_enabled = false
  #     metric_name                = "${var.app_name}-${var.env}-rule-ip-set"
  #     sampled_requests_enabled   = false
  #   }
  # }

  ## rule common web
  rule {
    name = "common_web_rules"
    priority = 0
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "SizeRestrictions_QUERYSTRING"
        }
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "SizeRestrictions_Cookie_HEADER"
        }
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "SizeRestrictions_BODY"
        }
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "SizeRestrictions_URIPATH"
        }
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CrossSiteScripting_BODY"
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.app_name}-${var.env}-metric-name-common-web-rules"
      sampled_requests_enabled   = true
    }
  }

  ## rule KnownBadInputRules
  rule {
    name = "known_bad_input_rules"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.app_name}-${var.env}-metric-name-known-bad-input-rules"
      sampled_requests_enabled   = true
    }
  }

  ## rule SqlInjectionRules
  rule {
    name = "sql_injection_rules"
    priority = 2
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.app_name}-${var.env}-metric-name-sql-injection-rules"
      sampled_requests_enabled   = true
    }
  }

  ## rule UnixExploitsRules
  rule {
    name = "unix_exploits_rules"
    priority = 3
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.app_name}-${var.env}-metric-name-unix-exploits-rules"
      sampled_requests_enabled   = true
    }
  }

  ## rule LinuxExploitsRules
  rule {
    name = "linux_exploits_rules"
    priority = 4
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.app_name}-${var.env}-metric-name-linux-exploits-rules"
      sampled_requests_enabled   = true
    }
  }
}

resource "aws_wafv2_web_acl_association" "waf_association" {
  resource_arn = var.lb_arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}