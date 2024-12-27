#!/bin/bash
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)" # Get the absolute path of the root directory
source "$ROOT_DIR/scripts/shared.sh" # Source the shared script using the absolute path

# Ensure we are on the main branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$current_branch" != "main" ]; then
  echo -e "${RED}You are not on the main branch.${NC} Please switch to the main branch and try again."
  exit 1
fi

# Ensure the local repository is up-to-date
git fetch origin
if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
  echo -e "${RED}Your local repository is not up-to-date.${NC} Please pull the latest changes and try again."
  exit 1
fi

VERBOSE=0
SOURCE_ENVIRONMENT="env"

# Parse command-line options
while getopts "ve:s:" opt; do
  case $opt in
    v) VERBOSE=1 ;;  # Enable verbose mode (no argument needed)
    e) ENVIRONMENT=$OPTARG ;;  # Set environment
    *) echo "Usage: $0 [-v] [-e ENVIRONMENT]"; exit 1 ;;
  esac
done

# Prompt user to enter environment value
read -p "Please enter the environment value: " ENVIRONMENT

# Check if the environment value is empty
if [ -z "$ENVIRONMENT" ]; then
  echo "Environment value cannot be empty. Please run the script again and provide a valid environment value."
  exit 1
fi

# Check if the environment already exists
if [ -d "$ROOT_DIR/stacks/$ENVIRONMENT" ]; then
    echo "Environment '$ENVIRONMENT' already exists. Please choose a different environment name."
    exit 1
fi

if [ "$VERBOSE" -eq 1 ]; then
  echo -e "${GRAY}VerboseLog :: Running for Company: ${COMPANY} | Project Name: ${PROJECT_NAME} | Environment: ${ENVIRONMENT} | SOURCE ENVIRONMENT: ${SOURCE_ENVIRONMENT}${NC}"
fi

BRANCH_NAME="create_$ENVIRONMENT"

execute_task "Creating a new branch..." \
    "git checkout -B $BRANCH_NAME"

execute_task "Cloning stacks from $SOURCE_ENVIRONMENT to $ENVIRONMENT..." \
    "terramate experimental clone \
    'templates/$SOURCE_ENVIRONMENT' \
    'stacks/$ENVIRONMENT'"

execute_task "Creating config.tm.hcl for environment $ENVIRONMENT..." \
    "echo 'globals \"terraform\" \"environment\" {
  name = \"$ENVIRONMENT\"
}' > \"stacks/$ENVIRONMENT/config.tm.hcl\""

execute_task "Creating new Terramate code.." \
    "terramate generate"

execute_task "Running terraform init on bootstrap stacks..." \
    "terramate run -C stacks/\"$ENVIRONMENT\" --tags bootstrap terraform init"

execute_task "Running terraform apply on bootstrap stacks..." \
    "terramate run -C stacks/\"$ENVIRONMENT\" --tags bootstrap terraform apply -auto-approve"
    
execute_task "Removing no-backend tag on bootstrap stacks..." \
    "find /c/users/joaop/terramate/stacks/dev/bootstrap -name 'stack.tm.hcl' -exec sed $(get_sed_opts) \
    's/\"no-backend\", //; \
    s/, \"no-backend\"//; \
    s/\"no-backend\"//' {} \;"

execute_task "Running Terramate generate command..." \
    "terramate generate"

execute_task "Commiting new generated code..." \
    "git add . && git commit -m \"remove no-backend tags on \"$ENVIRONMENT\" bootstrap stacks\""

execute_task "Running terraform migrate state..." \
    "terramate run -C stacks/\"$ENVIRONMENT\" --tags bootstrap terraform init -migrate-state -force-copy"
    
execute_task "Removing local tfstate files..." \
    "terramate run -C stacks/\"$ENVIRONMENT\" --tags bootstrap rm *.tfstate*"

execute_task "Formatting Terraform..." \
    "terramate fmt"

execute_task "Commiting changes..." \
    "git add . && git commit -m \"remove local state for \"$ENVIRONMENT\" bootstrap stacks\""

execute_task "Pushing changes to remote..." \
    " git push --set-upstream origin $BRANCH_NAME"

execute_task "Opening a new PR..." \
    "gh pr create --fill"