region   = "us-east-1"
env      = "qa"
app_name = "spademo"
vpc      = "vpc-0cbcb4541992f171b"
subnets  = ["subnet-08724a631f9bf8edb", "subnet-04c7e0c304c73e6a5"]

tags = {
  APPLICATION = "SPADEMO",
  TID         = "qyang",
  BSID        = "qyang",
  SERVICEID   = "qyang",
  ENVIRONMENT = "qa",
  FUNCTION    = "app",
  CREATOR     = "xyz.abc@hotmail.com"
}

image_tag       = "latest" # supposed to use qa
ecr       = "381492177645.dkr.ecr.us-east-1.amazonaws.com/spademo"