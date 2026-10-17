variable "project" {
    type = string
  
}


variable "db_username" {
    type = string
  
}




variable "db_password" {
    type = string
    sensitive = true
  
}



variable "instance_class" {
    type = string
  
}



variable "multi_az" {
    type = bool
  
}


variable "db_sg_id" {
    type = string
  
}

variable "db_subnet_ids" {
    type = list(string)
}