#!/bin/bash

playlist_filename="temp_playlist.m3u"
#player_command="smplayer ${playlist_filename}"
#player_command="nvlc --loop --random --playlist-autostart ${playlist_filename}"
#player_command="vlc --loop --random --playlist-autostart ${playlist_filename}"
player_command="celluloid ${playlist_filename}"

rm ${playlist_filename}

#for f in `cat science_tech_history_etc.m3u` ; do
#for f in `cat science_tech_history_etc.m3u | head -n 3` ; do

last_label=""
OLDIFS=$IFS
IFS=$'\n'

echo "$(date)" > temp_playlist.log

for f in `cat science_tech_history_etc.m3u` ; do
# for f in `cat science_tech_history_etc.m3u` ; do
    # remove leading spaces
    f=${f##*( )}

    if [[ "${f:0:1}" == "#" ]]; then
       # specified label available
       f=${f:1}
       f=${f##*( )}
       last_label=${f}
    elif [[ -n "${f}" ]]; then
         if [[ -n "${last_label}" ]]; then
            # label specified earlier
            echo ============= ${last_label} ================
            echo ============= ${last_label} ================ >> temp_playlist.org
            last_label=""
         else
            # just use rss link as label
            echo ============= ${f} ================
            echo ============= ${f} ================ >> temp_playlist.org
         fi

         for url in `curl --silent ${f} | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*(mp3|mp4|m4a|ogg)" | uniq | head -n 2`;
         do
             echo ${url}
             echo ${url} >> temp_playlist.org
             #smplayer -add-to-playlist ${url} > /dev/null
             echo ${url} >> ${playlist_filename}
         done
    fi
#    sleep 5
done

IFS=$OLDIFS

${player_command} &
