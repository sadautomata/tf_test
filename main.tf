### VPC ###
resource "aws_vpc" "test" {
  cidr_block = "10.44.0.0/16"
  
  lifecycle {
    ignore_changes = [ tags_all, tags]
  }
}

### Subnets ###
resource "aws_subnet" "zone-1" {
  vpc_id            = resource.aws_vpc.test.id
  cidr_block        = "10.44.0.0/20"
  availability_zone = "ru-msk-comp1p"
  lifecycle {
    ignore_changes = [ tags_all, tags]
  }
}

resource "aws_subnet" "zone-2" {
  vpc_id            = resource.aws_vpc.test.id
  cidr_block        = "10.44.16.0/20"
  availability_zone = "ru-msk-vol51"
  lifecycle {
    ignore_changes = [ tags_all, tags]
  }
}


### SG ###
resource "aws_security_group" "test_elb" {
  name        = "test_elb"
  description = "test_elb"
  vpc_id      = resource.aws_vpc.test.id

  ingress {
    description = "SSH inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "test_elb"
  }

  lifecycle {
    ignore_changes = [ tags_all, tags]
  }
}



### EC2 Instances ###
resource "aws_instance" "vm1" {
  ami                         = var.cmi
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_name
  subnet_id                   = resource.aws_subnet.zone-1.id
  monitoring                  = true
  source_dest_check           = true
  private_ip                  = "10.44.0.10"
  associate_public_ip_address = false
  root_block_device {
    volume_size = 32
    volume_type = "gp2"
    tags = {
        Name = "test"
    }
  }

  security_groups = [
    aws_security_group.test_elb.id
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

resource "aws_instance" "vm2" {
  ami                         = var.cmi
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_name
  subnet_id                   = resource.aws_subnet.zone-2.id
  monitoring                  = true
  source_dest_check           = true
  private_ip                  = "10.44.16.10"
  associate_public_ip_address = false
  root_block_device {
    volume_size = 32
    volume_type = "gp2"
    tags = {
        Name = "test"
    }
  }

  security_groups = [
    aws_security_group.test_elb.id
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

resource "aws_instance" "vm3" {
  ami                         = var.cmi
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_name
  subnet_id                   = resource.aws_subnet.zone-1.id
  monitoring                  = true
  source_dest_check           = true
  private_ip                  = "10.44.0.11"
  associate_public_ip_address = false
  root_block_device {
    volume_size = 32
    volume_type = "gp2"
    tags = {
        Name = "test"
    }
  }

  security_groups = [
    aws_security_group.test_elb.id
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

resource "aws_instance" "vm4" {
  ami                         = var.cmi
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_name
  subnet_id                   = resource.aws_subnet.zone-2.id
  monitoring                  = true
  source_dest_check           = true
  private_ip                  = "10.44.16.11"
  associate_public_ip_address = false
  root_block_device {
    volume_size = 32
    volume_type = "gp2"
    tags = {
        Name = "test"
    }
  }

  security_groups = [
    aws_security_group.test_elb.id
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
