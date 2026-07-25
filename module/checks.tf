# Assert that organization rulesets are valid.
# Validate enforcement, target, and other required fields.
check "organization_rulesets" {
  assert {
    condition = alltrue([
      for ruleset in var.github_organization_rulesets :
      ruleset.name != null && ruleset.name != "" &&
      ruleset.enforcement != null && contains(["disabled", "active", "evaluate"], ruleset.enforcement) &&
      ruleset.target != null && contains(["branch", "tag"], ruleset.target) &&
      ruleset.rules != null
    ])
    error_message = <<EOT
Invalid organization rulesets found in configuration.

Organization rulesets with invalid settings: ${join(", ", [
    for ruleset in var.github_organization_rulesets :
    "'${ruleset.name}'" if(
      ruleset.name == null || ruleset.name == "" ||
      ruleset.enforcement == null || !contains(["disabled", "active", "evaluate"], ruleset.enforcement) ||
      ruleset.target == null || !contains(["branch", "tag"], ruleset.target) ||
      ruleset.rules == null
    )
])}

Organization ruleset requirements:

  - name: Must be a non-empty string
  - enforcement: Must be one of "disabled", "active", "evaluate"
  - target: Must be one of "branch", "tag"
  - rules: Must be defined (can be empty object)

Examples of valid organization rulesets:

  - { name = "org-main-protection", enforcement = "active", target = "branch", rules = { required_linear_history = true } }
  - { name = "org-release-tags", enforcement = "active", target = "tag", rules = { deletion = false } }
    EOT
}
}

# Validate organization ruleset bypass actors
check "organization_rulesets_bypass_actors" {
  assert {
    condition = alltrue(flatten([
      for ruleset in var.github_organization_rulesets : [
        for actor in(ruleset.bypass_actors != null ? ruleset.bypass_actors : []) :
        contains(["Integration", "OrganizationAdmin", "RepositoryRole", "Team", "DeployKey", "EnterpriseOwner"], actor.actor_type) &&
        contains(["always", "pull_request", "exempt"], actor.bypass_mode) &&
        (
          # OrganizationAdmin, EnterpriseOwner and DeployKey have no actor ID
          contains(["OrganizationAdmin", "EnterpriseOwner", "DeployKey"], actor.actor_type) ? true : (
            actor.actor_id != null &&
            can(tonumber(actor.actor_id)) &&
            (
              # Validate actor_id based on actor_type
              (actor.actor_type == "RepositoryRole" && contains([2, 4, 5], actor.actor_id)) ||
              (actor.actor_type == "Team" && actor.actor_id > 0) ||
              (actor.actor_type == "Integration" && actor.actor_id > 0)
            )
          )
        )
      ]
    ]))
    error_message = <<EOT
Invalid bypass actors found in organization ruleset configurations.

Organization rulesets with invalid bypass actors: ${join(", ", flatten([
    for ruleset in var.github_organization_rulesets : [
      for actor in(ruleset.bypass_actors != null ? ruleset.bypass_actors : []) :
      "${ruleset.name} (type: ${actor.actor_type}, id: ${actor.actor_id == null ? "none" : actor.actor_id})" if !(
        contains(["Integration", "OrganizationAdmin", "RepositoryRole", "Team", "DeployKey", "EnterpriseOwner"], actor.actor_type) &&
        contains(["always", "pull_request", "exempt"], actor.bypass_mode) &&
        (
          contains(["OrganizationAdmin", "EnterpriseOwner", "DeployKey"], actor.actor_type) ? true : (
            actor.actor_id != null &&
            can(tonumber(actor.actor_id)) &&
            (
              (actor.actor_type == "RepositoryRole" && contains([2, 4, 5], actor.actor_id)) ||
              (actor.actor_type == "Team" && actor.actor_id > 0) ||
              (actor.actor_type == "Integration" && actor.actor_id > 0)
            )
          )
        )
      )
    ]
]))}

Bypass actor requirements:
  - actor_type: Must be one of "Integration", "OrganizationAdmin", "RepositoryRole", "Team", "DeployKey", "EnterpriseOwner"
  - bypass_mode: Required. Must be one of "always", "pull_request", "exempt"
  - actor_id: Must be a valid number for actor types that have an ID, and omitted for those that do not

Note: "User" is only valid for repository-level rulesets, not organization-level rulesets.

Actor types with no ID (omit actor_id):
  - OrganizationAdmin
  - EnterpriseOwner
  - DeployKey

Actor type ID mappings:
  - RepositoryRole maintain: Must be 2
  - RepositoryRole write: Must be 4
  - RepositoryRole admin: Must be 5
  - Team: Must be a positive number (team ID)
  - Integration: Must be a positive number (GitHub App ID)
    EOT
}
}

