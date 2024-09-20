#!/bin/bash

set -e
#заполните своими данными
BOT_TOKEN="сюда_вставть_токен_бота"
CHAT_ID="сюда_вставть_ID_чата_или_канала"
#путь к папке SHM 
DOCKER_COMPOSE_PATH="/opt/shm" 

cd ${DOCKER_COMPOSE_PATH}

echo "SELECT event, status FROM spool WHERE event LIKE '%Jobs%'" | docker-compose exec -T mysql /bin/bash -c 'MYSQL_PWD=${MYSQL_ROOT_PASSWORD} mysql -u root shm' > ${DOCKER_COMPOSE_PATH}/spool.job
MESSAGE=$(grep '^{"kind": "Jobs"' ${DOCKER_COMPOSE_PATH}/spool.job | sed 's/"kind": "Jobs", "title": //g;s/"//g;s/ method://g;s/|//g;s/ *//g;s///g;s/SUCCESS/\n<b>SUCCESS<\/b> \n/g')
sleep 2
curl -s -X  POST -d chat_id=$CHAT_ID -d parse_mode=HTML -d text="$MESSAGE" https://api.telegram.org/bot${BOT_TOKEN}/sendMessage

#пример cron для выполнения каждые 24 часа:
#  3 */24 * * * sudo sh /opt/shm/check_spool_new.sh
