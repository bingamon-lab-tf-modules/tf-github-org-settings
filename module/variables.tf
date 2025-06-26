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
    enforcement = string # disabled, active, evaluate
    target      = string # branch, tag

    # Rules block (required)
    rules = object({
      # Branch/Tag protection rules
      creation                = optional(bool)
      deletion                = optional(bool)
      non_fast_forward        = optional(bool)
      required_linear_history = optional(bool)
      required_signatures     = optional(bool)
      update                  = optional(bool)

      # Pull request rules
      pull_request = optional(object({
        dismiss_stale_reviews_on_push     = optional(bool)
        require_code_owner_review         = optional(bool)
        require_last_push_approval        = optional(bool)
        required_approving_review_count   = optional(number)
        required_review_thread_resolution = optional(bool)
      }))

      # Status check rules
      required_status_checks = optional(object({
        strict_required_status_checks_policy = optional(bool)
        required_check = optional(list(object({
          context        = string
          integration_id = optional(number)
        })))
      }))

      # Required workflows rules
      required_workflows = optional(object({
        required_workflow = list(object({
          repository_id = number
          path          = string
          ref           = optional(string)
        }))
      }))

      # Code scanning rules
      required_code_scanning = optional(object({
        required_code_scanning_tool = list(object({
          alerts_threshold          = string # none, errors, errors_and_warnings, all
          security_alerts_threshold = string # none, critical, high_or_higher, medium_or_higher, all
          tool                      = string
        }))
      }))

      # Pattern rules (Enterprise only)
      branch_name_pattern = optional(object({
        operator = string # starts_with, ends_with, contains, regex
        pattern  = string
        name     = optional(string)
        negate   = optional(bool)
      }))

      tag_name_pattern = optional(object({
        operator = string # starts_with, ends_with, contains, regex
        pattern  = string
        name     = optional(string)
        negate   = optional(bool)
      }))

      commit_author_email_pattern = optional(object({
        operator = string # starts_with, ends_with, contains, regex
        pattern  = string
        name     = optional(string)
        negate   = optional(bool)
      }))

      commit_message_pattern = optional(object({
        operator = string # starts_with, ends_with, contains, regex
        pattern  = string
        name     = optional(string)
        negate   = optional(bool)
      }))

      committer_email_pattern = optional(object({
        operator = string # starts_with, ends_with, contains, regex
        pattern  = string
        name     = optional(string)
        negate   = optional(bool)
      }))
    })

    # Optional fields
    bypass_actors = optional(list(object({
      actor_id    = number
      actor_type  = string           # RepositoryRole, Team, Integration, OrganizationAdmin
      bypass_mode = optional(string) # always, pull_request
    })))

    conditions = optional(object({
      ref_name = object({
        include = list(string)
        exclude = list(string)
      })
      repository_id = optional(list(number))
      repository_name = optional(object({
        include = list(string)
        exclude = list(string)
      }))
    }))
  }))

  default = []
}
