resource "github_repository_collaborator" "softservedata" {
  repository = "github-terraform-task-wulfhere30"
  username   = "softservedata"
  permission = "push"
}

resource "github_branch" "develop" {
  repository = "github-terraform-task-wulfhere30"
  branch     = "develop"
}

resource "github_branch_default" "develop" {
  repository = "github-terraform-task-wulfhere30"
  branch     = github_branch.develop.branch
}

resource "github_branch_protection" "main" {
  repository_id  = "github-terraform-task-wulfhere30"
  pattern        = "main"
  enforce_admins = true

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
    required_approving_review_count = 1
  }
}

resource "github_branch_protection" "develop" {
  repository_id  = "github-terraform-task-wulfhere30"
  pattern        = github_branch.develop.branch
  enforce_admins = true

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = false
    required_approving_review_count = 2
  }
}

resource "github_repository_file" "pull_request_template" {
  repository = "github-terraform-task-wulfhere30"
  file       = ".github/pull_request_template.md"
  content    = <<EOF
##Describe your changes
##Issue ticket number and link
##Checklist before requesting a review
 - [] I have performed a self-review of my code
 - [] If it is a core feature, I have added thorough tests
 - [] Do we need to implement analytics?
 - [] Will this be part of a product update? If yes, please write one phrase about this update
EOF
}

resource "github_repository_deploy_key" "deploy_key" {
  title      = "DEPLOY_KEY"
  repository = "github-terraform-task-wulfhere30"
  key        = var.deploy_key_public_key
}

resource "github_actions_secret" "pat_secret" {
  repository      = github_repository.this.name
  secret_name     = "PAT"
  plaintext_value = var.pat_token
}
