#/bin/bash
cat ${1} | grep xmlUrl | grep -o 'http.*\.rss'
cat ${1} | grep xmlUrl | grep -o 'http.*\.xml'

