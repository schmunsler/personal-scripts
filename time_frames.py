#!/usr/bin/env python

# time_frames.py
# A helper script to quickly and efficiently time animated gifs
#   from sources with erratic frame rates.
# Layers are assumed to be from SMPlayer output (with names in 
#   the form "shot0001.png")
# Simply delete duplicate frames and run the script to get proper
#  timings added. The timing for the final frame is assumed to be
#  identical to the one before it. Also don't forget that the first
#  frame will likely be renamed "Background". Change it back before
#  deleting anything or you'll lose the timing for it!

from gimpfu import *



def time_frames(image, drawable):
    layers = gimp.image_list()[0].layers
    for layer in layers:
        if not 'prev' in locals():
            prev = layer.name
        else:
            gn = prev[4:8]
            prev = layer.name
            ln = prev[4:8]
            diff = int(gn) - int(ln)
            delay = diff * 40
            layer.name += '(' + str(delay) + 'ms)'
    layers[0].name += layers[1].name[layers[1].name.find('('):]
    
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