



# Aws key-pair (login)

resource "aws_key_pair" "ssh_key" {
  key_name   = var.key_name
  public_key = file("terra-key-ec2.pub")
}

# vpc & security group

resource "aws_default_vpc" "default" {

}

# security group 
# create security group and attach to the default vpc
# aws_default_vpc.default.id is the id of the default vpc or interpolation
# in interpolation we use $ { } to refer to the id of the default vpc
# or any other attribute of the default vpc
# ingress is used to allow incoming traffic
# egress is used to allow outgoing traffic
# from_port is the port number from which the traffic is allowed
# to_port is the port number to which the traffic is allowed
# protocol is the protocol to which the traffic is allowed
# cidr_blocks is the list of ip addresses from which the traffic is allowed

resource "aws_security_group" "my_sec_group" {
  vpc_id      = aws_default_vpc.default.id # attach to the default vpc
  name        = var.tags_sg.Name
  description = "allow ssh & http access"

  tags = var.tags_sg

  # allow incoming traffic from any ip address on port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "web server access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outgoing traffic"
  }
}

resource "aws_instance" "web-server" {
  ami             = var.ami_id # free-tier AMI id for ubuntu
  instance_type   = var.instance_type
  //key_name        = aws_key_pair.ssh_key.key_name
  //security_groups = [aws_security_group.my_sec_group.name]
  
  # passing script to user_data to install nginx on the EC2 instance
  # after terraform apply the script will run on the EC2 instance and install nginx
  # and create a simple HTML file to verify the installation
  //user_data = file("install_package.sh")

  # specify root block device size and type (gp3 is general purpose SSD)
  /*root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
  }*/
}

# terraform state list
# this command will list all the resources in the state file
# terraform state list -state=terraform.tfstate

# destory any resource from state file 
# terraform state rm aws_instance.web-server

# show the details of any resource
# terraform state show aws_instance.web-server

# remove specific resource from state file and update the ec2 instance
# terraform destroy -target=aws_instance.web-server
# terraform apply


