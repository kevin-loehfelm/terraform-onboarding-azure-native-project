# Output(s): GitHub CLI command for Production repository
output "prod_repo_cli" {
  value = "gh repo clone ${github_repository.this["prod"].full_name}"
}

# Output(s): GitHub https clone URL for Production repository
output "prod_repo_http" {
  value = github_repository.this["prod"].http_clone_url
}

# Output(s): Github SSH clone URL for Production repository
output "prod_repo_ssh" {
  value = github_repository.this["prod"].ssh_clone_url
}

# Output(s): GitHub CLI command for Development repository
output "dev_repo_cli" {
  value = "gh repo clone ${github_repository.this["dev"].full_name}"
}

# Output(s): GitHub https clone URL for Development repository
output "dev_repo_http" {
  value = github_repository.this["dev"].http_clone_url
}

# Output(s): Github SSH clone URL for Development repository
output "dev_repo_ssh" {
  value = github_repository.this["dev"].ssh_clone_url
}

# Output(s): GitHub CLI command for Staging repository
output "stage_repo_cli" {
  value = "gh repo clone ${github_repository.this["stage"].full_name}"
}

# Output(s): GitHub https clone URL for Staging repository
output "stage_repo_http" {
  value = github_repository.this["stage"].http_clone_url
}

# Output(s): Github SSH clone URL for Staging repository
output "stage_repo_ssh" {
  value = github_repository.this["stage"].ssh_clone_url
}