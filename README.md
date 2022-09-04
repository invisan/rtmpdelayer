# rtmpdelayer
This is a quick and small Delay script for Linux Based on Bash, incrontab and ffmpeg

Features:
- Leightweight
- Adjust the Delay Variable through the Streamkey
- Almost direct reconnect when you loose the connection
- Script starts automatically when there is a new File being recorded

What you need:

- FFMPEG installed
- incron installed
- an RTMP Server
  - automated recording set for the Incoming RTMP Application
  
  
Installation:

1) If you havent done already install ffmpeg-full, incron and an RTMP Server. 
            - I suggest using nginx with its embedded RTMP Client.

2) If you are using Nginx with its embedded RTMP Plugin you need to configure the following

Add this to your nginx.conf
```
 application nodelayrecord {
 
                        live on;
                        record all;
                        record_path /this/is/the/path/where/the/recording/will/be/stored;
                        record_unique on; #THIS IS IMPORTANT
                        record_suffix .flv;

                }

application yourdelayedstream {

                      live on;
                      record off;
                     
}
```

2) Set nodelayrecord and yourdelayedstream to names of your choice as well as record_path.

3) Create the delay.sh in a Path of your Choice 

4) Create an entry in incron with `incrontab -e`


```
/this/is/your/record/path           IN_CREATE       /this/is/the/delayscript/path/delay.sh 127.0.0.1 DELAYAPPLICATIONNAME KEYOFTHESTREAM $@ $#
```


Example:

```
/home/invisan/myrecords            IN_CREATE        /home/invisan/delay.sh 127.0.0.1 delay delayed $@ $#
/home/invisan/anotherrecord        IN_CREATE        /home/invisan/delay.sh 127.0.0.1 corporate mystream $@ $#
```

Close the Editor with CTRL + X and save your Changes. You can add more then one line if you want to stream to different Applications for example. The Important thing is dont remove the $@ and $# at the end. These are used to pass the Filepath and the name of the File to the Delay Script.
Incron itself checks the Folder you specify at the first Position with the IN_CREATE Tag for newly created files. As soon as a file is created in the Folder specified in the same Line it will trigger the Command at the End.
So only the Command at the end of myrecords will run if there is a stream to your application which records into that Folder. The Command from anotherrecord will not be triggered.

5) Now you can stream a Teststream to your Server at example `rtmp://yourserverip/yournodelayrecordapplication` the Streamkey will pass the time of the Delay to the Script. You can use either seconds or minutes.

Example:

```
8m-yourname
```

Will result in the Delay being 8 Minutes

```
25s-yourname
```

Will result in the Delay being 25 seconds and so on. 

CAREFUL:

```
Please use only full Minutes Stuff like 9,5m-yourname wont work

The m and s is case sensitive.

If you dont use m or s the Delay will be considered as Seconds.

If you dont use the Format with the - between Numbers and Name or no name behind the Numbers there wont be any delay added!

You should NEVER NEVER EVER change your Delay on the fly to a lower Delay! Adding Delay works without a Problem though.

- Working:
          Starting with 40 Seconds of Delay. Stopping your Stream with OBS and changing it to 80 Seconds
          
- Not working:
          Starting with 80 Seconds of Delay. Stopping Stream and changing it to 40 Seconds.
          The Problem with this is that the Script will automatically play your Stream till your recording is over.
          If you want to lower the Delay you need to wait till the remaining play time is low enough that not both Streams will be running at the same time.
          So if you want to go from 80 to 40 seconds you need to stop your stream and wait for minimum 40 Seconds before you start it up again. 
```
