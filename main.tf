variable "github_token" {
  description = "The GitHub token"
  default     = "PAT"
}

variable "github_owner" {
  description = "The GitHub owner"
  default     = "Practical-DevOps-GitHub"
}

variable "repository_name" {
  description = "The name of the repository"
  default     = "github-terraform-task-wulfhere30"
}

provider "github" {
  token        = var.github_token
  owner        = var.github_owner
}


resource "github_repository" "repository" {
  name         = var.repository_name
  description  = "Your repository description"
  homepage_url = "https://github.com/${var.github_owner}/${var.repository_name}"
  private      = false
}

resource "github_branch" "develop" {
  repository = github_repository.repository.name
  branch     = "develop"
}

resource "github_branch_default" "default" {
  repository = github_repository.repository.name
  branch     = github_branch.develop.branch
}

resource "github_repository_collaborator" "collaborator" {
  repository = github_repository.repository.name
  username   = "softservedata"
  permission = "push"
}

resource "github_branch_protection" "main" {
  repository_id = github_repository.repository.node_id
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["ci/travis"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews = true
    require_code_owner_reviews = true
  }

  enforce_admins = true
}

resource "github_branch_protection" "develop" {
  repository_id = github_repository.repository.node_id
  pattern       = "develop"

  required_status_checks {
    strict   = true
    contexts = ["ci/travis"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews = true
    require_code_owner_reviews = false
    required_approving_review_count = 2
  }

  enforce_admins = true
}

resource "github_repository_deploy_key" "deploy_key" {
  title      = "DEPLOY_KEY"
  repository = github_repository.repository.name
  key        = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBDVNwt5xZYOVldpVQ3oX1BfyfH4Cu/YltawwynWXPDP wulfhere30@gmail.com"
  read_only  = true
}

// Provide data related to the already created Discord server
data "github_actions_secret" "discord_secret" {
  repository      = github_repository.repository.name
  secret_name     = "DISCORD_WEBHOOK_URL"
  plaintext_value = "https://discord.com/api/webhooks/1137024782425145385/j6cfxym2xq_OgMHQhc1mz9aaW-Mr3Ysmw5othL9y95fIZgXKy87v-7jbY0gLDPkRj7i8"
}

// For GitHub Actions, you have to manually create the PAT and provide it here.
data "github_actions_secret" "pat_secret" {
  repository      = github_repository.repository.name
  secret_name     = "PAT"
  plaintext_value = var.github_token
}
