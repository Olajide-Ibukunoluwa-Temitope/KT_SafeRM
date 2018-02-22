#!/bin/bash
# this is a test project

currentWD=$(pwd)
presentItem=$1
#item=$presentItem
itemPath=$currentWD/$presentItem
trashPath="$HOME/.Trash_Saferm"
# treeDepth=-1
# treeDepthIterationArray[0]=1



#FUNCTIONS
removeFiles(){
  # check if item is a file

  if [[ -f "$1" ]];
  then
      #ask for permission to remove file
          read -p "remove $currentdir/$object? " response
          if [[ $response == Y* ]] || [[ $response == y* ]]
          then
              #remove file
              # presentItem=$presentItem/$object
                   # mv "$presentItem" $trashPath
                  echo "$currentdir/$object has been removed"
          else
              #file isn't remove
                  echo "$currentdir/$object not removed"
          fi
   fi
}

checkIfDirectoryIsEmpty(){
  # echo "============================================"
  # echo "in checkIfDirectoryIsEmpty";

          dirContentsCheck=$(ls -l "$1" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)
          #do a check on the the directory
          if [[ $dirContentsCheck -gt 0 ]]
          then
              # echo "Directory not empty"
            recursiveActionInDirectory $1

          elif [[ $dirContentsCheck -eq 0 ]]
          then
              # echo ""
              # read -p "remove directory $1? " response
              # if [[ $response == Y* ]] || [[ $response == y* ]]
              # then
                  echo "$1 removed"
              #     # mv "$itemPath" $trashPath
              # fi
          fi
        # else
        #     echo "Directory not examined"
        # fi

}

recursiveActionInDirectory(){

  # echo "============================================"
  # echo "in recursiveActionInDirectory";
  #item=$1
  # presentItem="$presentItem/$object"
  currentdir="$1"
  totalItems=$(ls -l "$currentdir" | sort -k1,1  | awk -F " " '{print $NF}' | sed -e '$ d')
  dirContentsCheck=$(ls -l "$1" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)

  # until [[ $dirContentsCheck -eq 0 ]]
  # do
    for object in $totalItems
    do

        # echo "looping again"

        if [[ -f "$currentdir/$object" ]]
        then
            removeFiles $currentdir/$object
        elif [[ -d "$currentdir/$object" ]]
        then

            read -p "do you want to examine files in $currentdir/$object? " response
            if [[ $response == Y* ]] || [[ $response == y* ]]
            then

              # presentItem="$presentItem/$object"

              # echo "presentItem is $presentItem"
              checkIfDirectoryIsEmpty $currentdir/$object

            else
                echo "$currentdir/$object not examined"
            fi
        fi
    done
  # done
}

#FOR FILES
if [[ -f "$presentItem" ]];
then
    removeFiles $presentItem
fi

#FOR DIRECTORIES
if [[ -d "$1" ]];
then
  # currentdir="$1"
  read -p "do you want to examine files in $1? " response

     if [[ $response == Y* ]] || [[ $response == y* ]]
     then
    #first do a check to know if file is empty or not
        checkIfDirectoryIsEmpty $1
     else
         echo "$1 not examined"
     fi
fi
