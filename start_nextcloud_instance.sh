#!/bin/bash

set -e

NEXTCLOUD_CONTAINER_PREFIX="nextcloud-aio"
NEXTCLOUD_VOLUME_PREFIX="nextcloud_aio"

echo "🔍 Recherche d'anciens conteneurs liés à Nextcloud AIO..."

# Liste tous les conteneurs qui commencent par nextcloud-aio
containers=$(sudo docker ps -a --filter "name=^/${NEXTCLOUD_CONTAINER_PREFIX}" --format "{{.ID}}")

if [ -n "$containers" ]; then
    echo "⚠️  ATTENTION :"
    echo "Une ou plusieurs instances Nextcloud AIO ont été trouvées."
    echo ""
    read -p "Êtes-vous sûr de vouloir supprimer ces instances et leurs volumes associés ? (o/N) " confirmation

    if [[ "$confirmation" != "o" && "$confirmation" != "O" ]]; then
        echo "❌ Opération annulée par l'utilisateur."
        exit 1
    fi

    echo "🛑 Suppression des conteneurs liés à Nextcloud AIO..."
    sudo docker rm -f $containers
else
    echo "✅ Aucun conteneur Nextcloud existant trouvé."
fi

echo "🔍 Recherche d'anciens volumes liés à Nextcloud AIO..."

# Liste tous les volumes qui commencent par nextcloud_aio
volumes=$(sudo docker volume ls --filter "name=${NEXTCLOUD_VOLUME_PREFIX}" --format "{{.Name}}")

if [ -n "$volumes" ]; then
    echo "🗑️  Suppression des volumes liés à Nextcloud AIO..."
    sudo docker volume rm $volumes
else
    echo "✅ Aucun volume Nextcloud existant trouvé."
fi

echo "🚀 Lancement du conteneur Nextcloud AIO Mastercontainer..."

sudo docker run \
--init \
--sig-proxy=false \
--name nextcloud-aio-mastercontainer \
--restart always \
--publish 8080:8080 \
--env APACHE_PORT=11000 \
--env APACHE_IP_BINDING=0.0.0.0 \
--env APACHE_ADDITIONAL_NETWORK="" \
--volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
--volume /var/run/docker.sock:/var/run/docker.sock:ro \
ghcr.io/nextcloud-releases/all-in-one:latest

echo "✅ Déploiement terminé !"

# --env SKIP_DOMAIN_VALIDATION=true
