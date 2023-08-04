provider "github" {
  organization = "my-organization"
  token = var.github_token
}

resource "github_repository" "my-repository" {
  name = "my-repository"
  description = "My repository"
  homepage = "https://github.com/my-organization/my-repository"
  visibility = "public"

  collaborator {
    username = "softservedata"
  }

  default_branch = "develop"

  branch_protection {
    branch = "main"
    required_pull_request_reviews = 2
    allow_merge_on_conflict = false
    code_owner_reviews_required = true
  }

  branch_protection {
    branch = "develop"
    required_pull_request_reviews = 1
    allow_merge_on_conflict = false
  }

  deploy_key {
    name = "DEPLOY_KEY"
    read_only = false
  }

  webhook {
    url = "https://my-discord-server/webhook"
    events = ["pull_request"]
  }

  action_secret {
    name = "PAT"
    value = var.github_pat
  }
}

variable "github_token" {
  type = string
}

variable "github_pat" {
  type = string
}
