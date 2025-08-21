# update docker containers
docker compose -f compose.raspi.yaml pull
docker compose -f compose.raspi.yaml up -d
# remove old images
docker system prune -f
