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
        contains(["RepositoryRole", "Team", "Integration", "OrganizationAdmin"], actor.actor_type) &&
        (actor.bypass_mode == null || contains(["always", "pull_request"], actor.bypass_mode)) &&
        actor.actor_id != null &&
        can(tonumber(actor.actor_id)) &&
        (
          # Validate actor_id based on actor_type
          (actor.actor_type == "OrganizationAdmin" && contains([0, 1], actor.actor_id)) ||
          (actor.actor_type == "RepositoryRole" && contains([2, 4, 5], actor.actor_id)) ||
          (actor.actor_type == "Team" && actor.actor_id > 0) ||
          (actor.actor_type == "Integration" && actor.actor_id > 0)
        )
      ]
    ]))
    error_message = <<EOT
Invalid bypass actors found in organization ruleset configurations.

Organization rulesets with invalid bypass actors: ${join(", ", flatten([
    for ruleset in var.github_organization_rulesets : [
      for actor in(ruleset.bypass_actors != null ? ruleset.bypass_actors : []) :
      "${ruleset.name} (type: ${actor.actor_type}, id: ${actor.actor_id})" if !(
        contains(["RepositoryRole", "Team", "Integration", "OrganizationAdmin"], actor.actor_type) &&
        (actor.bypass_mode == null || contains(["always", "pull_request"], actor.bypass_mode)) &&
        actor.actor_id != null &&
        can(tonumber(actor.actor_id)) &&
        (
          # Note: OrganizationAdmin supports both 0 and 1 due to GitHub API changes (see issue #2536)
          (actor.actor_type == "OrganizationAdmin" && contains([0, 1], actor.actor_id)) ||
          (actor.actor_type == "RepositoryRole" && contains([2, 4, 5], actor.actor_id)) ||
          (actor.actor_type == "Team" && actor.actor_id > 0) ||
          (actor.actor_type == "Integration" && actor.actor_id > 0)
        )
      )
    ]
]))}

Bypass actor requirements:
  - actor_type: Must be one of "RepositoryRole", "Team", "Integration", "OrganizationAdmin"
  - bypass_mode: Must be one of "always", "pull_request" (or null)
  - actor_id: Must be a valid number

Actor type ID mappings:
  - OrganizationAdmin: Must be 0 or 1 (GitHub changed from 1 to 0 recently)
  - RepositoryRole maintain: Must be 2
  - RepositoryRole write: Must be 4
  - RepositoryRole admin: Must be 5
  - Team: Must be a positive number (team ID)
  - Integration: Must be a positive number (GitHub App ID)
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
        # Either repository_id or repository_name must be set (along with ref_name)
        (ruleset.conditions.repository_id != null || ruleset.conditions.repository_name != null) &&
        # repository_id and repository_name cannot both be set
        !(ruleset.conditions.repository_id != null && ruleset.conditions.repository_name != null) &&
        # If repository_name is set, it must have include and exclude arrays
        (ruleset.conditions.repository_name == null || (
          ruleset.conditions.repository_name.include != null &&
          length(ruleset.conditions.repository_name.include) > 0 &&
          ruleset.conditions.repository_name.exclude != null
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
        (ruleset.conditions.repository_id != null || ruleset.conditions.repository_name != null) &&
        !(ruleset.conditions.repository_id != null && ruleset.conditions.repository_name != null) &&
        (ruleset.conditions.repository_name == null || (
          ruleset.conditions.repository_name.include != null &&
          length(ruleset.conditions.repository_name.include) > 0 &&
          ruleset.conditions.repository_name.exclude != null
        ))
      )
    )
])}

Condition requirements:
  - ref_name: Always required block
  - ref_name.include: Required list with at least one pattern
  - ref_name.exclude: Required list (can be empty)
  - One of repository_id OR repository_name must be set (but not both)
  - repository_id: List of repository IDs
  - repository_name: Object with include and exclude arrays

Special patterns supported in ref_name include/exclude:
  - ~DEFAULT_BRANCH: Matches the default branch of target repositories
  - ~ALL: Matches all branches (only valid in include)

Special patterns supported in repository_name include/exclude:
  - ~ALL: Matches all repositories (only valid in include)

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
    EOT
}
}
