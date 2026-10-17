resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.project}-db-subnet-group"
  }
}


resource "aws_db_instance" "this" {
  identifier              = "${var.project}-db"
  allocated_storage       = 20
  engine                  = "postgres"
  instance_class          = var.instance_class
  storage_type =            "gp3"
  storage_encrypted =       true
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [var.db_sg_id]
  multi_az                = var.multi_az
  publicly_accessible =     false
  skip_final_snapshot =     true

  tags = {
    Name = "${var.project}-db"
  }
}