# Validate organization ruleset target pattern requirements
check "organization_ruleset_target_patterns" {
  assert {
    condition = alltrue([
      for ruleset in var.github_organization_rulesets :
      ruleset if(
        # When target is 'branch', branch_name_pattern is required
        (ruleset.target == "branch" ? ruleset.rules.branch_name_pattern != null : true) &&
        # When target is 'tag', tag_name_pattern is required
        (ruleset.target == "tag" ? ruleset.rules.tag_name_pattern != null : true)
      )
    ])
    error_message = <<EOT
Invalid organization ruleset target pattern configurations.

Organization ruleset target pattern requirements:
  - When target is "branch", branch_name_pattern must be specified
  - When target is "tag", tag_name_pattern must be specified

Organization rulesets with invalid target patterns: ${join(", ", [
    for ruleset in var.github_organization_rulesets :
    "'${ruleset.name}' (target: ${ruleset.target})" if !(
      (ruleset.target == "branch" ? ruleset.rules.branch_name_pattern != null : true) &&
      (ruleset.target == "tag" ? ruleset.rules.tag_name_pattern != null : true)
    )
])}

Examples of valid organization ruleset configurations:

  # Branch-targeting ruleset (requires branch_name_pattern)
  rulesets = [
    {
      name        = "org-main-branch-protection"
      enforcement = "active"
      target      = "branch"
      rules = {
        branch_name_pattern = {
          operator = "starts_with"
          pattern  = "main"
        }
        required_linear_history = true
      }
    }
  ]

  # Tag-targeting ruleset (requires tag_name_pattern)
  rulesets = [
    {
      name        = "org-release-tag-protection"
      enforcement = "active"
      target      = "tag"
      rules = {
        tag_name_pattern = {
          operator = "starts_with"
          pattern  = "v"
        }
        deletion = false
      }
    }
  ]
    EOT
}
}

# Validate organization ruleset pattern rules operators
check "organization_rulesets_pattern_operators" {
  assert {
    condition = alltrue(flatten([
      for ruleset in var.github_organization_rulesets : [
        (try(ruleset.rules.branch_name_pattern, null) == null || contains(["starts_with", "ends_with", "contains", "regex"], try(ruleset.rules.branch_name_pattern.operator, ""))),
        (try(ruleset.rules.tag_name_pattern, null) == null || contains(["starts_with", "ends_with", "contains", "regex"], try(ruleset.rules.tag_name_pattern.operator, ""))),
        (try(ruleset.rules.commit_author_email_pattern, null) == null || contains(["starts_with", "ends_with", "contains", "regex"], try(ruleset.rules.commit_author_email_pattern.operator, ""))),
        (try(ruleset.rules.commit_message_pattern, null) == null || contains(["starts_with", "ends_with", "contains", "regex"], try(ruleset.rules.commit_message_pattern.operator, ""))),
        (try(ruleset.rules.committer_email_pattern, null) == null || contains(["starts_with", "ends_with", "contains", "regex"], try(ruleset.rules.committer_email_pattern.operator, "")))
      ]
    ]))
    error_message = <<EOT
Invalid pattern rule operators in organization ruleset configurations.

Pattern rule operator requirements:

  - operator: Must be one of "starts_with", "ends_with", "contains", "regex"
  - pattern: Must be a non-empty string

Note: Pattern rules (branch_name_pattern, tag_name_pattern, etc.) are only available for Enterprise repositories.
    EOT
  }
}

# Validate organization ruleset code scanning thresholds
check "organization_rulesets_code_scanning_thresholds" {
  assert {
    condition = alltrue([
      for ruleset in var.github_organization_rulesets :
      ruleset.rules.required_code_scanning == null ? true : length([
        for tool in ruleset.rules.required_code_scanning.required_code_scanning_tool :
        tool if !(
          contains(["none", "errors", "errors_and_warnings", "all"], tool.alerts_threshold) &&
          contains(["none", "critical", "high_or_higher", "medium_or_higher", "all"], tool.security_alerts_threshold)
        )
      ]) == 0
    ])
    error_message = <<EOT
Invalid code scanning thresholds in organization ruleset configurations.

Code scanning threshold requirements:

  - alerts_threshold: Must be one of "none", "errors", "errors_and_warnings", "all"
  - security_alerts_threshold: Must be one of "none", "critical", "high_or_higher", "medium_or_higher", "all"
  - tool: Must be a non-empty string (name of the code scanning tool)
    EOT
  }
}

# Validate organization ruleset required workflows
check "organization_ruleset_required_workflows" {
  assert {
    condition = alltrue([
      for ruleset in var.github_organization_rulesets :
      ruleset.rules.required_workflows == null ? true : length([
        for workflow in ruleset.rules.required_workflows.required_workflow :
        workflow if(
          workflow.repository_id == null ||
          workflow.path == null || workflow.path == ""
        )
      ]) == 0
    ])
    error_message = <<EOT
Invalid required workflows in organization ruleset configurations.

Required workflow requirements:

  - repository_id: Must be a valid repository ID (number)
  - path: Must be a non-empty string pointing to the workflow YAML file
  - ref: Optional reference (defaults to master if not specified)

Example:
  required_workflows:
    required_workflow:
      - repository_id: 12345
        path: ".github/workflows/ci.yml"
        ref: "main"
    EOT
  }
}

