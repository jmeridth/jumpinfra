resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.stack_name}-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.stack_name}-ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_policy" "kms" {
  name        = "${var.stack_name}-kms-cluster"
  description = "Policy that allows ecs cluster kms decrption"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "logs" {
  name        = "${var.stack_name}-logs"
  description = "Policy that allows logging for ecs cluster"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:DescribeLogGroups",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "execute_command" {
  name        = "${var.stack_name}-task-policy-execute-command"
  description = "Policy that allows access to ecs containers"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb" {
  name        = "${var.stack_name}-task-policy-dynamodb"
  description = "Policy that allows access to DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:CreateTable",
          "dynamodb:UpdateTimeToLive",
          "dynamodb:PutItem",
          "dynamodb:DescribeTable",
          "dynamodb:ListTables",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:UpdateTable"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_execute_command_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.execute_command.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.dynamodb.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_execute_command_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.execute_command.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_kms_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.kms.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_logs_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.logs.arn
}
