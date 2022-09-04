#!/bin/bash
server=$1
application=$2
key=$3

###DONT CHANGE ANYTHING BELOW THIS IF YOU DONT KNOW WHAT YOU ARE DOING!!!#
#Get the Variable so we can split it
path=$4
file=$5
time=${5%-*}
time=${time%-*}
numbers=${time%?}
format=${time: -1}
fpath="$path/$file"
jdate=$(date +%s)
cdate=$(stat -c "%W" $fpath)

if [ $format -eq "m" ]
then
        echo Minutes
        numbers=$(expr $numbers \* 60)
fi

ndate=$(expr $cdate + $numbers)

dif=$(expr $ndate - $jdate)

sleep $dif

ffmpeg="ffmpeg -re -i $fpath -acodec copy -vcodec copy -f flv rtmp://$server/$application/$key"

echo $ffmpeg

eval $ffmpeg
