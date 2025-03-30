#!/bin/bash

set -e

# Загрузка НОВОГО шаблона в SHM

# Название шаблона (имя файла без расширения)
SHM_TEMPLATE="my_new_template"
# Учетные данные для авторизации - логин:пароль
CREDENTAILS="admin:xxxxxxx"
# Адрес
HOST="https://admin.xxxxxxx.ru"
# Файл шаблона для загрузки
FILE="${SHM_TEMPLATE}.tt"

# Upload new template
if [[ -f "$FILE" ]]; then
  curl -s -u "$CREDENTAILS" \
    -X "PUT" \
    -H "Content-Type: text/html; charset=utf-8" \
    $HOST/shm/v1/admin/template/$SHM_TEMPLATE \
     --data-binary @${FILE}
else
  echo "ОШИБКА! Файл $FILE не найден."
fi
