resource "aws_launch_template" "this" {
    name_prefix = "${local.name_prefix}-lt"

    image_id = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type

    vpc_security_group_ids = [var.ec2_security_group_id]

    iam_instance_profile {
      name = var.instance_profile_name


    }

    user_data = base64encode(
        file("${path.module}/userdata.sh")
    )


    metadata_options {
      http_endpoint = "enabled"
      http_tokens = "required"
      http_put_response_hop_limit = 2


    }

    block_device_mappings {

    device_name = "/dev/xvda"

    ebs {

      volume_size = var.root_volume_size

      volume_type = "gp3"

      encrypted = true

      delete_on_termination = true
    }
  }

  monitoring {
    enabled = true
  }


  tag_specifications {

    resource_type = "instance"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.name_prefix}-ec2"
      }
    )
  }

  tag_specifications {

    resource_type = "volume"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.name_prefix}-ebs"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }

  update_default_version = true
}

