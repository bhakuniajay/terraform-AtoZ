resource "aws_iam_group" "education" {
  name = "Educaiton"
  path ="/groups/"
}

resource "aws_iam_group_membership" "education_members" {
  name = "Education-group-membership"
  group = aws_iam_group.education.name

  users = [
    for user in aws_iam_user.users : user.name if user.tags.Department == "Education"
  ]
}