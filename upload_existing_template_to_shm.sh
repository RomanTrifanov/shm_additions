#!/bin/bash

set -e

# Загрузка в SHM новой версии существующего шаблона

# Название шаблона
SHM_TEMPLATE="telegram_bot_test"
# Учетные данные для авторизации - логин:пароль
CREDENTAILS="admin:xxxxxx"
# Адрес
HOST="https://admin.xxxxxxx.ru"
# Имя файла. Расширение можно изменить, если нужно
FILE="${SHM_TEMPLATE}.tt"

# Make a backup
mkdir -p backups/$SHM_TEMPLATE
curl -s -u "$CREDENTAILS" \
     -X "GET" \
     -H "Content-Type: text/html; charset=utf-8" \
     $HOST/shm/v1/admin/template/$SHM_TEMPLATE \
     -o "backups/$SHM_TEMPLATE/$(date).tt"

# Upload new template
curl -s -u "$CREDENTAILS" \
     -X "POST" \
    -H "Content-Type: text/html; charset=utf-8" \
     $HOST/shm/v1/admin/template/$SHM_TEMPLATE \
     --data-binary @${FILE}
