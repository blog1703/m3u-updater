#!/bin/bash

# URL источника m3u
M3U_SOURCE="https://iptvshared.ucoz.net/IPTV_SHARED.m3u"

# Имя файла для сохранения
M3U_FILE="playlist.m3u"

# Скачиваем файл
wget -O "$M3U_FILE" "$M3U_SOURCE"

# Логируем результат
echo "Файл обновлен: $(date)" >> update.log
