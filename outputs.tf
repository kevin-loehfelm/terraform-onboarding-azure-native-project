output "github_repo" {
  value = {
    for e in local.environments:
        "${e}" => {
            https = github_repository.this["${e}"].http_clone_url
            ssh = github_repository.this["${e}"].ssh_clone_url
            cli = "gh repo clone ${github_repository.this["${e}"].full_name}"
        }
    }
}