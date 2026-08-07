output "organization_settings" {
  description = "The organization settings resource"
  value       = github_organization_settings.this
}

output "organization_rulesets" {
  description = "Map of all organization rulesets created by this module"
  value       = github_organization_ruleset.this
}

output "repository_names" {
  description = <<-EOT
  Names of every repository in the organization, archived ones included.

  Sourced from data.github_organization, which builds its list from the
  paginated REST list-repos endpoint - unlike data.github_repositories, which is
  backed by the Search API and both lags indexing and caps at 1000 results.

  The data source returns "owner/repo"; the owner prefix is stripped here because
  consumers compare these against configuration that names repositories bare.

  Archived repositories are included (ignore_archived_repos defaults to false),
  so archiving a repository cannot be used to hide it from a caller reconciling
  live state against configuration.
  EOT
  value       = [for full_name in data.github_organization.this.repositories : split("/", full_name)[1]]
}
