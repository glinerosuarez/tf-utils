variable "root_password" {
  type        = string
  default     = "password"
  description = "Password for the admin user."
}

variable "db_name" {
  type        = string
  default     = "db"
  description = "Name of the database."
}

variable "init_queries_path" {
  type        = string
  default     = null
  nullable    = true
  description = "Path to init scripts."
}