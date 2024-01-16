FROM ubuntu:18.04

# Copy the script to the container
COPY renewal.sh /app/renewal.sh

# Grant execute permissions to the script
RUN chmod +x /app/renewal.sh

# Certbot stuff
RUN apt update -y \
    && apt install nginx curl vim -y \
    && apt-get install software-properties-common -y \
    && add-apt-repository ppa:certbot/certbot -y \
    && apt-get update -y \
    && apt-get install python-certbot-nginx -y \
    && apt-get clean

EXPOSE 80

STOPSIGNAL SIGTERM

# Install cron
RUN apt-get update && apt-get install -y cron

RUN ./app/renewal.sh

RUN echo "0 0 1 * * certbot renew" | crontab -

CMD ["sh", "-c", "/app/renewal.sh" && "cron", "-f" && "nginx", "-g", "daemon off;"]
