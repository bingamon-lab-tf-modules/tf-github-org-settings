output "organization_settings" {
  description = "The organization settings resource"
  value       = github_organization_settings.this
}

output "organization_rulesets" {
  description = "Map of all organization rulesets created by this module"
  value       = github_organization_ruleset.this
}
