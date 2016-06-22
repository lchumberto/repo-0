# Provider spcific
provider "aws" {
	region = "${var.aws_region}"
	access_key = "${var.aws_access_key}"
	secret_key = "${var.aws_access_secret_key}"

}

# Variables for VPC module
module "vpc_subnets" {
	source = "./modules/vpc_subnets"
	name = "${var.domain_name}"
	environment = "dev"
	enable_dns_support = true
	enable_dns_hostnames = true
	vpc_cidr = "172.16.0.0/16"
    public_subnets_cidr = "172.16.10.0/24,172.16.20.0/24"
    private_subnets_cidr = "172.16.30.0/24,172.16.40.0/24"
    azs    = "${var.aws_region}b,${var.aws_region}c"
}

module "ssh_sg" {
	source = "./modules/ssh_sg"
	name = "${var.domain_name}"
	environment = "dev"
	vpc_id = "${module.vpc_subnets.vpc_id}"
	source_cidr_block = "0.0.0.0/0"
}

module "web_sg" {
	source = "./modules/web_sg"
	name = "${var.domain_name}"
	environment = "dev"
	vpc_id = "${module.vpc_subnets.vpc_id}"
	source_cidr_block = "0.0.0.0/0"
}


module "ec2key" {
	source = "./modules/ec2key"
	key_name = "${var.domain_name}"
	public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbcQl9GxdMBXe2KEJPdb9V6CgOF2ADW1I4XJturAbfMoH4U5/lACeU8aq6rGG85uAeqGw2MhPZoFeDEOmCbKgk+/xkRfOWUcShJoKmxZBXmW28hqs3RSc8pFZdrxvMdR7a4nLjEpbmteTmHdo+XXcFyYt1nlj+OsOFcbIzGjal4fEmOy1NQo7MD8TCvefYOAcsWUuT1t5yxJTDS+OYbeitUjqOKJ/NqLTDbIEJARlEyYpe2+FXoFyp2A6vVa1zg47PdP2nOckRIpQ2h3c8IourX5BgrTpAcdGj8pqMQLZl421g0XVgzlZ5/xpAfxKdZf3ihSTItv6NoJeUEtPo/9cd"
}

module "ec2" {
	source = "./modules/ec2"
	name = "${var.domain_name}"
	environment = "dev"
	server_role = "web"
	ami_id = "${var.aws_region_ami}"
	key_name = "${module.ec2key.ec2key_name}"
	count = "1"
	security_group_id = "${module.ssh_sg.ssh_sg_id},${module.web_sg.web_sg_id}"
	subnet_id = "${module.vpc_subnets.public_subnets_id}"
	instance_type = "t2.nano"
	user_data = "#!/bin/bash\napt-get -y update\napt-get -y install nginx\n"
}

