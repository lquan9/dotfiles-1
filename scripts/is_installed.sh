#!/bin/bash
# Returns 0 if application is installed or error if it is not

which "${1}" | grep -o "${1}" > /dev/null && exit 0 || exit 1
