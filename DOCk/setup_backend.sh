#!/bin/bash

# --- ⚠️ EDIT THESE VALUES ---
# This needs to be a unique name WITHIN your subscription
RESOURCE_GROUP_NAME="tfstate-rg"

# This must be a GLOBALLY unique name (lowercase, no symbols)
# I recommend adding random numbers or your initials.
STORAGE_ACCOUNT_NAME="tfstate_shubh2025"

# The name of the folder inside the storage account
CONTAINER_NAME="tfstate"

# The location to deploy to
LOCATION="eastus"
# ---

# 1. Log in to Azure (this will open a browser)
echo "Logging in to Azure..."
az login

# 2. Create the resource group
echo "Creating resource group: $RESOURCE_GROUP_NAME"
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# 3. Create the storage account
echo "Creating storage account: $STORAGE_ACCOUNT_NAME"
az storage account create \
  --name $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --location $LOCATION \
  --sku Standard_LRS \
  --encryption-services blob

# 4. Create the blob container
echo "Creating storage container: $CONTAINER_NAME"
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT_NAME \
  --auth-mode login

echo "✅ Backend setup complete!"
echo "---------------------------"
echo "Resource Group: $RESOURCE_GROUP_NAME"
echo "Storage Account: $STORAGE_ACCOUNT_NAME"
echo "Container Name: $CONTAINER_NAME"