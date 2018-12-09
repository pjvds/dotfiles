#!/bin/bash 
 
# Random Word Generator 
# linuxconfig.org 
 
if [ $# -ne 1 ] 
then 
echo "Please specify how many random words would you like to generate !" 1>&2 
echo "example: ./random-word-generator 3" 1>&2 
echo "This will generate 3 random words" 1>&2 
exit 0
fi 
 
# Constants 
X=0
ALL_NON_RANDOM_WORDS=/usr/share/dict/words
 
# total number of non-random words available 
non_random_words=`cat $ALL_NON_RANDOM_WORDS | wc -l` 
 
# while loop to generate random words  
# number of random generated words depends on supplied argument 
while [ "$X" -lt "$1" ] 
do 
random_number=`od -N3 -An -i /dev/urandom | 
awk -v f=0 -v r="$non_random_words" '{printf "%i\n", f + r * $1 / 16777216}'` 
sed `echo $random_number`"q;d" $ALL_NON_RANDOM_WORDS 
  let "X = X + 1" 
done
