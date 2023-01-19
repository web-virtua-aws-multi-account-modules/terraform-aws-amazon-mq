locals {
  tags_default = {
    "Name"      = var.name
    "tf-aws-mq" = var.name
    "tf-ou"     = var.ou_name
  }
}

resource "aws_mq_broker" "create_aws_mq" {
  broker_name         = var.name
  engine_type         = var.engine_type
  engine_version      = var.engine_version
  host_instance_type  = var.host_instance_type
  publicly_accessible = var.publicly_accessible
  apply_immediately   = var.apply_immediately
  security_groups     = var.security_groups_ids
  subnet_ids          = var.subnets_ids
  tags                = merge(var.tags, var.use_tags_default ? local.tags_default : {})

  authentication_strategy    = var.authentication_strategy
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  deployment_mode            = var.deployment_mode
  storage_type               = var.storage_type

  dynamic "user" {
    for_each = (var.user_adm != null && var.password_adm != null) ? [1] : []

    content {
      username = var.user_adm
      password = var.password_adm
    }
  }

  logs {
    audit   = var.logs_audit
    general = var.logs_general
  }

  dynamic "encryption_options" {
    for_each = var.encryption_options != null ? [var.encryption_options] : []

    content {
      kms_key_id        = encryption_options.value.kms_key_id
      use_aws_owned_key = encryption_options.value.use_aws_owned_key
    }
  }

  dynamic "maintenance_window_start_time" {
    for_each = var.maintenance_window_start_time != null ? [var.maintenance_window_start_time] : []

    content {
      day_of_week = maintenance_window_start_time.value.day_of_week
      time_of_day = maintenance_window_start_time.value.time_of_day
      time_zone   = maintenance_window_start_time.value.time_zone
    }
  }

  dynamic "configuration" {
    for_each = ((var.make_mq_configuration || var.configuration_id != null) && var.engine_type == "ActiveMQ") ? [1] : []

    content {
      id       = try(aws_mq_configuration.create_aws_mq_configuration[0].id, var.configuration_id)
      revision = try(aws_mq_configuration.create_aws_mq_configuration[0].latest_revision, var.configuration_revision)
    }
  }

  dynamic "ldap_server_metadata" {
    for_each = var.ldap_server_metadata != null ? [var.ldap_server_metadata] : []

    content {
      hosts                    = ldap_server_metadata.value.hosts
      role_base                = ldap_server_metadata.value.role_base
      role_name                = ldap_server_metadata.value.role_name
      role_search_matching     = ldap_server_metadata.value.role_search_matching
      role_search_subtree      = ldap_server_metadata.value.role_search_subtree
      service_account_password = ldap_server_metadata.value.service_account_password
      service_account_username = ldap_server_metadata.value.service_account_username
      user_base                = ldap_server_metadata.value.user_base
      user_role_name           = ldap_server_metadata.value.user_role_name
      user_search_matching     = ldap_server_metadata.value.user_search_matching
      user_search_subtree      = ldap_server_metadata.value.user_search_subtree
    }
  }
}

resource "aws_mq_configuration" "create_aws_mq_configuration" {
  count = (var.make_mq_configuration && var.engine_type == "ActiveMQ") ? 1 : 0

  description    = var.mq_configuration_description
  name           = "${var.name}-mq-configuration"
  engine_type    = var.mq_engine_type != null ? var.mq_engine_type : var.engine_type
  engine_version = var.mq_engine_version != null ? var.mq_engine_version : var.engine_version

  data = var.mq_configuration_data
}
