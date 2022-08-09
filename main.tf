### VPC ###
resource "aws_vpc" "tf_test" {
  cidr_block = "172.31.0.0/16"
  
  lifecycle {
    ignore_changes = [ tags_all, tags]
  }
}

resource "aws_ec2_tag" "tf_test_vpc" {
  resource_id = resource.aws_vpc.tf_test.id
  key         = "Name"
  value       = "tf_test"
}


### Subnets ###
resource "aws_subnet" "subnet1" {
  vpc_id            = resource.aws_vpc.tf_test.id
  cidr_block        = "172.31.16.0/20"
  availability_zone = "ru-msk-comp1p"
  lifecycle {
    ignore_changes = [ tags_all, tags]
  }
}

### SG ###
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound connections"
  vpc_id      = resource.aws_vpc.tf_test.id

  ingress {
    description = "SSH inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh"
  }

  lifecycle {
    ignore_changes = [ tags_all, tags]
  }
}

### Elastic IP ###
resource "aws_eip" "test_1" {
  vpc = true
  lifecycle {
    ignore_changes = [ tags_all, tags]
  }
}

resource "aws_ec2_tag" "test_1_eip" {
  resource_id = resource.aws_eip.test_1.id
  key         = "Name"
  value       = "test_1"
}

resource "aws_eip_association" "test_1" {
  instance_id   = resource.aws_instance.test_1.id
  allocation_id = aws_eip.test_1.id
}

### EC2 Instances ###
resource "aws_instance" "test_1" {
  tags = {
    Name = "test_1"
  }
  ami                         = "cmi-0E29FB61"                  # AlmaLinux 8.5 [Cloud Image]
  instance_type               = "c5.large"
  subnet_id                   = resource.aws_subnet.subnet1.id
  monitoring                  = true
  source_dest_check           = true
  key_name                    = "gmelnikov"
  private_ip                  = "172.31.16.4"
  associate_public_ip_address = false
  root_block_device {
    volume_size = 32
    volume_type = "gp2"
    tags = {
        Name = "pepka test"
    }
  }

  security_groups = [
    aws_security_group.allow_ssh.id
  ]

  lifecycle {
    ignore_changes = [
      security_groups,
      associate_public_ip_address,
      tags_all,
      tags
    ]
  }
}
