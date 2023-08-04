provider "github" {
  organization = "softservedata"
  token = var.github_token
}

resource "github_repository" "github-terraform-task-wulfhere30" {
  name = "github-terraform-task-wulfhere30"
  description = "My repository"
  homepage = "https://github.com/Practical-DevOps-GitHub/github-terraform-task-wulfhere30"
  visibility = "public"
}

resource "github_repository_collaborator" "collaborator" {
  repository = "github-terraform-task-wulfhere30"
  username   = "softservedata"
  permission = "push"
}
