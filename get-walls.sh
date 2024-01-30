#!/usr/bin/env bash


###############################################################################
#                       Crawl Images from wallpaperswide                      #
###############################################################################
#
# Intro #######################################################################
#
# Make sure you installed
# 
# 1. wget - brew install wget
# 2. htmlq, or similar html parsing tools - cargo install htmlq
#
# Usage
# 
# 1. mkdir downloads
# 2. . ./get-walls.sh
# 
for page in $(seq 1 4024); do
    echo $page
    if [ $page -eq 1 ]; then
        pageurl=https://wallpaperswide.com
    else
        pageurl=https://wallpaperswide.com/page/$page
    fi
    pageLinks=$(curl --silent $pageurl | htmlq "ul.wallpapers a" --attribute href)
    while IFS= read -r link; do
        link=https://wallpaperswide.com$link
        resolutionLinks=$(curl --silent $link | htmlq "#wallpaper-resolutions a" --attribute href)
        imageurl=$(echo $resolutionLinks | sed 's/.*EPI_\([0-9]*\)/\1 &/' | sort -n -k 3 -t '-' -r | head -n 1)
        imageurl=https://wallpaperswide.com$imageurl
        wget -c $imageurl -P downloads/ --progress=bar:force 2>&1 | grep '%'
    done <<<"$pageLinks"
done
