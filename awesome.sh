#!/bin/bash

DB=${XDG_DATA_HOME:-$HOME/.local/share}/uzbl/awesome.db

URI=$(echo $6 | sed 's/ //')

if [[ $URI == "" ]]; then
    exit 1
fi

if [[ ! -f $DB ]]; then
    touch $DB
fi

TMP=$(mktemp)

DATE=$(date +"%s")
LIMIT=$((60 * 60 * 24 * 3))

if [[ ! $(grep -i $URI $DB) ]]; then
    echo  "$URI,$7,0,$DATE" >> $DB
fi

awk -v uri=$URI -v date=$DATE -v lim=$LIMIT -F "," \
    '{
        if($1 == uri) print $1","$2","$3+1","date;
        else if($4 + lim > date) print $0
    }' $DB >>  $TMP

sort -rk 3 -k 4 -t "," $TMP > $DB

rm $TMP
