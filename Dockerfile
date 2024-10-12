FROM ubuntu:22.04

# Install dependencies including libicu and other necessary tools
RUN apt-get update && apt-get install -y \
    curl \
    tar \
    git \
    libicu-dev \
    && apt-get clean

# Create a new user `runner` and switch to it
RUN useradd -m runner && mkdir /home/runner/actions-runner

# Set working directory to the runner's home directory
WORKDIR /home/runner/actions-runner

# Download GitHub Actions runner with retry for better network handling
RUN curl -o actions-runner-linux-x64-2.320.0.tar.gz -L --retry 5 https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-linux-x64-2.320.0.tar.gz

# Extract the installer
RUN tar xzf ./actions-runner-linux-x64-2.320.0.tar.gz

# Copy the entrypoint script
COPY entrypoint.sh /home/runner/actions-runner/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /home/runner/actions-runner/entrypoint.sh

# Change ownership of the extracted files to user `runner`
RUN chown -R runner:runner /home/runner/actions-runner

# Switch to user `runner`
USER runner

# Set the entrypoint to the entrypoint script
ENTRYPOINT ["/home/runner/actions-runner/entrypoint.sh"]
