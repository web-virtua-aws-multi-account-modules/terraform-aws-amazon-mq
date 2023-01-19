# AWS AmazonMQ for multiples accounts and regions with Terraform module
* This module simplifies creating and configuring of a AmazonMQ across multiple accounts and regions on AWS

* Is possible use this module with one region using the standard profile or multi account and regions using multiple profiles setting in the modules.

## Actions necessary to use this module:

* Create file versions.tf with the exemple code below:
```hcl
terraform {
  required_version = ">= 1.1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
  }
}
```

* Criate file provider.tf with the exemple code below:
```hcl
provider "aws" {
  alias   = "alias_profile_a"
  region  = "us-east-1"
  profile = "my-profile"
}

provider "aws" {
  alias   = "alias_profile_b"
  region  = "us-east-2"
  profile = "my-profile"
}
```


## Features enable of AmazonMQ configurations for this module:

- Broker
- MQ Configuration

## Usage exemples

### Rabbit MQ single zone, backup window and public access

```hcl
module "rabbit_mq" {
  source              = "web-virtua-aws-multi-account-modules/amazon-mq/aws"
  name                = "tf-rabbit-mq"
  engine_version      = "3.9.16"
  host_instance_type  = "mq.t3.micro"
  publicly_accessible = true
  user_adm            = "your-user"
  password_adm        = "your-password"
  logs_general        = true

  maintenance_window_start_time = {
    day_of_week = "MONDAY"
    time_of_day = "02:00"
    time_zone   = "America/Sao_Paulo"
  }

  subnets_ids = [
    "subnet-0ecce...cfd9"
  ]

  providers = {
    aws = aws.alias_profile_b
  }
}
```

### Active MQ single zone and public access

```hcl
module "active_mq" {
  source              = "web-virtua-aws-multi-account-modules/amazon-mq/aws"
  name                = "tf-active-mq"
  engine_type         = "ActiveMQ"
  engine_version      = "5.15.9"
  host_instance_type  = "mq.t3.micro"
  user_adm            = "your-user"
  password_adm        = "your-password"
  logs_general        = true

  security_groups_ids = [
    "sg-018620a...764c"
  ]

  subnets_ids = [
    "subnet-0ecce...cfd9"
  ]

  providers = {
    aws = aws.alias_profile_b
  }
}
```

### Active MQ single zone, public access and MQ configuration

```hcl
module "active_mq_complete" {
  source                = "web-virtua-aws-multi-account-modules/amazon-mq/aws"
  name                  = "tf-active-mq-complete"
  engine_type           = "ActiveMQ"
  engine_version        = "5.15.9"
  host_instance_type    = "mq.t3.micro"
  user_adm              = "your-user"
  password_adm          = "your-password"
  logs_general          = true
  publicly_accessible   = true
  make_mq_configuration = true
  deployment_mode       = "ACTIVE_STANDBY_MULTI_AZ"

  maintenance_window_start_time = {
    day_of_week = "MONDAY"
    time_of_day = "02:00"
    time_zone   = "America/Sao_Paulo"
  }

  mq_configuration_data = <<DATA
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<broker xmlns="http://activemq.apache.org/schema/core">
  <plugins>
    <forcePersistencyModeBrokerPlugin persistenceFlag="true"/>
    <statisticsBrokerPlugin/>
    <timeStampingBrokerPlugin ttlCeiling="86400000" zeroExpirationOverride="86400000"/>
  </plugins>
</broker>
DATA

  security_groups_ids = [
    "sg-018620a...764c"
  ]

  subnets_ids = [
    "subnet-0ecce...cfd9"
  ]

  providers = {
    aws = aws.alias_profile_b
  }
}
```

### Rabbit MQ multi AZ and private access

```hcl
module "rabbit_mq_az" {
  source                = "web-virtua-aws-multi-account-modules/amazon-mq/aws"
  name                  = "tf-rabbit-mq-az"
  engine_type           = "RabbitMQ"
  engine_version        = "3.9.16"
  host_instance_type    = "mq.t3.micro"
  user_adm              = "your-user"
  password_adm          = "your-password"
  logs_general          = true
  publicly_accessible   = false
  deployment_mode       = "CLUSTER_MULTI_AZ"

  maintenance_window_start_time = {
    day_of_week = "MONDAY"
    time_of_day = "02:00"
    time_zone   = "America/Sao_Paulo"
  }

  security_groups_ids = [
    "sg-018620a...764c"
  ]
  
  subnets_ids = [
    "subnet-0ecce...cfd9",
    "subnet-0ecce...cfdr"
  ]

  providers = {
    aws = aws.alias_profile_b
  }
}
```

## Variables

