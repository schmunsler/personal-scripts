#!/bin/bash
# Creates a tree of directories and symlinks
# in the current directory so that any dir
# found at ./dir1/dir2/dir3 etc. (for any depth)
# can also be found at any permutation of those names
# e.g. ./dir3/dir2/dir1 and ./dir2/dir3/dir1 will 
# both be symlinks to ./dir1/dir2/dir3
#
# This is useful as a simple tagging system when you're interested
# files with a specific combination of tags and excluding all others

# returns all dirs (not symlinks) breadth-first
function get_real_dirs { 
    # http://stackoverflow.com/questions/11703979/sort-files-by-depth-bash
    find . -type d | # find all real directories
    sed '/^\.$/d; s|^\./||g' | # remove . line and leading ./'s
    perl -lne 'print tr:/::, " $_"' | # add / count to each line
    sort -n | # sort by / count
    cut -d' ' -f2 # cut down to just path
}

# links all other possible permutations to the given dir
function canonize { # args: <path of dir to canonize>
    realdir=$1
    echo "canonizing $realdir"
    # get all locations that should link to realdir
    allpaths=( $(get_permutations $realdir) )
    for path in ${allpaths[@]}; do
        make_link $realdir $path
    done
}

# ouputs all other possible permutations of the given dir
function get_permutations { # args: <path of dir to permute>
    # split path into array of names
    elements=$( echo $1 | tr "/" "\n" )
    # use perl magic to get each permutation
    IFS=$'\n'
    for perm in `permute.pl ${elements[@]}`; do
        # permute.pl output separates elements with spaces
        # replace with / to form path and return
        echo $perm | tr " " "/"
    done
}

# makes a link to the first arg at the path given in the second
# creates any dirs in the path which do not already exist, and
# recursively canonizes them to avoid making two dirs with the
# same combination (an inconsistent state)
function make_link { # args: <path to target> <path to link>
    target=$1
    linkpath=$2
    # if it exists, great
    if [ ! -e $linkpath ]; then
        # otherwise, split path into array of parts
        parts=( ${linkpath//\// } ) # split on /
        i=1
        # for each partial path up to but excluding linkpath
        while [ $i -lt ${#parts[@]} ]; do
            # generate the path up to i dirs deep
            partialpath=$(echo ${parts[@]:0:$i} | tr " " "/")
            # check if it exists (and is a dir)
            if [ ! -d $partialpath ]; then
                # if not, make it
                echo "making $partialpath"
                mkdir $partialpath
                # and canonize the new dir. Yay recursion!
                ( canonize $partialpath )
                # this is guaranteed to end because partialpath is
                # strictly shorter than linkpath, and when linkpath
                # has depth 1 this while loop never runs
            fi
            let "i+=1" # increment i
        done
        # add leading ../'s to get back to base dir from target
        for j in $( seq 2 ${#parts[@]} ); do
            target="../$target"
        done
        # now that we're sure all the dirs up the link exist,
        # just make the link
        ln -s "$target" $linkpath
    fi
}

# canonizes all existing dirs, shallowest first
function canonize_all {
    for d in $(get_real_dirs); do
        canonize $d
    done
}

canonize_all