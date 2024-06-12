# No-Code Module: terraform-demo-project

Deploy GitHub, Terraform, and Azure resources to support an HCP Terraform project configured to deploy resources to Azure using Terraform Workload Identity (dynamic credentials)

This module deploys the following resources:

| Resource | Description |
|----------|-------------|
| GitHub Repository | GitHub Repository with 3 branches (main, dev, stage) |
| HCP Terraform Workspace(s) | HCP Terraform workspaces configured for VCS-driven workflow with the GitHub repository branches |
| Azure Service Principal(s) | Azure Service Principal to authorize HCP Terraform workspaces for Azure Dynamic Credentials |
