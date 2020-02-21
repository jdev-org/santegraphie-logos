#!/bin/bash
#
# Creation script for GCS PWRS server
# Get current path as root
# Get images path from current path
# Get images from sub directory located in root path
# Remove old JSON file if exist
# Create new JSON file
#
#
# Author : gaetan.bruel@gfi.fr
# Version : 2.0
#
# GBR | 1.0 | Init
# GBR | 2.0 | Add one more param to set the json file name
#
# Instruction : Deposit this script in global image directory and get all images in root directory an$

# Obtenir le chemin courant du script
# param is path where json file is suppose to be
# ex : path = htdocs/logo
path=$1

# go to ..../htdocs/logo
cd "$path"

# obtenir le nom du repertoire racine
# ex : name=logo
name=${path##*/}
echo "$name"
# get image path at one sub directory level | create JSON | replace last "},]" by "}]"
res=$(
        # get all images name
        find . -maxdepth 2 -name \*.png -o -name \*.jpg -o -name \*.jpeg -o -name \*.gif -o -name \*.svg -o -name \*.PNG -o -name \*.JPG  -o -name \*.JPEG -o -name \*.SVG -type f |
        # write json structure
        awk 'BEGIN { print "{\n    \"_ROOTDIRNAME_\" : [" }{ print "        {\"file\":\""$1"\"},"}END{print"]}"}' |
        # replace wrong coma char at last end line
        tr '\n' '#' |
        sed 's/,#]/#]/' |
        tr '#' '\n')

# Replace ROOTDIRNAME by real root name
# ex : logo
newRes=${res/_ROOTDIRNAME_/$name}

# erase old file content
# this produce no error  if file not exist
#
> ../$2

# write json in file
# automatically create it if not exist
echo "$newRes" >> ../$2