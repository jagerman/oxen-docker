#!/bin/bash

set -e

# Naming scheme:
# x -- Android x, with google APIs (but no play store)
# x-nogoog -- Android x without google APIs
# x-play -- Android x with google APIs + play store

declare -A images=(
    [6]='https://dl.google.com/android/repository/sys-img/google_apis/x86-23_r33.zip'
    [9]='https://dl.google.com/android/repository/sys-img/android/x86_64-28_r04.zip'
    [11]='https://dl.google.com/android/repository/sys-img/android/x86_64-30_r10.zip'
    [12-nogoog]='https://dl.google.com/android/repository/sys-img/android/x86_64-31_r03.zip'
    [13]='https://dl.google.com/android/repository/sys-img/google_apis/x86_64-UpsideDownCake_r02.zip'
)

emulator='https://dl.google.com/android/repository/emulator-linux_x64-9751036.zip'

emu="$(basename $emulator)"
if ! [ -e "$emu" ]; then
    wget "$emulator"
fi


cd android-emulator-container-scripts
. configure.sh
cd ..

for i in "${!images[@]}"; do
    img="$(basename ${images[$i]})"
    if ! [ -e "$img" ]; then
        wget "${images[$i]}"
    fi
    emu-docker create \
        --dest android-$i \
        --tag $i \
        --repo registry.oxen.rocks/android-emu \
        --no-metrics \
        "$emu" "$img"
done

