#!/bin/bash

# URL источника M3U файла
SOURCE_URL="https://iptvshared.ucoz.net/IPTV_SHARED.m3u"

# Путь, куда сохранять обновленный файл
DESTINATION_PATH="iptv.m3u"

# Временный файл для обработки
TEMP_FILE="temp.m3u"

# Логирование
echo "IPTV M3U файл обновлен: $(date)" > iptv_update.log

# Загрузка файла
wget -O $TEMP_FILE $SOURCE_URL

# Проверка успешности загрузки
if [ $? -eq 0 ]; then
  echo "Файл успешно загружен."

  # Удаляем категории Adult и 18+
  grep -ivE "group-title=.*(Adult|18\+|Взрослые)" $TEMP_FILE > $DESTINATION_PATH

  # Проверяем, что файл не пустой
  if [ -s $DESTINATION_PATH ]; then
    echo "Категории Adult и 18+ удалены."
  else
    echo "Ошибка: Отфильтрованный файл пуст."
    exit 1
  fi
else
  echo "Ошибка загрузки файла."
  exit 1
fi

# Удаляем временный файл
rm -f $TEMP_FILE
