#!/bin/bash
config=$1

#Get Settings from Conf File
server=$(sed '1q;d' $config | cut -d '=' -f 2 | cut -d '"' -f 2)
extserver=$(sed '2q;d' $config | cut -d '=' -f 2 | cut -d '"' -f 2)
application=$(sed '3q;d' $config | cut -d '=' -f 2 | cut -d '"' -f 2)
discord=$(sed '4q;d' $config | cut -d '=' -f 2 | cut -d '"' -f 2)
mention1=$(sed '5q;d' $config | cut -d '=' -f 2 | cut -d '"' -f 2)
mention2=$(sed '6q;d' $config | cut -d '=' -f 2 | cut -d '"' -f 2)



path=$2
file=$3
time=${3%-*}
key=${time##*-}
time=${time%-*}
numbers=${time%?}
format=${time: -1}
fpath="$path/$file"
jdate=$(date +%s)
cdate=$(stat -c "%W" $fpath)

if [ "$cdate" = "0" ]
then
        cdate=$jdate
fi


if [ "$format" = "m" ]
then
        echo Minutes
        numbers=$(expr $numbers \* 60)
fi

ndate=$(expr $cdate + $numbers)

dif=$(expr $ndate - $jdate)

echo Pfad = $path File = $file Format = $format Time = $time numbers = $numbers Ndate = $ndate jdate = $jdate cdate = $cdate Differenz = $dif Server = $server App = $application Key = $key DC Webhook = $discord > ./log.txt

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