| Name | Type | Default | Required | Description | Options |
|------|-------------|------|---------|:--------:|:--------|
| name | `string` | `-` | yes | Name to broker AmazonMQ | `-` |
| subnets_ids | `list(string)` | `-` | yes | Subnets groups IDs | `-` |
| user_adm | `string` | `null` | no | User to RabbitMQ, It's required to RabbitMQ | `-` |
| password_adm | `string` | `null` | no | Password to RabbitMQ, It's required to RabbitMQ | `-` |
| encryption_options | `object` | `null` | no | Encryption options to AmazonMQ | `-` |
| maintenance_window_start_time | `object` | `null` | no | Maintenance window start time to AmazonMQ | `-` |
| security_groups_ids | `list(string)` | `-` | no | Security groups IDs, is required to both if the private access and also to ActiveMQ with public access | `-` |
| engine_type | `string` | `RabbitMQ` | no | Engine to AmazonMQ, can be ActiveMQ or RabbitMQ | `*`RabbitMQ <br> `*`ActiveMQ |
| engine_version | `string` | `3.9.16` | no | Engine version to AmazonMQ | `-` |
| host_instance_type | `string` | `mq.t3.micro` | no | Host instance type to AmazonMQ | `-` |
| publicly_accessible | `bool` | `true` | no | Enable publicly accessible | `*`false <br> `*`true |
| apply_immediately | `bool` | `true` | no | Apply modifies immediately to AmazonMQ | `*`false <br> `*`true |
| logs_audit | `bool` | `false` | no | Logs audit to AmazonMQ | `*`false <br> `*`true |
| logs_general | `bool` | `true` | no | Enable or desable logs general to AmazonMQ | `*`false <br> `*`true |
| configuration_id | `string` | `null` | no | Configuration ID existing | `-` |
| configuration_revision | `number` | `null` | no | Configuration revision existing | `-` |
| make_mq_configuration | `bool` | `false` | no | If true will be create a new AWS MQ Configuration, It's only work with ActiveMQ | `*`false <br> `*`true |
| mq_configuration_description | `string` | `null` | no | MQ configuration description, It's only work with ActiveMQ | `-` |
| mq_engine_type | `string` | `null` | no | Engine to RabbitMQ, can be ActiveMQ or ActiveMQ | `-` |
| mq_engine_version | `string` | `null` | no | Engine version to ActiveMQ | `-` |
| mq_configuration_data | `string` | `null` | no | AmazonMQ configuration data, It's only work with ActiveMQ | `-` |
| authentication_strategy | `string` | `null` | no | Authentication strategy used to secure the broker. Valid values are simple and ldap. ldap is not supported for engine_type RabbitMQ | `*`simple <br> `*`ldap |
| auto_minor_version_upgrade | `bool` | `null` | no | Whether to automatically upgrade to new minor versions of brokers as Amazon MQ makes releases available | `*`false <br> `*`true |
| deployment_mode | `string` | `SINGLE_INSTANCE` | no | Deployment mode of the broker. Valid values are SINGLE_INSTANCE, ACTIVE_STANDBY_MULTI_AZ, and CLUSTER_MULTI_AZ. Default is SINGLE_INSTANCE | `*`SINGLE_INSTANCE <br> `*`ACTIVE_STANDBY_MULTI_AZ <br> `*`CLUSTER_MULTI_AZ |
| storage_type | `string` | `null` | no | Storage type of the broker. For engine_type ActiveMQ, the valid values are efs and ebs, and the AWS-default is efs. For engine_type RabbitMQ, only ebs is supported. When using ebs, only the mq.m5 broker instance type family is supported | `*`efs <br> `*`ebs |
| use_tags_default | `bool` | `true` | no | If true will be use the tags default to AmazonMQ | `*`false <br> `*`true |
| tags | `map(any)` | `{}` | no | Tags to resources | `-` |
| ou_name | `string` | `no` | no | Organization unit name | `-` |
| ldap_server_metadata | `object` | `null` | no | Configuration block for the LDAP server used to authenticate and authorize connections to the broker. Not supported for engine_type RabbitMQ. Detailed below. (Currently, AWS may not process changes to LDAP server metadata.) | `-` |


## Resources

| Name | Type |
|------|------|
| [aws_mq_broker.create_aws_mq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker) | resource |
| [aws_mq_configuration.create_aws_mq_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_configuration) | resource |

## Outputs

| Name | Description |
|------|-------------|
| `admin_username` | AmazonMQ admin username |
| `broker_id` | AmazonMQ broker ID |
| `broker_arn` | AmazonMQ broker ARN |
| `instances` | AmazonMQ information intances |
| `primary_console_url` | AmazonMQ active web console URL |
| `primary_ssl_endpoint` | Console URL and endpoints |
| `primary_ip_address` | AmazonMQ primary IP address |
| `storage_type` | AmazonMQ storage type |
| `maintenance_window` | AmazonMQ maintenance window start time |
