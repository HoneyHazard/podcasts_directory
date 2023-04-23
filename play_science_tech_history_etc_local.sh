#!/bin/bash

for f in `cat science_tech_history_etc.m3u | shuf` ; do
    echo ============= ${f} ================

    for url in `curl --silent ${f} | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*(mp3|mp4|m4a|ogg)" | uniq | head -n 2`; do
       echo ${url}
       smplayer -add-to-playlist ${url} > /dev/null
    done
    sleep 5
done
