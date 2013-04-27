#!/usr/bin/env python

# time_frames.py
# A helper script to quickly and efficiently time animated gifs from sources with erratic key frame rates.
# Layer names must contain original frame numbers (e.g. shot0001.png, frame0001.png, etc.).
# Simply delete duplicate frames (but leave the last one) and run the script to get proper timings added. 
# Also don't forget that the first frame will likely be renamed "Background". Change it back before
#  deleting anything or you'll lose the timing for it!
# If you want to keep the last frame, time it manually and it will be ignored.

from gimpfu import *
import re

def time_frames(image, drawable):
    image = gimp.image_list()[0]
    keep_last = (image.layers[0].name.find('ms') != -1)
    for layer in image.layers:
        if not 'prev' in locals():
            prev = int(re.search(r'\d+', layer.name).group())
            if not keep_last:
                prev += 1
        else:
            gn = prev
            prev = ln = int(re.search(r'\d+', layer.name).group())
            delay = (gn - ln) * 40
            layer.name += '(' + str(delay) + 'ms)'
    if not keep_last:
        image.remove_layer(image.layers[0])
    
register(
    "time_frames",
    "Add timing to frames based on difference in layer names",
    "Add timing to frames based on difference in layer names",
    "Cory Schmunsler",
    "WTFPL",
    "2013",
    "<Image>/Filters/Animation/Time Frames",
    "*",
    [],
    [],
    time_frames)
    
main()