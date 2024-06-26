# Output(s): GitHub CLI command for Production repository
output "prod_repo_cli" {
  value = "gh repo clone ${github_repository.this.full_name}"
}

# Output(s): GitHub https clone URL for Production repository
output "prod_repo_http" {
  value = "git clone ${github_repository.this.http_clone_url}"
}

# Output(s): Github SSH clone URL for Production repository
output "prod_repo_ssh" {
  value = "git clone ${github_repository.this.ssh_clone_url}"
}

# Output(s): GitHub CLI command for Development repository
output "dev_repo_cli" {
  value = "gh repo clone ${github_repository.this.full_name} -- --branch dev"
}

# Output(s): GitHub https clone URL for Development repository
output "dev_repo_http" {
  value = "git clone -b dev ${github_repository.this.http_clone_url}"
}

# Output(s): Github SSH clone URL for Development repository
output "dev_repo_ssh" {
  value = "git clone -b dev ${github_repository.this.ssh_clone_url}"
}

# Output(s): GitHub CLI command for Staging repository
output "stage_repo_cli" {
  value = "gh repo clone ${github_repository.this.full_name} -- --branch stage"
}

# Output(s): GitHub https clone URL for Staging repository
output "stage_repo_http" {
  value = "git clone -b stage ${github_repository.this.http_clone_url}"
}

# Output(s): Github SSH clone URL for Staging repository
output "stage_repo_ssh" {
  value = "git clone -b stage ${github_repository.this.ssh_clone_url}"
}