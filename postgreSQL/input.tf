variable "user" {
  type        = string
  default     = "postgres"
  description = "Admin user name."
}

variable "password" {
  type        = string
  default     = "postgres"
  description = "Password for the admin user."
}

variable "db_name" {
  type        = string
  default     = "db"
  description = "Name of the database."
}

variable "init_queries_path" {
  type        = string
  default     = path.module
  description = "Path to init scripts."
}