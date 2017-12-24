#!/bin/bash

mouseDown=false;
while true; do
    mouseState=$(xinput --query-state 16 | grep -e 'button\[1\].*' | cut -d '=' -f2 | awk '{print $1}')
    if [[ "$mouseState" == "down" && $mouseDown == false ]]; then
        mouseLocation=$(xdotool getmouselocation)
        mouseStartX=$(echo "$mouseLocation" | cut -d ':' -f2 | awk '{print $1}')
        mouseStartY=$(echo "$mouseLocation" | cut -d ':' -f3 | awk '{print $1}')
        mouseDown=true;
        echo 'Got Start'
    elif [[ "$mouseState" == "down" && $mouseDown == true ]];
    then 
        endMouseLocation=$(xdotool getmouselocation)
        mouseEndX=$(echo "$endMouseLocation" | cut -d ':' -f2 | awk '{print $1}')
        mouseEndY=$(echo "$endMouseLocation" | cut -d ':' -f3 | awk '{print $1}')
        mouseDown=false;
        if [[ $mouseStartX -gt $mouseEndX ]]
        then
            sizeX=$(($mouseStartX-$mouseEndX))
        else
            sizeX=$(($mouseEndX-$mouseStartX))
        fi
        if [[ $mouseStartY -gt $mouseEndY ]]
        then
            sizeY=$(($mouseStartY-$mouseEndY))
        else
            sizeY=$(($mouseEndY-$mouseStartY))
        fi
        ffmpeg -video_size "$sizeX"x"$sizeY" -framerate 30 -f x11grab -i :1.0+$mouseStartX,$mouseStartY -t 00:00:03 -y /home/adamantius7877/Tests/output.mkv
        ffmpeg -i /home/adamantius7877/Tests/output.mkv -vf scale=300:-1 -y /home/adamantius7877/Tests/test.gif
        rm /home/adamantius7877/Tests/output.mkv
        xclip -selection clipboard -t image/gif /home/adamantius7877/Tests/test.gif
        break
    fi
    sleep 0.2
done
