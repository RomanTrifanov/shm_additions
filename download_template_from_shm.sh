#!/bin/bash

set -e

# Загрузка шаблона из SHM в текущую директорию

# Название шаблона
SHM_TEMPLATE="my_template"
# Учетные данные для авторизации - логин:пароль
CREDENTAILS="admin:xxxxxxx"
# Адрес
HOST="https://admin.xxxxxx.ru"

# Загрузка
curl -s -u "$CREDENTAILS" \
     -X "GET" \
     -H "Content-Type: text/html; charset=utf-8" \
     $HOST/shm/v1/admin/template/$SHM_TEMPLATE \
     -o "$SHM_TEMPLATE.tt"
