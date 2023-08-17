# update docker containers
docker compose pull
docker compose up -d
# remove old images
docker system prune -f
