#!/bin/bash

wget -O - https://raw.githubusercontent.com/HoneyHazard/podcasts_directory/main/science_tech_history_etc.m3u  | shuf | xargs -I {} mpv {}
