#!/bin/bash 
if [ ! -f GAMMA/$1 ]
then
    echo "File not found"
    exit
fi
rm -f $2
kpts='GAMMA 2x2x2 4x4x4 6x6x6 8x8x8'
NK=(1 8 64 216 512)
j=0
for i in ${kpts}
 do
   VBMo=`grep "  4 " $i/$1 | grep " 0.000" | grep " 1 " | awk '{print $3}'`
   VBM=`grep "  4 " $i/$1 | grep " 0.000" | grep " 1 " | awk '{print $4}'`
   CBMo=`grep "  5 " $i/$1 | grep " 2.576" | awk '{print $3}'`
   CBM=`grep "  5 " $i/$1 | grep " 2.576" | awk '{print $4}'`
   case "$1" in 
    *-HF_15*)
      echo  ${NK[$j]} $VBMo $VBM $CBMo $CBM | awk '{print $1 " " $5-$3 }' >>  "$2"
      ;;
    *)
      echo  ${NK[$j]} $VBMo $VBM $CBMo $CBM | awk '{print $1 " " $4+$5 }' >>  "$2"
      ;;
   esac
   j=`expr $j + 1`
 done
