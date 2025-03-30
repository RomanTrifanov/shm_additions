#!/bin/bash

# Для работы скрипта необходим пакет jq, установка - apt install jq

# Заполните значения SHM_URL, SHM_USER, SHM_PASS
SHM_URL='https://admin.xxxxxxx.ru'
SHM_USER='admin'
SHM_PASS='xxxxxxx'

# Устанавливаем директорию назначения
BASE_DIR="/opt/shm/tmpl_backup"

# Получаем текущую дату в нужном формате
DATE_DIR=$(date '+%d_%m_%Y-%H_%M')

# Полный путь к поддиректории с текущей датой
DEST_DIR="$BASE_DIR/$DATE_DIR"

# Проверка существования базовой директории и создание её, если она отсутствует
if [[ ! -d "$BASE_DIR" ]]; then
  mkdir -p "$BASE_DIR"
fi

# Создание поддиректории с текущей датой
mkdir -p "$DEST_DIR"

# Счётчики для подсчёта количества шаблонов и файлов
tmpl_counter=0
file_counter=0

# Функция для обработки каждого элемента массива data
process_json_element() {
  local id=$1
  local data=$2
  local settings=$3

  # Выводим имя файла в терминал
  echo "Создан файл: $id"

  # Создание основного файла с содержимым data.data
  echo "$data" > "$DEST_DIR/$id"

  # Если data.settings существует, создаем дополнительный файл
  if [[ ! -z "$settings" ]]; then
    echo "$settings" > "$DEST_DIR/${id}_settings"
    echo "Создан дополнительный файл: ${id}_settings"
    # Увеличиваем счётчик 
    ((file_counter++))
  fi
  # Увеличиваем счётчик
  ((tmpl_counter++))
  ((file_counter++))
}
# Загрузка JSON-файла
curl_response=$(curl -s -o "$DEST_DIR/input.json" -w "%{http_code}" \
-u "${SHM_USER}:${SHM_PASS}" \
-s "$SHM_URL/shm/v1/admin/template" \
-H "Content-Type: application/json" \
-H "Accept: application/json")

# Проверка успешности запроса
if [[ $curl_response =~ ^200 ]]; then
  echo "Данные шаблонов прочитаны успешно."
  sleep 3
else
  echo "Ошибка: Код ответа: $curl_response"
  cat "$DEST_DIR/input.json"
  rm -f "$DEST_DIR/input.json"
  exit 1
fi
# Чтение JSON и обработка каждого элемента массива data
while IFS= read -r line; do
  id=$(echo "$line" | jq -r '.id')
  data=$(echo "$line" | jq -r '.data')
  settings=$(echo "$line" | jq -r '.settings // empty')

  process_json_element "$id" "$data" "$settings"
done < <(jq -c '.data[]' "$DEST_DIR/input.json")

# Удаление input.json - ваш исходный JSON-файл
rm -f "$DEST_DIR/input.json"
# Выводим итоги
echo "Done"
echo "***** ИТОГИ ****"
echo "Всего шаблонов обработано: $tmpl_counter"
echo "Всего создано файлов: $file_counter"
echo "Сохранено в директорию: $DEST_DIR"
