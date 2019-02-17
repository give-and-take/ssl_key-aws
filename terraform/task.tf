# parse task file
data "template_file" "task" {
    template    = "${file("task.json")}"
    vars {
        env     = "${var.env}"
    }
}

# create task definition
resource "aws_ecs_task_definition" "service" {
    family          = "ssl-app-${var.env}"
    network_mode    = "awsvpc"
    requires_compatibilities = ["FARGATE"]
	cpu             = 256 
	memory          = 512
    execution_role_arn = "arn:aws:iam::324139215624:role/ecsTaskExecutionRole"
    container_definitions = "${data.template_file.task.rendered}"

    tags {
        Name        = "ssl-taskdefs"
        Creator     = "ssl"
        Environment = "${var.env}"
        Description = "Task definition for ssl app."
    }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf