resource "aws_autoscaling_group" "ec2_asg" {
  max_size            = var.alb_max_size
  min_size            = var.alb_min_size
  desired_capacity    = var.alb_desired_size
  name                = "custom-web-server-asg"
  target_group_arns   = [aws_lb_target_group.alb_ec2_tg.arn]
  vpc_zone_identifier = aws_subnet.private_subnet[*].id

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }

  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "custom-ec2-web-server"
    propagate_at_launch = true
  }
}

# Read and modify the user data script
data "template_file" "userdata_script" {
  template = file("${path.module}/userdata.sh")

  vars = {
    loki_ip = aws_instance.loki_server.private_ip
  }
}

resource "aws_launch_template" "ec2_launch_template" {
  name          = "custom-ec2-launch-template"
  image_id      = var.image_id
  instance_type = var.image_type

  network_interfaces {
    associate_public_ip_address = var.public_ip
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  # Use the rendered user data script with Base64 encoding
  user_data = base64encode(data.template_file.userdata_script.rendered)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "custom-ec2-web-server"
    }
  }
}
