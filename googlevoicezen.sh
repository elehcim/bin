#!/bin/bash

# It needs sox to access the audio system
# apt install sox

# and xclip to copy the transcribed text to the clipboard.
# apt install xclip

sec=$(zenity --entry --title="Google Speech Recognition for Linux" --text="How many seconds do you want to speak?" --entry-text "10")
if [[ $sec -gt 0 ]]
then
   (for i in `seq 0 $sec`; do
       sleep 1
       : $((x = sec - $i ))
                 echo "#Waiting $x seconds"
       echo "$x"
   done) | zenity --progress --title="Speak now..." --auto-close & rec -r 16000 -b 16 -c 1 message.wav trim 0 $sec;
 sox message.wav message.flac rate 16k gain -n -5 silence 1 5 2% ;
wget -q -U "Mozilla/5.0" --post-file message.flac --header="Content-Type: audio/x-flac; rate=16000" -O - "https://speech.googleapis.com/v1/speech/recognize?lang=it-IT&client=chromium" >message.ret
 zenity --title="Google Speech Recognition for Linux" --text="        Invio richiesta in corso...        " --info --timeout 3
 echo "4 SED Extract recognized text" 
 cat message.ret | sed 's/.*utterance":"//' | sed 's/","confidence.*//' > message.txt
 echo "5 Remove Temporary Files"
 rm message.flac
 rm message.ret
 echo "6 Show Text "
mex=$(cat message.txt)
zenity --title="Copy to clipboard?" --text="$mex" --question
if [[ "$?" -eq "0" ]]
then
xclip message.txt;

fi
else
zenity --title="Error" --text="Incorrect value." --info;
fi
