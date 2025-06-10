#!/usr/bin/env bash
# ---------------------------------------
# bootstrap.sh: initialize Conjur server
# ---------------------------------------

# 1. Wait for Conjur health endpoint to be “ok”
echo "Waiting for Conjur to become healthy..."
# Loop until HTTP GET to /health returns JSON containing "ok":true.
until curl -s http://localhost:8080/health | grep -q '"ok":true'; do
  echo "Conjur not ready yet. Sleeping for 5 seconds..."
  sleep 5
done
echo "Conjur is healthy. Proceeding with initialization..."

# 2. Initialize Conjur (only once ever, first time):
#    - admin user: login "admin", password "password"
#    - Conjur account name: demo
#    - Data key: must match the CONJUR_DATA_KEY ENV you set in docker-compose.yml
CONJUR_DATA_KEY="abc123CONJUR_DATA_KEY"
docker exec conjur \
  conjur init -u admin -p password -a demo -b conjur-data-key=
echo "Conjur init command sent."

# 3. Retrieve Admin API Key for "admin":
echo "Retrieving Admin API Key for admin..."
ADMIN_API_KEY=
echo "Admin API Key: "
echo "You can export these variables for CLI usage:"
echo "  export CONJUR_AUTHN_LOGIN=admin"
echo "  export CONJUR_AUTHN_API_KEY=\"
echo "  export CONJUR_ACCOUNT=demo"
echo "  export CONJUR_APPLIANCE_URL=http://localhost:8080"

# 4. Create a Host Factory token if you want host registrations:
echo "Creating Host Factory token for host registrations..."
# Example: for host factory tied to policy path “iam-demo/app-host”
# Note: adjust path/id as per your policy (will load policy soon).
HF_TOKEN=
echo "Host Factory token:"
echo "\"
echo "\" > hf-token.txt
echo "Saved Host Factory token in hf-token.txt"
