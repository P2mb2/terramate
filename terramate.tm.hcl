terramate {
  required_version = ">= 0.11.1"
  # required_version_allow_prereleases = true
  config {

    # Optionally disable safe guards
    # Learn more: https://terramate.io/docs/cli/orchestration/safeguards
    # disable_safeguards = [
    #   "git-untracked",
    #   "git-uncommitted",
    #   "git-out-of-sync",
    #   "outdated-code",
    # ]

    git {
      default_remote = "origin"
      default_branch = "main"
    }

    # Enable Terramate Scripts
    experiments = [
      "scripts",
    ]
  }
}
