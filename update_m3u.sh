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
echo "IPTV M3U файл обновлен: $(date)" > iptv_update.log

# Загрузка файла
wget -O $TEMP_FILE $SOURCE_URL

# Проверка успешности загрузки
if [ $? -eq 0 ]; then
  echo "Файл успешно загружен." >> iptv_update.log

  # Удаляем категории Adult, 18+ и МояКатегория
  grep -ivE "group-title=.*(Adult|18\+|ИНФО)" $TEMP_FILE > filtered_playlist.m3u

  # Добавляем дату обновления в локальный плейлист
  echo "#EXTINF" > updated_local_playlist.m3u
  echo "# Last updated: $(date)" >> updated_local_playlist.m3u
  cat $LOCAL_PLAYLIST >> updated_local_playlist.m3u

  # Объединяем основной и локальный плейлисты
  cat filtered_playlist.m3u updated_local_playlist.m3u > $DESTINATION_PATH

  # Проверяем, что файл не пустой
  if [ -s $DESTINATION_PATH ]; then
    echo "Плейлист успешно обновлен и объединен с локальным." >> iptv_update.log
  else
    echo "Ошибка: Файл пуст после объединения." >> iptv_update.log
    exit 1
  fi
else
  echo "Ошибка загрузки файла." >> iptv_update.log
  exit 1
fi

# Удаляем временный файл
rm -f $TEMP_FILE filtered_playlist.m3u updated_local_playlist.m3u
