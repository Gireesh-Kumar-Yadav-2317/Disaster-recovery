output "fis_experiment_template_id" {

  description = "FIS Experiment Template ID"

  value = aws_fis_experiment_template.ec2_stop.id
}

output "cpu_stress_experiment_id" {

  value = aws_fis_experiment_template.cpu_stress.id
}

output "network_latency_experiment_id" {

  value = aws_fis_experiment_template.network_latency.id
}

output "multi_instance_stop_experiment_id" {

  value = aws_fis_experiment_template.multi_instance_stop.id
}