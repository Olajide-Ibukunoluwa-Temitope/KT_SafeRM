#!/bin/bash
# this is a test project

currentWD=$(pwd)
presentItem=$1
#item=$presentItem
itemPath=$currentWD/$presentItem
trashPath="$HOME/.Trash_Saferm"


#FUNCTIONS
removeFiles(){
  # check if item is a file
  if [[ -f "$1" ]];
  then
      #ask for permission to remove file
          read -p "remove $1? " response
          if [[ $response == Y* ]] || [[ $response == y* ]]
          then
              #remove file
              # presentItem=$presentItem/$object
                   # mv "$presentItem" $trashPath
                  echo "$1 has been removed"
          else
              #file isn't remove
                  echo "$1 not removed"
          fi
   fi
}

checkIfDirectoryIsEmpty(){

  dirContentsCheck=$(ls -l "$1" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)
  #do a check on the the directory
  if [[ $dirContentsCheck -gt 0 ]]
  then
      echo "Directory not empty"
      read -p "examine $presentItem? " response
        if [[ $response == Y* ]] || [[ $response == y* ]]
        then
            recursiveActionInDirectory
        fi
  elif [[ $dirContentsCheck -eq 0 ]]
  then
    echo "Directory empty"
    # mv "$itemPath" $trashPath
  fi

}

recursiveActionInDirectory(){

  echo "============================================"
  echo "in recursiveActionInDirectory";
  #item=$1
  totalItems=$(ls -l "$presentItem" | sort -k1,1  | awk -F " " '{print $NF}' | sed -e '$ d')
  dirContentsCheck=$(ls -l "$presentItem" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)

  # until [[ $dirContentsCheck -eq 0 ]]
  # do
    for object in $totalItems
    do
        if [[ -f "$presentItem/$object" ]]
        then
            removeFiles $presentItem/$object
        elif [[ -d "$presentItem/$object" ]]
        then


            read -p "remove $presentItem/$object? " response
            if [[ $response == Y* ]] || [[ $response == y* ]]
            then

              echo "ghgfggjg"
              presentItem="$presentItem/$object"
              checkIfDirectoryIsEmpty $presentItem
            else
                echo "$presentItem not examined"
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
if [[ -d "$presentItem" ]];
then
    #first do a check to know if file is empty or not
    checkIfDirectoryIsEmpty $1
fi