# Validate organization ruleset conditions
check "organization_ruleset_conditions" {
  assert {
    condition = alltrue([
      for ruleset in var.github_organization_rulesets :
      ruleset.conditions == null ? true : (
        # ref_name is always required
        ruleset.conditions.ref_name != null &&
        # include is required and must be a non-empty list
        ruleset.conditions.ref_name.include != null &&
        length(ruleset.conditions.ref_name.include) > 0 &&
        # exclude is required (can be empty)
        ruleset.conditions.ref_name.exclude != null &&
        # Exactly one of repository_id, repository_name or repository_property must be set
        length([
          for target in [
            ruleset.conditions.repository_id,
            ruleset.conditions.repository_name,
            ruleset.conditions.repository_property,
          ] : target if target != null
        ]) == 1 &&
        # If repository_name is set, it must have include and exclude arrays
        (ruleset.conditions.repository_name == null || (
          ruleset.conditions.repository_name.include != null &&
          length(ruleset.conditions.repository_name.include) > 0 &&
          ruleset.conditions.repository_name.exclude != null
        )) &&
        # If repository_property is set, at least one property must be targeted and every entry
        # must name a property, supply at least one value, and use a known source
        (ruleset.conditions.repository_property == null || (
          length(concat(
            coalesce(ruleset.conditions.repository_property.include, []),
            coalesce(ruleset.conditions.repository_property.exclude, []),
          )) > 0 &&
          alltrue([
            for property in concat(
              coalesce(ruleset.conditions.repository_property.include, []),
              coalesce(ruleset.conditions.repository_property.exclude, []),
            ) :
            property.name != null && property.name != "" &&
            property.property_values != null && length(property.property_values) > 0 &&
            (property.source == null || contains(["custom", "system"], property.source))
          ])
        ))
      )
    ])
    error_message = <<EOT
Invalid conditions in organization ruleset configurations.

Organization rulesets with invalid conditions: ${join(", ", [
    for ruleset in var.github_organization_rulesets :
    ruleset.name if !(
      ruleset.conditions == null || (
        ruleset.conditions.ref_name != null &&
        ruleset.conditions.ref_name.include != null &&
        length(ruleset.conditions.ref_name.include) > 0 &&
        ruleset.conditions.ref_name.exclude != null &&
        length([
          for target in [
            ruleset.conditions.repository_id,
            ruleset.conditions.repository_name,
            ruleset.conditions.repository_property,
          ] : target if target != null
        ]) == 1 &&
        (ruleset.conditions.repository_name == null || (
          ruleset.conditions.repository_name.include != null &&
          length(ruleset.conditions.repository_name.include) > 0 &&
          ruleset.conditions.repository_name.exclude != null
        )) &&
        (ruleset.conditions.repository_property == null || (
          length(concat(
            coalesce(ruleset.conditions.repository_property.include, []),
            coalesce(ruleset.conditions.repository_property.exclude, []),
          )) > 0 &&
          alltrue([
            for property in concat(
              coalesce(ruleset.conditions.repository_property.include, []),
              coalesce(ruleset.conditions.repository_property.exclude, []),
            ) :
            property.name != null && property.name != "" &&
            property.property_values != null && length(property.property_values) > 0 &&
            (property.source == null || contains(["custom", "system"], property.source))
          ])
        ))
      )
    )
])}

Condition requirements:
  - ref_name: Always required block
  - ref_name.include: Required list with at least one pattern
  - ref_name.exclude: Required list (can be empty)
  - Exactly one of repository_id, repository_name OR repository_property must be set
  - repository_id: List of repository IDs
  - repository_name: Object with include and exclude arrays
  - repository_property: Object with include and/or exclude lists of property objects

Special patterns supported in ref_name include/exclude:
  - ~DEFAULT_BRANCH: Matches the default branch of target repositories
  - ~ALL: Matches all branches (only valid in include)

Special patterns supported in repository_name include/exclude:
  - ~ALL: Matches all repositories (only valid in include)

Repository property requirements:
  - name: Required. The name of the repository property to target
  - property_values: Required. At least one value to match
  - source: Optional. One of "custom", "system" (defaults to "custom")

Examples:
  conditions = {
    ref_name = {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
    repository_id = [12345, 67890]
  }

OR

  conditions = {
    ref_name = {
      include = ["main", "master"]
      exclude = ["feature/*"]
    }
    repository_name = {
      include = ["~ALL"]
      exclude = ["archived-*"]
    }
  }

OR

  conditions = {
    ref_name = {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
    repository_property = {
      include = [
        {
          name            = "environment"
          property_values = ["production"]
          source          = "custom"
        }
      ]
    }
  }
    EOT
}
}
