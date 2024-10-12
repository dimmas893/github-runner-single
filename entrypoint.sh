#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to handle runner cleanup when the container is stopped
cleanup() {
    echo "Stopping GitHub Actions runner..."
    ./config.sh remove --token $TOKEN
}

# Trap SIGTERM and SIGINT and call the cleanup function
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

# Configure the runner if it's not already configured
if [ ! -f .runner ]; then
    ./config.sh --url $REPO_URL --token $TOKEN --unattended --name $RUNNER_NAME
fi

# Start the runner
./run.sh &

# Wait for any signal and handle it
wait $!
