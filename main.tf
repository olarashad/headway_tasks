# Define the AWS provider and specify the region to use.
provider "aws" {
  region = "us-east-1"  # Set the AWS region for resources.
}

# Fetch the default VPC details by its ID.
data "aws_vpc" "default" {
  id      = "vpc-05c2079b12a35cfd3"  # Use the ID of the existing VPC.
  default = true  # This specifies that we want to work with the default VPC.
}

# Create a public subnet within the specified VPC.
resource "aws_subnet" "some_public_subnet" {
  vpc_id            = data.aws_vpc.default.id  # Reference the VPC ID from the data source.
  cidr_block        = "172.31.0.0/20"  # Define a CIDR block for the public subnet.
  availability_zone = "us-east-1a"  # Specify the availability zone for the subnet.

  # Apply a tag to identify the subnet.
  tags = {
    Name = "Public Subnet"
  }
}

# Create a private subnet within the same VPC, but in a different CIDR range.
resource "aws_subnet" "some_private_subnet" {
  vpc_id            = data.aws_vpc.default.id  # Reference the same VPC ID as above.
  cidr_block        = "172.31.16.0/20"  # Define a CIDR block for the private subnet.
  availability_zone = "us-east-1a"  # Choose the same availability zone for simplicity.

  # Apply a tag to identify the subnet.
  tags = {
    Name = "Private Subnet"
  }
}

# Create an internet gateway to allow internet access for resources in the public subnet.
resource "aws_internet_gateway" "ig" {
  vpc_id = data.aws_vpc.default.id  # Attach the internet gateway to the VPC.

  # Tag the internet gateway for identification.
  tags = {
    Name = "Internet Gateway"
  }
}

# Define a public route table for routing internet traffic.
resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.default.id  # Use the same VPC ID.

  # Add a route for IPv4 traffic (0.0.0.0/0) to go through the internet gateway.
  route {
    cidr_block = "0.0.0.0/0"  # Allow all IPv4 traffic.
    gateway_id = aws_internet_gateway.ig.id  # Send traffic to the internet gateway.
  }

  # Add a route for IPv6 traffic (::/0) to go through the same internet gateway.
  route {
    ipv6_cidr_block = "::/0"  # Allow all IPv6 traffic.
    gateway_id = aws_internet_gateway.ig.id  # Send traffic to the internet gateway.
  }

  # Tag the route table for identification.
  tags = {
    Name = "Public Route Table"
  }
}

# Associate the public subnet with the public route table to route internet traffic.
resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.some_public_subnet.id  # Attach the route table to the public subnet.
  route_table_id = aws_route_table.public_rt.id  # Specify the route table to associate.
}

# Create a security group for allowing HTTP and SSH access.
resource "aws_security_group" "web_sg" {
  name   = "HTTP and SSH"  # Name of the security group.
  vpc_id = data.aws_vpc.default.id  # Attach the security group to the VPC.

  # Define the ingress rules (incoming traffic).
  ingress {
    from_port   = 80  # Allow HTTP traffic on port 80.
    to_port     = 80  # To port 80.
    protocol    = "tcp"  # Using TCP protocol.
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from any source.
  }

  ingress {
    from_port   = 22  # Allow SSH traffic on port 22.
    to_port     = 22  # To port 22.
    protocol    = "tcp"  # Using TCP protocol.
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from any source.
  }

  # Define the egress rules (outgoing traffic).
  egress {
    from_port   = 0  # Allow all outgoing traffic.
    to_port     = 0  # To all ports.
    protocol    = -1  # Allow all protocols.
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to any destination.
  }
}

# Create an EC2 instance in the public subnet with a security group.
resource "aws_instance" "ec2" {
  ami           = "ami-0533f2ba8a1995cf9"  # The Amazon Machine Image (AMI) ID for Amazon Linux 2.
  instance_type = "t2.micro"  # Instance type (smallest instance).
  key_name      = "MyKeyPair"  # Specify the SSH key pair to access the instance.

  # Place the EC2 instance in the public subnet.
  subnet_id                   = aws_subnet.some_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]  # Attach the security group to the instance.
  associate_public_ip_address = true  # Associate a public IP address for internet access.

  # Define the user data to configure the instance when it starts.
  user_data = <<-EOF
  #!/bin/bash -ex

  # Install nginx web server.
  amazon-linux-extras install nginx1 -y
  
  # Customize the index page with a quote from the Kanye API.
  echo "<h1>$(curl https://api.kanye.rest/?format=text)</h1>" >  /usr/share/nginx/html/index.html 

  # Enable and start nginx service.
  systemctl enable nginx
  systemctl start nginx
  EOF

  # Apply a tag to identify the instance.
  tags = {
    "Name" : "ola"
  }
}
