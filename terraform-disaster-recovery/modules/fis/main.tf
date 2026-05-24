resource "aws_fis_experiment_template" "ec2_stop" {
    description = "Ec2 stop resiliency test"

    role_arn = var.fis_role_arn

    target {
        name = "asg_instance"

        resource_type = "aws:ec2:instance"

        selection_mode = "COUNT(1)"

        resource_tag {
            key = "aws:autoscaling:groupName"
            value = var.autoscaling_group_name

        }
    }


    action {
        name = "stop_instances"

        action_id = "aws:ec2:stop-instances"

        target {
          key = "Instances"

          value = "asg_instances"

        }
    }

     stop_condition {

    source = "none"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-fis-stop-test"
    }
  )
}


resource "aws_fis_experiment_template" "cpu_stress" {

  description = "CPU stress resiliency test"

  role_arn = var.fis_role_arn

  target {

    name = "asg_instances"

    resource_type = "aws:ec2:instance"

    selection_mode = "COUNT(1)"

    resource_tag {

      key = "aws:autoscaling:groupName"

      value = var.autoscaling_group_name
    }
  }

  action {

    name = "cpu_stress"

    action_id = "aws:ssm:send-command"

    parameter {

      key = "documentArn"

      value = "arn:aws:ssm:${data.aws_region.current.region}::document/AWSFIS-Run-CPU-Stress"
    }

    parameter {

      key = "documentParameters"

      value = jsonencode({
        DurationSeconds = "120"
        InstallDependencies = "True"
        CPU = "80"
      })
    }

    target {

      key = "Instances"

      value = "asg_instances"
    }
  }

  stop_condition {
    source = "none"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-cpu-stress"
    }
  )
}


resource "aws_fis_experiment_template" "network_latency" {

  description = "Network latency resiliency test"

  role_arn = var.fis_role_arn

  target {

    name = "asg_instances"

    resource_type = "aws:ec2:instance"

    selection_mode = "COUNT(1)"

    resource_tag {

      key = "aws:autoscaling:groupName"

      value = var.autoscaling_group_name
    }
  }


  action {

    name = "network_latency"

    action_id = "aws:ssm:send-command"

    parameter {

      key = "documentArn"

      value = "arn:aws:ssm:${data.aws_region.current.region}::document/AWSFIS-Run-Network-Latency"
    }

    parameter {

      key = "documentParameters"

      value = jsonencode({
        DurationSeconds = "120"
        DelayMilliseconds = "200"
      })
    }

    target {

      key = "Instances"

      value = "asg_instances"
    }
  }

  stop_condition {
    source = "none"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-network-latency"
    }
  )
}


resource "aws_fis_experiment_template" "multi_instance_stop" {

  description = "Multi-instance stop resiliency test"

  role_arn = var.fis_role_arn

  target {

    name = "asg_instances"

    resource_type = "aws:ec2:instance"

    selection_mode = "PERCENT(50)"

    resource_tag {

      key = "aws:autoscaling:groupName"

      value = var.autoscaling_group_name
    }
  }

  action {

    name = "stop_instances"

    action_id = "aws:ec2:stop-instances"

    target {

      key = "Instances"

      value = "asg_instances"
    }
  }

  stop_condition {
    source = "none"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-multi-stop"
    }
  )
}

data "aws_region" "current" {}