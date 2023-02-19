#!/bin/bash
server=$1
application=$2
extserver=$3
discord=$4
mention1=$5
mention2=$6



#Get the Variable so we can split it
path=$7
file=$8
time=${8%-*}
key=${time##*-}
time=${time%-*}
numbers=${time%?}
format=${time: -1}
fpath="$path/$file"
jdate=$(date +%s) 
cdate=$(stat -c "%W" $fpath)

if [ "$format" = "m" ]
then
	echo Minutes
	numbers=$(expr $numbers \* 60)
fi

ndate=$(expr $cdate + $numbers)

dif=$(expr $ndate - $jdate)

echo Pfad $path File $file Format $format Time $time numbers $numbers Ndate $ndate jdate $jdate cdate $cdate Differenz $dif Server $server App $application Key $key > ./log.txt

msg="$mention1 Delay Script gestartet. Der delayte Stream geht in $dif Sekunden live."

msg=\"$msg\"

msg2="$mention2 Der Delayte Stream kann jetzt auf rtmp://$extserver/$application/$key mittels VLC angesehen werden."

msg2=\"$msg2\"

if ! [ "$discord" = "1" ]
then
	curl -H "Content-Type: application/json" -X POST -d "{\"content\": $msg}" $discord
fi

sleep $dif 

if ! [ "$discord" = "1" ]
then
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": $msg2}" $discord
fi

ffmpeg="ffmpeg -re -i $fpath -acodec copy -vcodec copy -f flv rtmp://$server/$application/$key"

eval $ffmpeg
