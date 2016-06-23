
variable aws_region {
	description = "Enter AWS region. i.e. us-west-1"
}
variable domain_name {
	description = "Put domain without '.com' or any other ext"
}

variable aws_access_key {
        description = "Enter your AWS Access Key"
}
variable aws_access_secret_key {
        description = "Enter your AWS Secret Key"
}
variable aws_region_ami{
	description = "Enter your Desired AMI, remember that it deppends on the zone you choose, all of them are ubuntu\nus-east-1 ami-fce3c696\nus-west-1 ami-06116566\nus-west-2 ami-9abea4fb "
}

variable db_name {
	description = "Name of your database application"
}

variable db_password {
	description = "password for your database"
}

variable db_username {
	description = "username for your database"
}

variable db_hostname {
	description = "hostname for your database, If the database is hosted locally the we can just input localhost"
}