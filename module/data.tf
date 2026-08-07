# Lookup the GitHub Organization details.
data "github_organization" "this" {
  name = var.github_organization_name
}