# update docker containers
docker compose up --force-recreate --build -d
docker image prune -f