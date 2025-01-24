############################
#   Netwok Load Balancer   #
############################
resource "aws_lb" "nlb1" {
  name               = "NLB1"
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.zone-1.id]

  enable_deletion_protection = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "nlb2" {
  name               = "NLB2"
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.zone-2.id]

  enable_deletion_protection = false

  lifecycle {
    create_before_destroy = true
  }
}

############################
#       Target Group       #
############################
resource "aws_lb_target_group" "nlb_group1" {
  name     = "targetgroup1"
  port     = 22
  protocol = "TCP"
  vpc_id   = aws_vpc.test.id

  health_check {
    enabled = true
    healthy_threshold = 3
    unhealthy_threshold = 3
    interval = 10
    protocol = "TCP"
  }

}

resource "aws_lb_target_group" "nlb_group2" {
  name     = "targetgroup2"
  port     = 22
  protocol = "TCP"
  vpc_id   = aws_vpc.test.id

  health_check {
    enabled = true
    healthy_threshold = 3
    unhealthy_threshold = 3
    interval = 10
    protocol = "TCP"
  }

  tags = {
    Name = "NLB group for AZ 2"
  }
}

############################
#       LB listener        #
############################
resource "aws_lb_listener" "nlb_group1_listener" {
  load_balancer_arn = aws_lb.nlb1.arn
  port              = "22"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_group1.arn
  }

}

resource "aws_lb_listener" "nlb_group2_listener" {
  load_balancer_arn = aws_lb.nlb2.arn
  port              = "22"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_group2.arn
  }

}

############################
#     Group Attachment     #
############################
#            #1            #
############################
resource "aws_lb_target_group_attachment" "nlb_group1_att1" {
  target_group_arn = aws_lb_target_group.nlb_group1.arn
  target_id        = aws_instance.vm1.id
  port             = 22
}

resource "aws_lb_target_group_attachment" "nlb_group1_att2" {
  target_group_arn = aws_lb_target_group.nlb_group1.arn
  target_id        = aws_instance.vm3.id
  port             = 22
}

############################
#            #2            #
############################
resource "aws_lb_target_group_attachment" "nlb_group2_att1" {
  target_group_arn = aws_lb_target_group.nlb_group2.arn
  target_id        = aws_instance.vm2.id
  port             = 22
}

resource "aws_lb_target_group_attachment" "nlb_group2_att2" {
  target_group_arn = aws_lb_target_group.nlb_group2.arn
  target_id        = aws_instance.vm4.id
  port             = 22
}

