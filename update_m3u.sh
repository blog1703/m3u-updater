#!/bin/bash

# URL источника m3u
M3U_SOURCE="https://iptvshared.ucoz.net/IPTV_SHARED.m3u"

# Имя файла для сохранения
M3U_FILE="playlist.m3u"

# Запрещенные категории
BLOCKED_KEYWORDS="Adult|18+|Взрослые|ИНФО"

# Фильтрация запрещенных категорий
grep -ivE "$BLOCKED_KEYWORDS" $TEMP_FILE > $DESTINATION_PATH

# Скачиваем файл
wget -O "$M3U_FILE" "$M3U_SOURCE"

# Логируем результат
echo "Файл обновлен: $(date)" >> update.log
