#! /bin/bash
# mo -- standardize orgnization of music files
# use: mo [-l N[,N[...]]]
# options:
#     -l : Tracks to create lyric files (and search lyrics) for. Defaults to all.

nolyrics=false

getopts "l:" opt
case $opt in
    l)
        if [ $OPTARG == 0 ]; then
            nolyrics=true
        else
            lyrics=$OPTARG
        fi
    ;;
esac


function filetracks {
    lltag --yes --rename %n.%t *.flac
}

function makelyrics {
    if [ ! -d "lyrics" ]; then
        mkdir lyrics
    fi
    exclude="[Ii][Nn][Ss][Tt]|[Kk]araoke|からおけ|カラオケ|[Oo]ff [Vv]ocal"
    IFS=$'\n'
    for i in `ls | grep .flac`; do
        tid=${i%.*}
        tno=${tid%%.*}
        lrcf="lyrics/$tid.txt"
        if [[ -z `echo $tid | egrep $exclude` ]]; then
            if [[ -z "$lyrics" || "$lyrics" =~ "$tno" ]]; then
                if [ ! -e $lrcf ]; then
                    >$lrcf
                    title=${tid#*.}
                    google-chrome "http://www.kasi-time.com/allsearch.php?q=$title"
                    kwrite $lrcf
                fi
            fi
        fi
    done
}

function filescans {
    # Check if there's already a scans folder and rename it to "scans"
    imgext="jpg|png|bmp|JPG|PNG|BMP"
    for f in *; do
        if [ -d "$f" ]; then
            if [[ -n `ls $f/ | egrep "$imgext"` ]]; then
                mv $f "scans"
                break
            fi
        fi
    done
    
    # and move all scans to it
    for f in *; do
        if [[ ! -z $(echo "$f" | egrep "$imgext") ]]; then
            if [[ "$f" =~ [Cc]over\.jpg ]]; then
                mv "$f" "cover.jpg" 2>/dev/null
            else if [[ "$f" =~ [Cc]over\.png ]]; then
                mv "$f" "cover.png"
            else
                mkdir "scans" 2>/dev/null
                mv "$f" "scans"
            fi fi
        fi
    done
}

function removetxt {
    rm *.txt 2>/dev/null
    rm *.log 2>/dev/null
    rm *.nfo 2>/dev/null
    rm *.url 2>/dev/null
    rm *.URL 2>/dev/null
}

filescans
filetracks
if [ $nolyrics == false ]; then
    makelyrics 
fi
removetxt