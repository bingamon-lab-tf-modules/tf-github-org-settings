variable "github_enterprise_slug" {
  type        = string
  description = <<EOT
  The slug of the GitHub Enterprise where resources will be created.

  This is needed by the GitHub Enterprise Terraform provider.

  This can be set via either;

  - TF_VAR_github_enterprise_slug environment variable.
  - github_enterprise_slug variable in the terraform.tfvars file.
  EOT
}

variable "github_organization_name" {
  type        = string
  description = "Required. The name of the GitHub Organization where resources will be created."
}

variable "github_organization_description" {
  type        = string
  description = "Optional. The description of the GitHub Organization where resources will be created."
  default     = null
}

variable "github_organization_billing_email" {
  type        = string
  description = "Required. The billing email of the GitHub Organization where resources will be created."
}

variable "github_organization_company" {
  type        = string
  description = "Optional. The company of the GitHub Organization where resources will be created."
  default     = null
}

variable "github_organization_blog" {
  type        = string
  description = "Optional. The blog of the GitHub Organization where resources will be created."
  default     = null
}

variable "github_organization_email" {
  type        = string
  description = "Optional. The contactemail of the GitHub Organization where resources will be created."
  default     = null
}

variable "github_organization_twitter_username" {
  type        = string
  description = "Optional. The twitter username of the GitHub Organization where resources will be created."
  default     = null
}

variable "github_organization_location" {
  type        = string
  description = "Optional. The location of the GitHub Organization where resources will be created."
  default     = null
}

variable "github_organization_has_organization_projects" {
  type        = bool
  description = "Whether organization projects are enabled for the organization."
  default     = false
}

variable "github_organization_has_repository_projects" {
  type        = bool
  description = "Whether repository projects are enabled for the organization."
  default     = true
}

variable "github_organization_default_repository_permission" {
  type        = string
  description = "Default repository permission for the organization. Can be 'read', 'write', 'admin' or 'none'."
  default     = "none"
}

variable "github_organization_members_can_create_repositories" {
  type        = bool
  description = "Optional. Whether members can create repositories."
  default     = false
}

variable "github_organization_members_can_create_public_repositories" {
  type        = bool
  description = "Optional. Whether members can create public repositories."
  default     = false
}

variable "github_organization_members_can_create_private_repositories" {
  type        = bool
  description = "Optional. Whether members can create private repositories."
  default     = false
}

variable "github_organization_members_can_create_internal_repositories" {
  type        = bool
  description = "Optional. Whether members can create internal repositories."
  default     = false
}

variable "github_organization_members_can_create_pages" {
  type        = bool
  description = "Optional. Whether members can create pages."
  default     = false
}

variable "github_organization_members_can_create_public_pages" {
  type        = bool
  description = "Whether members can create public pages."
  default     = false
}

variable "github_organization_members_can_create_private_pages" {
  type        = bool
  description = "Whether members can create private pages."
  default     = false
}

variable "github_organization_members_can_fork_private_repositories" {
  type        = bool
  description = "Optional. Whether members can fork private repositories."
  default     = false
}

# TODO: Fix this organization-level vs repository-level setting.
# tflint-ignore: terraform_unused_declarations
variable "github_organization_web_commit_signoff_required" {
  type        = bool
  description = "Optional. Whether web commit signoff is required."
  default     = null
}

variable "github_organization_advanced_security_enabled_for_new_repositories" {
  type        = bool
  description = "Optional. Whether advanced security is enabled for new repositories."
  default     = true
}

variable "github_organization_dependabot_alerts_enabled_for_new_repositories" {
  type        = bool
  description = "Optional. Whether dependabot alerts are enabled for new repositories."
  default     = true
}

variable "github_organization_dependabot_security_updates_enabled_for_new_repositories" {
  type        = bool
  description = "Optional. Whether dependabot security updates are enabled for new repositories."
  default     = true
}

variable "github_organization_dependency_graph_enabled_for_new_repositories" {
  type        = bool
  description = "Optional. Whether dependency graph is enabled for new repositories."
  default     = true
}

variable "github_organization_secret_scanning_enabled_for_new_repositories" {
  type        = bool
  description = "Optional. Whether secret scanning is enabled for new repositories."
  default     = true
}

variable "github_organization_secret_scanning_push_protection_enabled_for_new_repositories" {
  type        = bool
  description = "Optional. Whether secret scanning push protection is enabled for new repositories."
  default     = true
}

