provider "aws" {
  region = "us-east-2"
}

module "vpc" {
source = "./myvpc"
vpc_cidr_block = "10.0.0.0/16"
subnet_cidr_block = "10.0.1.0/24"
}


resource "aws_instance" "vm" {
  ami           = "ami-067a8829f9ae24c1c" 
  subnet_id     = module.vpc.subnet_id 
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [module.vpc.sg_id]
  tags = {
    Name = "my-first-tf-node"
  }
  provisioner "local-exec" {
  when = destroy 
  command = "echo 'This is for destroying resources'"
}
}

