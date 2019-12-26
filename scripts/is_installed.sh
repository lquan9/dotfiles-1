#!/bin/bash

#which "$1" | grep -o "$1" > /dev/null &&  echo "Installed!" || echo "Not Installed!"
which "$1" | grep -o "$1" > /dev/null && exit 1 || exit 0
