#!/bin/bash

#awk '/\[log\]/{x=NR+2}(NR<=x){print}' "${HOME}/.gitconfig"
testvar="$(awk '/\[log\]/{section=1;next}/\[.*\]/{section=0}section' "${HOME}/.gitconfig")"
#awk '/\[.*\]/{section=1;print;next}/\[.*]/{print;section=0}section' "${HOME}/.gitconfig"
# awk ' BEGIN {  print "The number of times difftools appears in the file is:" ; }
# /difftool/ {  counter+=1  ;  }
# END {  printf "%s\n",  counter  ; } 
# '  "${HOME}/.gitconfig"
echo "${testvar}"