#!/bin/bash
echo ${LFS:?}
echo 
echo "Processing $2"
echo

cd $LFS/sources
tar -xf $FILE
DIR=$(echo $FILE | awk -F"\\\\.t" '{print $1}')
cd $DIR