variable "github_organization_rulesets" {
  description = "Optional. List of organization-level rulesets to apply to repositories within the organization."
  type = list(object({
    # Required fields
    name        = string
    enforcement = string # disabled, active, evaluate (evaluate only supported for organization owners)
    target      = string # branch, tag

    # Rules block (required) - Rules within the ruleset
    rules = object({
      # Branch/Tag protection rules
      creation                = optional(bool) # Only allow users with bypass permission to create matching refs
      deletion                = optional(bool) # Only allow users with bypass permissions to delete matching refs
      non_fast_forward        = optional(bool) # Prevent users with push access from force pushing to branches
      required_linear_history = optional(bool) # Prevent merge commits from being pushed to matching branches
      required_signatures     = optional(bool) # Commits pushed to matching branches must have verified signatures
      update                  = optional(bool) # Only allow users with bypass permission to update matching refs

      # Pull request rules - Require all commits be made to a non-target branch and submitted via a pull request before they can be merged
      pull_request = optional(object({
        dismiss_stale_reviews_on_push     = optional(bool)   # New, reviewable commits pushed will dismiss previous pull request review approvals
        require_code_owner_review         = optional(bool)   # Require an approving review in pull requests that modify files that have a designated code owner
        require_last_push_approval        = optional(bool)   # Whether the most recent reviewable push must be approved by someone other than the person who pushed it
        required_approving_review_count   = optional(number) # The number of approving reviews that are required before a pull request can be merged
        required_review_thread_resolution = optional(bool)   # All conversations on code must be resolved before a pull request can be merged
      }))

      # Status check rules - Choose which status checks must pass before branches can be merged into a branch that matches this rule
      required_status_checks = optional(object({
        strict_required_status_checks_policy = optional(bool) # Whether pull requests targeting a matching branch must be tested with the latest code
        required_check = list(object({
          context        = string           # The status check context name that must be present on the commit
          integration_id = optional(number) # The optional integration ID that this status check must originate from
        }))
      }))

      # Required workflows rules - Define which Actions workflows must pass before changes can be merged into a branch matching the rule
      required_workflows = optional(object({
        required_workflow = list(object({
          repository_id = number           # The ID of the repository. Names, full names and repository URLs are not supported
          path          = string           # The path to the YAML definition file of the workflow
          ref           = optional(string) # The optional ref from which to fetch the workflow
        }))
      }))

      # Code scanning rules - Define which tools must provide code scanning results before the reference is updated
      required_code_scanning = optional(object({
        required_code_scanning_tool = list(object({
          alerts_threshold          = string # none, errors, errors_and_warnings, all - The severity level at which code scanning results that raise alerts block a reference update
          security_alerts_threshold = string # none, critical, high_or_higher, medium_or_higher, all - The severity level at which code scanning results that raise security alerts block a reference update
          tool                      = string # The name of a code scanning tool
        }))
      }))

      # Pattern rules (Enterprise only) - These rules only apply to repositories within an enterprise, cannot be applied to individual or regular organization repositories
      branch_name_pattern = optional(object({
        operator = string           # starts_with, ends_with, contains, regex - The operator to use for matching
        pattern  = string           # The pattern to match with
        name     = optional(string) # How this rule will appear to users
        negate   = optional(bool)   # If true, the rule will fail if the pattern matches
      }))

      tag_name_pattern = optional(object({
        operator = string           # starts_with, ends_with, contains, regex - The operator to use for matching
        pattern  = string           # The pattern to match with
        name     = optional(string) # How this rule will appear to users
        negate   = optional(bool)   # If true, the rule will fail if the pattern matches
      }))

      commit_author_email_pattern = optional(object({
        operator = string           # starts_with, ends_with, contains, regex - The operator to use for matching
        pattern  = string           # The pattern to match with
        name     = optional(string) # How this rule will appear to users
        negate   = optional(bool)   # If true, the rule will fail if the pattern matches
      }))

      commit_message_pattern = optional(object({
        operator = string           # starts_with, ends_with, contains, regex - The operator to use for matching
        pattern  = string           # The pattern to match with
        name     = optional(string) # How this rule will appear to users
        negate   = optional(bool)   # If true, the rule will fail if the pattern matches
      }))

      committer_email_pattern = optional(object({
        operator = string           # starts_with, ends_with, contains, regex - The operator to use for matching
        pattern  = string           # The pattern to match with
        name     = optional(string) # How this rule will appear to users
        negate   = optional(bool)   # If true, the rule will fail if the pattern matches
      }))
    })

    # Optional fields
    # Valid actor_type values at the organization scope are RepositoryRole, Team, Integration,
    # OrganizationAdmin, DeployKey and EnterpriseOwner.
    # NOTE: "User" is NOT valid here - it is only accepted by repository-level rulesets.
    # actor_id must be omitted for the ID-less actor types (OrganizationAdmin, EnterpriseOwner,
    # DeployKey); the GitHub API does not use an ID for those and ignores any value supplied.
    bypass_actors = optional(list(object({
      actor_id    = optional(number) # The ID of the actor that can bypass a ruleset. Omit for ID-less actor types
      actor_type  = string           # RepositoryRole, Team, Integration, OrganizationAdmin, DeployKey, EnterpriseOwner
      bypass_mode = string           # Required. always, pull_request, exempt - When the specified actor can bypass the ruleset
    })))

    conditions = optional(object({
      ref_name = object({
        include = list(string) # Array of ref names or patterns to include. One of these patterns must match for the condition to pass
        exclude = list(string) # Array of ref names or patterns to exclude. The condition will not pass if any of these patterns match
      })
      # NOTE: Exactly one of repository_id, repository_name or repository_property must be set for
      # the rule to target any repositories
      repository_id = optional(list(number)) # The repository IDs that the ruleset applies to. One of these IDs must match for the condition to pass
      repository_name = optional(object({
        include = list(string) # Array of repository names or patterns to include. One of these patterns must match for the condition to pass
        exclude = list(string) # Array of repository names or patterns to exclude. The condition will not pass if any of these patterns match
      }))
      # Target repositories by custom or system properties
      repository_property = optional(object({
        include = optional(list(object({
          name            = string           # The name of the repository property to target
          property_values = list(string)     # The values to match for the repository property
          source          = optional(string) # custom, system - Defaults to "custom" when unset
        })))
        exclude = optional(list(object({
          name            = string           # The name of the repository property to target
          property_values = list(string)     # The values to match for the repository property
          source          = optional(string) # custom, system - Defaults to "custom" when unset
        })))
      }))
    }))
  }))
  default = []
}
