# Start from the official Jenkins Long-Term Support image
FROM jenkins/jenkins:lts-jdk17

# Switch to the root user to install packages
USER root

# --- Install Terraform ---
# 1. Install prerequisites
RUN apt-get update && apt-get install -y \
        gnupg \
        curl \
        lsb-release

# 2. Add HashiCorp GPG key
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# 3. Add the Terraform repository
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
        | tee /etc/apt/sources.list.d/hashicorp.list

# 4. Install Terraform
RUN apt-get update && apt-get install -y terraform

# --- Install Azure CLI ---
# 5. Run the official install script
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# --- Clean up ---
# 6. Clean up apt-get cache
RUN apt-get clean

# 7. Switch back to the non-privileged 'jenkins' user
USER jenkins