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

  # if [[ -f "$1" ]];
  # then
      #ask for permission to remove file
          # read -p "remove $currentdir/$object? " response
          # if [[ $response == Y* ]] || [[ $response == y* ]]
          # then
              #remove file
              echo " "
                 # mv "$1" $trashPath
               # echo "$1 has been removed"
          # else
          #     #file isn't remove
          #         echo "$currentdir/$object not removed"
          # fi
   # fi
}

 backToRootDir(){
   # echo "=============================================="
   # echo " THIS IS BACK TO DIR!!!!!!!!! "
   # echo "=============================================="
  dirContentsCheck=$(ls -l "$1" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)

    read -p "remove $1? " response
    if [[ $response == Y* || $response == y* ]] && [[ $dirContentsCheck -eq 0 || $dirContentsCheck -gt 0 ]]
    then
      removeFiles $1
      # backToRootDir $currentdir
      # echo "PRESENT SIR!!!!!!"
        echo "$1 removed"
    else
        echo "$1 not removed"
    fi
}


recursiveActionInDirectory(){
     # echo "============================================"
     # echo "in recursiveActionInDirectory"
     # echo "============================================"

    currentdir="$1"
    totalItems=$(ls -l "$currentdir" | sort -k1,1  | awk -F " " '{print $NF}' | sed -e '$ d')
    # dirContentsCheck=$(ls -l "$1" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)

          for object in $totalItems
          do
              # echo "looping again"
              if [[ -f "$currentdir/$object" ]]
              then
                  removeFiles $currentdir/$object
              else
                  read -p "examine files in directory $currentdir/$object? " response
                  if [[ $response == Y* ]] || [[ $response == y* ]]
                  then
                    currentdir="$1"
                    dirContentsCheck=$(ls -l "$currentdir/$object" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)
                      if [[ -d "$currentdir/$object" ]]
                      then
                        # currentdir=$currentdir
                           recursiveActionInDirectory $currentdir/$object
                           # currentdir=
                           backToRootDir $currentdir
                      # elif [[ -d "$currentdir/$object" && $dirContentsCheck -eq 0 ]]
                      # then
                      #   # echo "$currentdir/$object "
                      #     echo "EMPTY!!!!!"
                      #    backToRootDir $currentdir/$object
                      #   # echo "remove $currentdir/$object? "
                      fi
                  else
                      echo "$currentdir/$object not examined"
                  fi
              fi
          done

}

#===========================================================================================================================================

# FOR FILES
if [[ -f "$presentItem" ]];
then
    removeFiles $presentItem
fi

#FOR DIRECTORIES
if [[ -d "$1" ]];
then
  # currentdir="$1"
  read -p "examine files in directory $1? " response

     if [[ $response == Y* ]] || [[ $response == y* ]]
     then
    #first do a check to know if file is empty or not
        recursiveActionInDirectory $1
        # backToRootDir $1/$object
        backToRootDir $1
     else
         echo "$1 not examined"
     fi
fi
