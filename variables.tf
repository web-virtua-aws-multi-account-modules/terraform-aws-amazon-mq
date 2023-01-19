variable "name" {
  description = "Name to broker AmazonMQ"
  type        = string
}

variable "subnets_ids" {
  description = "Subnets groups IDs"
  type        = list(string)
}

variable "user_adm" {
  description = "User to RabbitMQ, It's required to RabbitMQ"
  type        = string
  default     = null
}

variable "password_adm" {
  description = "Password to RabbitMQ, It's required to RabbitMQ"
  type        = string
  default     = null
}

variable "encryption_options" {
  description = "Encryption options to AmazonMQ"
  type = object({
    kms_key_id        = optional(string)
    use_aws_owned_key = optional(bool)
  })
  default = null
}

variable "maintenance_window_start_time" {
  description = "Maintenance window start time to AmazonMQ"
  type = object({
    day_of_week = string
    time_of_day = string
    time_zone   = string
  })
  default = null
}

variable "security_groups_ids" {
  description = "Security groups IDs, is required to both if the private access and also to ActiveMQ with public access"
  type        = list(string)
  default     = null
}

variable "engine_type" {
  description = "Engine to AmazonMQ, can be ActiveMQ or RabbitMQ"
  type        = string
  default     = "RabbitMQ"
}

variable "engine_version" {
  description = "Engine version to AmazonMQ"
  type        = string
  default     = "3.9.16"
}

variable "host_instance_type" {
  description = "Host instance type to AmazonMQ"
  type        = string
  default     = "mq.t3.micro"
}

variable "publicly_accessible" {
  description = "Enable publicly accessible"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply modifies immediately to AmazonMQ"
  type        = bool
  default     = true
}

variable "logs_audit" {
  description = "Logs audit to AmazonMQ"
  type        = bool
  default     = false
}

variable "logs_general" {
  description = "Enable or desable logs general to AmazonMQ"
  type        = bool
  default     = true
}

variable "configuration_id" {
  description = "Configuration ID existing"
  type        = string
  default     = null
}

variable "configuration_revision" {
  description = "Configuration revision existing"
  type        = number
  default     = null
}

variable "make_mq_configuration" {
  description = "If true will be create a new AWS MQ Configuration, It's only work with ActiveMQ"
  type        = bool
  default     = false
}

variable "mq_configuration_description" {
  description = "MQ configuration description, It's only work with ActiveMQ"
  type        = string
  default     = null
}

variable "mq_engine_type" {
  description = "Engine to RabbitMQ, can be ActiveMQ or ActiveMQ"
  type        = string
  default     = null
}

variable "mq_engine_version" {
  description = "Engine version to ActiveMQ"
  type        = string
  default     = null
}

variable "mq_configuration_data" {
  description = "AmazonMQ configuration data, It's only work with ActiveMQ"
  type        = string
  default     = null
}

variable "authentication_strategy" {
  description = "Authentication strategy used to secure the broker. Valid values are simple and ldap. ldap is not supported for engine_type RabbitMQ"
  type        = string
  default     = null
}

variable "auto_minor_version_upgrade" {
  description = "Whether to automatically upgrade to new minor versions of brokers as Amazon MQ makes releases available"
  type        = bool
  default     = null
}

variable "deployment_mode" {
  description = "Deployment mode of the broker. Valid values are SINGLE_INSTANCE, ACTIVE_STANDBY_MULTI_AZ, and CLUSTER_MULTI_AZ. Default is SINGLE_INSTANCE"
  type        = string
  default     = "SINGLE_INSTANCE"
}

variable "storage_type" {
  description = "Storage type of the broker. For engine_type ActiveMQ, the valid values are efs and ebs, and the AWS-default is efs. For engine_type RabbitMQ, only ebs is supported. When using ebs, only the mq.m5 broker instance type family is supported"
  type        = string
  default     = null
}

variable "use_tags_default" {
  description = "If true will be use the tags default to AmazonMQ"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to load AmazonMQ"
  type        = map(any)
  default     = {}
}

variable "ou_name" {
  description = "Organization unit name"
  type        = string
  default     = "no"
}

variable "ldap_server_metadata" {
  description = "Configuration block for the LDAP server used to authenticate and authorize connections to the broker. Not supported for engine_type RabbitMQ. Detailed below. (Currently, AWS may not process changes to LDAP server metadata.)"
  type = object({
    hosts                    = optional(string)
    role_base                = optional(string)
    role_name                = optional(string)
    role_search_matching     = optional(string)
    role_search_subtree      = optional(bool)
    service_account_password = optional(string)
    service_account_username = optional(string)
    user_base                = optional(string)
    user_role_name           = optional(string)
    user_search_matching     = optional(string)
    user_search_subtree      = optional(bool)
  })
  default = null
}
