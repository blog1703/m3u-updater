#!/bin/bash

# URL источника M3U файла
SOURCE_URL="https://iptvshared.ucoz.net/IPTV_SHARED.m3u"

# Путь, куда сохранять обновленный файл
DESTINATION_PATH="iptv.m3u"

# Локальный плейлист
LOCAL_PLAYLIST="local_playlist.m3u"

# Временный файл для обработки
TEMP_FILE="temp.m3u"

# Логирование
LOG_FILE="iptv_update.log"
echo "IPTV M3U файл обновлен: $(date)" > $LOG_FILE

# Удаление временных файлов при завершении
trap "rm -f $TEMP_FILE filtered_playlist.m3u updated_local_playlist.m3u" EXIT

# Проверка существования локального плейлиста
if [ ! -f "$LOCAL_PLAYLIST" ]; then
  echo "Локальный плейлист $LOCAL_PLAYLIST не найден." >> $LOG_FILE
  exit 1
fi

# Загрузка файла
wget -O $TEMP_FILE $SOURCE_URL

# Проверка успешности загрузки
if [ $? -eq 0 ]; then
  echo "Файл успешно загружен." >> $LOG_FILE

  # Удаляем категории Adult, 18+ и МояКатегория
  grep -ivE "group-title=.*(Adult|18\+|ИНФО)" $TEMP_FILE > filtered_playlist.m3u

  # Обрабатываем каждую строку локального плейлиста
  > updated_local_playlist.m3u  # Очищаем файл перед записью
  while IFS= read -r line; do
    if [[ $line == *"#EXTINF"* ]]; then
      # Добавляем дату обновления к названию канала
      echo "${line} (Обновлено: $(date +'%Y-%m-%d %H:%M:%S'))" >> updated_local_playlist.m3u
    else
      echo "$line" >> updated_local_playlist.m3u
    fi
  done < "$LOCAL_PLAYLIST"

  echo "Локальный плейлист обработан. Дата добавлена в названия каналов." >> $LOG_FILE

  # Проверяем, что оба файла не пусты
  if [ ! -s filtered_playlist.m3u ]; then
    echo "Ошибка: Отфильтрованный плейлист пуст." >> $LOG_FILE
    exit 1
  fi

  if [ ! -s updated_local_playlist.m3u ]; then
    echo "Ошибка: Локальный плейлист пуст." >> $LOG_FILE
    exit 1
  fi

  # Объединяем основной и локальный плейлисты
  cat filtered_playlist.m3u updated_local_playlist.m3u > $DESTINATION_PATH

  # Проверяем, что файл не пустой
  if [ -s $DESTINATION_PATH ]; then
    echo "Плейлист успешно обновлен и объединен с локальным." >> $LOG_FILE
  else
    echo "Ошибка: Файл пуст после объединения." >> $LOG_FILE
    exit 1
  fi
else
  echo "Ошибка загрузки файла." >> $LOG_FILE
  exit 1
fi
