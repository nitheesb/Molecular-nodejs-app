# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  name                = "moleculer-app-asg"
  max_size            = 2
  min_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = aws_vpc.vpc.public_subnets

  launch_configuration = aws_launch_configuration.lc.id
}

# Launch Configuration for Auto Scaling Group
resource "aws_launch_configuration" "lc" {
  image_id      = aws_instance.api_instance.id
  instance_type = "m5.large"
  key_name      = local.key_name

  user_data = <<EOF
#!/bin/bash

curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g moleculer
sudo npm install moleculer
sudo npm install moleculer-web
sudo npm install moleculer-nats-transporter

EOF
}

# Auto Scaling Launch Policy
resource "aws_autoscaling_policy" "asg_policy" {
  name               = "autoscalegroup_policy"
  scaling_adjustment = 2
  adjustment_type    = "ChangeInCapacity"
  # The amount of time (seconds) after a scaling completes and the next scaling starts.
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

# Cloudwatch Alarm for Auto Scaling Group
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name          = "Molecular_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  alarm_actions = [
    "${aws_autoscaling_policy.asg_policy.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
  }
}
