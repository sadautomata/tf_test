############################
#   Netwok Load Balancer   #
############################
resource "aws_lb" "nlb1" {
  name               = "NLB1"
  internal           = true
  load_balancer_type = "network"
  subnets            = [resource.aws_subnet.subnet1.id]
  enable_deletion_protection = false

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_lb" "external_lb1" {
  name               = "EXTLB1"
  internal           = false
  load_balancer_type = "network"
  subnets            = [resource.aws_subnet.subnet1.id]
  enable_deletion_protection = true

  lifecycle {
    create_before_destroy = true
  }
}
