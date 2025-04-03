resource "aws_instance" "ze_instance_blue" {
  ami                         = "ami-0446057e5961dfab6"
  instance_type               = "t2.micro"
  availability_zone           = var.az_euw[0]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.ze_pubsbn_1.id
  iam_instance_profile        = aws_iam_instance_profile.ze_ssm_profile.id
  security_groups             = [aws_security_group.ze_sg.id]
  user_data                   = file("${path.module}/setup/ec2-userdata_blue.sh")




  tags = {
    Name = "instance projet alternance 1"
  }
}

resource "aws_instance" "ze_instance_red" {
  ami                         = "ami-0446057e5961dfab6"
  instance_type               = "t2.micro"
  availability_zone           = var.az_euw[1]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.ze_pubsbn_2.id
  iam_instance_profile        = aws_iam_instance_profile.ze_ssm_profile.id
  security_groups             = [aws_security_group.ze_sg.id]
  user_data                   = file("${path.module}/setup/ec2-userdata_red.sh")



  tags = {
    Name = "instance projet alternance 2"
  }
}