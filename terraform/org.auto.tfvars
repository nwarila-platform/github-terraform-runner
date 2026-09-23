# =============================================================================
# nwarila-platform — organization control plane + runner-level framework overrides
# -----------------------------------------------------------------------------
# The reusable deploy workflow overlays ONLY this file into the framework
# workspace, so runner-level framework variable overrides live here alongside
# org_settings. Non-sensitive values only — the billing email is delivered via
# the ORG_BILLING_EMAIL Actions secret (TF_VAR_org_billing_email), never here.
# =============================================================================

# Organization settings. `name` is required; every other field intentionally
# falls to the framework's safe, expense-free defaults:
#   - members_can_create_* = false        (restrict member repo/page creation)
#   - has_*_projects = false              (projects off)
#   - web_commit_signoff_required = true  (require signoff)
#   - default_repository_permission = "read"
#   - security_defaults_for_new_repositories = all false (expense-free)
# First apply therefore flips the org's current permissive member-creation /
# projects / signoff settings to these safe defaults (ratified).
#
# Public Pages is the one exception, opened deliberately on 2026-09-23. The
# default blocks POST /repos/{owner}/{repo}/pages for everyone including an org
# admin -- three applies of ansible-style-guide failed on "GitHub organization
# administrators disabled Pages creation" (422), and the same call refused an
# org-admin credential outside Terraform. A tick-box change in the org UI is not
# durable: this file decides the setting, so the next apply reverts it, which is
# what happened between 17:05 and 17:21 that day. Any published docs site in
# this org needs it.
#
# Private Pages stays off. It is an Enterprise feature this Team-plan org cannot
# use, so allowing it would widen the setting and buy nothing.
org_settings = {
  name                            = "nwarila-platform"
  members_can_create_pages        = true
  members_can_create_public_pages = true
}

# Global CODEOWNERS default for org mode. Code owners MUST be a valid user or
# team — a bare "@nwarila-platform" (the org) is rejected by GitHub. @NWarila is
# the org admin. Per-repo `codeowners:` in a repo's YAML still overrides this.
repo_default_codeowners = "* @NWarila\n"

# Do not manage the GitHub Advanced Security feature family: this org has no
# GHAS (Team plan), so the API rejects setting these even to "disabled"
# (422 "Updating Advanced Security ... not available"), and code_security also
# never reads back (provider #3501). They are off in practice and unmanageable
# here. secret_scanning + push_protection stay managed (the real paid-feature
# lockdown on private repos).
security_pin_exclude = ["advanced_security", "code_security", "secret_scanning_ai_detection", "secret_scanning_non_provider_patterns"]
