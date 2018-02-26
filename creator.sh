#!/bin/bash

argFirst="$( echo $@ | awk '{ print $1 }')"
argLast="$( echo $@ | awk '{ print $NF }' | xargs)"
subDirectoryNameOptions="$( echo $@ | awk '{$1=""; print $0}' | awk '{$NF=""; print $0}' )"

logFile="test.log"


cFlag=0
rFlag=0
bFlag=0

cArg1=0
rArg1=""
bArg1=""



#create a specific file structure
createFileStructureAll(){

  #create an array of possible names that can be used for subdirectories
  arrayOfNameOptions=($rArg1)
  echo "arrayOfNameOptions = $arrayOfNameOptions"
  arrayOfNameOptionsLength=${#arrayOfNameOptions[@]}

  parentLevelDir="$2"

  #3 number of iterations
  iteration=$1

  randOneToTwelve=$(( ($RANDOM % 10) + 2 ))
  randOneToThree=$(( ($RANDOM % 3) + 1 ))

  parentLevelFilename=$parentLevelDir$iteration

  #create parent level directory
  mkdir $parentLevelFilename

  for ((i=0; i <= randOneToTwelve; i++))
  do
    # echo "$parentLevelFilename/""$parentLevelDir""_file_$i.txt"
    touch "$parentLevelFilename/""$parentLevelDir""_file_$i.txt"
  done

  for ((y=0; y <= randOneToThree; y++))
  do

    randWithinArrayLength=$(($RANDOM % $arrayOfNameOptionsLength))
    echo "randWithinArrayLength = $randWithinArrayLength" >> $logFile
    randomArrayItem=$(echo ${arrayOfNameOptions[$randWithinArrayLength]})
    dirToCreate="$parentLevelFilename""/$randomArrayItem""_$y"
    mkdir "$dirToCreate"

    for ((x=0; x <= randOneToTwelve; x++))
    do
      touch "$dirToCreate""/""$randomArrayItem""_$x"".txt"
    done

  done

}

bArg1="myTestDir"

while getopts "b:c:r:" opt; do
  case $opt in

    b) #base name

      bFlag=1
      bArg1=$OPTARG

      ;;
    c) #count
      regexNumber='^[0-9]+$'

      #if the argument passed in to the option is a number
      if [[ $OPTARG =~ $regexNumber ]]
      then
        cFlag=1
        cArg1=$OPTARG
      else
        echo "cdf: error -c option only takes whole numbers"
        exit $?
      fi
      ;;

    r)

      rFlag=1;
      rArg1=$OPTARG
      ;;

    \?)
      echo "cdf: error invalid option: -$OPTARG"
      ;;
  esac
done
shift "$(($OPTIND -1))"



if [[ $rFlag -eq 1 && $cFlag -eq 1 && $bFlag -eq 1 ]]
then
  for i in `seq $cArg1`
  do
    createFileStructureAll $i $bArg1 $rArg1
  done
else
  echo "cdf: error all options -c (count) -b (baseDirName) -r(random dir name) must be provided"
fi
