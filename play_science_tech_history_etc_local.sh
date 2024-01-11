#!/bin/bash

git pull

playlist_filename="temp_playlist.m3u"
player_command="strawberry --play --load ${playlist_filename}"
player_kill="pkill -f strawberry"

rm ${playlist_filename}
echo "#EXTM3U" > ${playlist_filename}

last_label=""
OLDIFS=$IFS
IFS=$'\n'

echo "$(date)" > temp_playlist.log

for f in $(cat science_tech_history_etc.m3u); do
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
            echo ============= ${last_label} ================ >> temp_playlist.log
            # preserve label for m3u
            use_label=${last_label}
            last_label=""
         else
            # just use rss link as label in output
            echo ============= ${f} ================
            echo ============= ${f} ================ >> temp_playlist.log
            # no label for m3u
            use_label=""
         fi

         curl -s ${f} > temp_podcast.xml
         audio_links=$(xmlstarlet sel -q -t -m "//item[contains(enclosure/@type, 'audio')]" -v "enclosure/@url" -n temp_podcast.xml | uniq | head -n 2)
         video_links=$(xmlstarlet sel -q -t -m "//item[contains(enclosure/@type, 'video')]" -v "enclosure/@url" -n temp_podcast.xml | uniq | head -n 2)

         i=1
         for url in ${audio_links}; do
             title=$(xmlstarlet sel -q -t -m "//item[contains(enclosure/@url, '${url}')]" -v "title" -n temp_podcast.xml)
             echo "Title: ${title}"
             echo "Title: ${title}" >> temp_playlist.log
             echo "Url: "${url}
             echo "Url: "${url} >> temp_playlist.log

             if [[ -n $use_label ]]; then
                 echo "#EXTINF:-1,${use_label} - ${use_label} Audio #${i}: ${title}" >> ${playlist_filename}
             else
                 echo "#EXTINF:-1,Podcast - Audio #${i}: ${title}" >> ${playlist_filename}
             fi
             echo ${url} >> ${playlist_filename}
             ((i++))
         done

         i=1
         for url in ${video_links}; do
             title=$(xmlstarlet sel -q -t -m "//item[contains(enclosure/@url, '${url}')]" -v "title" -n temp_podcast.xml)
             echo "Title: ${title}"
             echo "Title: ${title}" >> temp_playlist.log
             echo "Url: "${url}
             echo "Url: "${url} >> temp_playlist.log

             if [[ -n $use_label ]]; then
                 echo "#EXTINF:-1,${use_label} - ${use_label} Video #${i} - ${title}" >> ${playlist_filename}
             else
                 echo "#EXTINF:-1,Podcast - Video #${i}: ${title}" >> ${playlist_filename}
             fi
             echo ${url} >> ${playlist_filename}
             ((i++))
         done
         rm temp_podcast.xml > /dev/null
    fi
done

IFS=$OLDIFS

${player_kill}

sleep 1

./shuffle_playlist.py

#${player_kill}

sleep 2

${player_command} &

