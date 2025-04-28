#!/bin/bash

docker exec -it nextcloud-aio-mastercontainer sudo -u www-data php /var/www/docker-aio/php/src/Cron/UpdateMastercontainer.php                                                                                                         
