#!/bin/bash

# Color variables for output (optional)
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
GRAY="\033[0;90m"
NC="\033[0m" # No Color (reset)

# Function to execute tasks with error handling
execute_task() {
  local TASK=$1
  local COMMAND=$2
  local RESULT_VAR=$3
  local ACCEPTABLE_ERRORS=$4 # Acceptable error patterns (comma-separated regex)
  local ACCEPTABLE_ERROR_MESSAGE=$5 # Message to display for acceptable errors

  echo -n "$TASK"
  OUTPUT=$(eval "$COMMAND" 2>&1)
  if [ $? -ne 0 ]; then
    # Check if the error matches any of the acceptable errors
    if [[ -n "$ACCEPTABLE_ERRORS" && "$OUTPUT" =~ $ACCEPTABLE_ERRORS ]]; then
      echo -e "\r$TASK ${YELLOW}Warning${NC} - $ACCEPTABLE_ERROR_MESSAGE"
      echo -e "${GRAY}VerboseLog :: [AcceptableError: $OUTPUT]${NC}"
    else
      echo -e "\r$TASK ${RED}Failed${NC} Aborting script."
      echo "Error: $OUTPUT"
      exit 1
    fi
  else
    echo -e "\r$TASK ${GREEN}Done${NC}"
  fi

  # Assign output to result variable if specified
  if [ -n "$RESULT_VAR" ]; then
    eval "$RESULT_VAR=\"\$OUTPUT\""
  fi

  # Conditionally print the result based on verbose mode
  if [ "$VERBOSE" -eq 1 ]; then
    echo -e "${GRAY}VerboseLog :: [Result: $OUTPUT]${NC}"
  fi
}

# Function to extract a value from the YAML file using yq
get_configuration_root_value() {
  local CONFIG_FILE="$1"
  local KEY="$2"
  local MANDATORY="$3"  # New parameter for mandatory check

  # Extract the value using yq
  value=$(yq eval ".$KEY" "$CONFIG_FILE")

  # Check if the value is empty (i.e., not found)
  if [ -z "$value" ]; then
    if [ "$MANDATORY" = "true" ]; then
      echo "Error: Key '$KEY' not found in $CONFIG_FILE. It is a mandatory field." >&2
      exit 1
    else
      echo "Warning: Key '$KEY' not found in $CONFIG_FILE. Using default value." >&2
    fi
  fi
  # Return the extracted value
  echo "$value"
}

# Function to check if the YAML configuration file exists
file_must_exists() {
  CONFIG_FILE="$1"
  
  if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: $CONFIG_FILE not found."
    exit 1
  fi
}

# Function to return platform-independent sed options
get_sed_opts() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "-i ''"
  else
    echo "-i"
  fi
}

add_environment_to_yaml() {
  local CONFIG_FILE="$1"
  local ENVIRONMENT_NAME="$2"

  # Check if the 'environments' key exists in the YAML file
  if yq eval '.environments' "$CONFIG_FILE" > /dev/null 2>&1; then
    # If 'environments' exists, append a new environment
    yq eval ".environments += [{\"name\": \"$ENVIRONMENT_NAME\"}]" -i "$CONFIG_FILE"
  else
    # If 'environments' doesn't exist, create it at the root and add the first environment
    yq eval ".environments = [{\"name\": \"$ENVIRONMENT_NAME\"}]" -i "$CONFIG_FILE"
  fi
}

# Function to remove an environment from configurations.yaml
remove_environment_from_yaml() {
  local CONFIG_FILE="$1"
  local ENVIRONMENT_NAME="$2"

  # Check if the 'environments' key exists
  if yq eval '.environments' "$CONFIG_FILE" > /dev/null 2>&1; then
    # If 'environments' exists, try to remove the specified environment
    # Remove the environment from the list of environments
    yq eval "del(.environments[] | select(.name == \"$ENVIRONMENT_NAME\"))" -i "$CONFIG_FILE"

    # If the 'environments' list is empty, remove the key entirely
    if [ "$(yq eval '.environments | length' "$CONFIG_FILE")" -eq 0 ]; then
      yq eval 'del(.environments)' -i "$CONFIG_FILE"
    fi

  else
    # If 'environments' doesn't exist, print a message
    echo "Error: 'environments' key not found in $CONFIG_FILE. No environments to remove."
    exit 1
  fi
}