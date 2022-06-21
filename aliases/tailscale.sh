

function tailscaleStartup(){
  # Start Tailscale Service
  if [ ! $(pgrep tailscaled) == "" ]; then
    sudo tailscaled &
  fi    

  # Connect to Tailscale Service
  if [ $(tailscaleIsOnline) == 'false' ]; then
    tailscaleConnect
  fi
}

function tailscaleIsOnline(){
  tailscale status --peers=false --json | jq '.Self.Online'
}

function tailscaleConnect(){
  if [ "$CODESPACES" = "true" ]  && [ -n "$TAILSCALE_AUTHKEY" ]; then
    SERVICE=$(ls /workspaces)
    # Connect to Tailscale
    sudo tailscale up --auth-key $TAILSCALE_AUTHKEY --hostname $SERVICE
  fi
}

function tailscaleClearHost(){
  # Get the service name
  SERVICE=$(ls /workspaces)
  DEVICE_SEARCH_URL="https://$TAILSCALE_API_KEY:@api.tailscale.com/api/v2/tailnet/customink.com/devices?hostname=$SERVICE"
  JQ_QUERY_STRING=".devices[] | select ( .name == \"$SERVICE.customink.com\" ) | .id"
  # Clear out this service name if it's already reserved to another instance
  ID_TO_DELETE=$(curl --request GET --url $DEVICE_SEARCH_URL | jq -rc "$JQ_QUERY_STRING")
  if [ ! $to_del = "" ]; then  
    DELETE_DEVICE_URL="https://$TAILSCALE_API_KEY:@api.tailscale.com/api/v2/device/$ID_TO_DELETE"
    curl --request DELETE --url $DELETE_DEVICE_URL
  fi
}


function installTailscale(){
    # Install Tailscale if there's an authkey available
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
    sudo apt-get update
    sudo apt-get -y install tailscale
    tailscaleStartup
}

