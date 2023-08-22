### VPC ###
resource "aws_vpc" "croc" {
  cidr_block = "10.44.0.0/16"
  
  lifecycle {
    ignore_changes = [ tags_all, tags]
  }
}

### Subnets ###
resource "aws_subnet" "zone-1" {
  vpc_id            = resource.aws_vpc.croc.id
  cidr_block        = "10.44.0.0/20"
  availability_zone = "ru-msk-comp1p"
  lifecycle {
    ignore_changes = [ tags_all, tags]
  }
}

resource "aws_subnet" "zone-2" {
  vpc_id            = resource.aws_vpc.croc.id
  cidr_block        = "10.44.16.0/20"
  availability_zone = "ru-msk-vol51"
  lifecycle {
    ignore_changes = [ tags_all, tags]
  }
}


### SG ###
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound connections"
  vpc_id      = resource.aws_vpc.croc.id

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



### EC2 Instances ###
resource "aws_instance" "vm1" {
  ami                         = "cmi-0E29FB61"                  # AlmaLinux 8.5 [Cloud Image]
  instance_type               = "c5.large"
  subnet_id                   = resource.aws_subnet.zone-1.id
  monitoring                  = true
  source_dest_check           = true
  key_name                    = "gmelnikov"
  private_ip                  = "10.44.0.10"
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

resource "aws_instance" "vm2" {
  ami                         = "cmi-0E29FB61"                  # AlmaLinux 8.5 [Cloud Image]
  instance_type               = "c5.large"
  subnet_id                   = resource.aws_subnet.zone-2.id
  monitoring                  = true
  source_dest_check           = true
  key_name                    = "gmelnikov"
  private_ip                  = "10.44.16.10"
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

resource "aws_instance" "vm3" {
  ami                         = "cmi-0E29FB61"                  # AlmaLinux 8.5 [Cloud Image]
  instance_type               = "c5.large"
  subnet_id                   = resource.aws_subnet.zone-1.id
  monitoring                  = true
  source_dest_check           = true
  key_name                    = "gmelnikov"
  private_ip                  = "10.44.0.11"
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

resource "aws_instance" "vm4" {
  ami                         = "cmi-0E29FB61"                  # AlmaLinux 8.5 [Cloud Image]
  instance_type               = "c5.large"
  subnet_id                   = resource.aws_subnet.zone-2.id
  monitoring                  = true
  source_dest_check           = true
  key_name                    = "gmelnikov"
  private_ip                  = "10.44.16.11"
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
