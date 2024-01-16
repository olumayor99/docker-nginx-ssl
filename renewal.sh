#!/bin/bash 

# Path to Nginx configuration file inside the container
NGINX_CONFIG_PATH="/etc/nginx/sites-enabled/default"

# Function to handle errors
handle_error() {
    echo "Error occurred: $1" >&2
}

# Set up trap to call handle_error function on ERR signal
trap 'handle_error "$BASH_COMMAND"' ERR

DOMAINS=$(grep -oP 'server_name \K[^;]+' "$NGINX_CONFIG_PATH" | tr '\n' ' ')
echo $DOMAINS
URLS=""
EMAIL="example@gmail.com""
for domain in $DOMAINS
do
    echo $domain
    URLS+="-d $domain "
done


if ! certbot --nginx --agree-tos --redirect --email $EMAIL $URLS --noninteractive; then
    # If certbot command fails, print the error and continue to the next iteration
        handle_error "Certbot command failed for domain: $domain"
fi
