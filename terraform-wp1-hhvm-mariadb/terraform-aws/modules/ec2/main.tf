resource "aws_instance" "ec2" {
  ami = "${var.ami_id}"
  vpc_security_group_ids = ["${split(",", var.security_group_id)}"]
  key_name = "${var.key_name}"
  instance_type = "${var.instance_type}"
  count = "${var.count}" 
  subnet_id = "${element(split(",", var.subnet_id), count.index%2)}"
  root_block_device {
        volume_type = "${var.ebs_root_volume_type}"
        volume_size = "${var.ebs_root_volume_size}"
        delete_on_termination = "${var.ebs_root_delete_on_termination}"
  }
  tags {
    Name        = "${var.name}-${var.environment}-${format("%02d", count.index+1)}"
    environment = "${var.environment}"
    server_role = "${var.server_role}"
  }
  user_data = "${var.user_data}"
}

provisioner "local-exec" {
    command = "echo WEBSITE_NAME: ${var.name}.com >> ${var.name}-${var.environment}.yml; echo DB_HOSTNAME: ${var.db_hostname} >> ${var.name}-${var.environment}.yml; echo DB_NAME: ${var.db_name} >> ${var.name}-${var.environment}.yml; echo DB_PASSWORD: ${var.db_password} >> ${var.name}-${var.environment}.yml; echo DB_USERNAME: ${var.db_username} >> ${var.name}-${var.environment}.yml"
  }

output "ec2_id" {
  value = "${join(",", aws_instance.ec2.*.id)}"
}