output "listofvm" {
  value = aws_instance.example[*].id
}