#!/bin/bash
# this is a test project

currentWD=$(pwd)
presentItem=$1
#item=$presentItem
itemPath=$currentWD/$presentItem
trashPath="$HOME/.Trash_Saferm"



#FUNCTIONS
move(){
  mv "$1" $trashPath
}
removeFunction(){
  # check if item is a file
  # currentdir=$(dirname $currentdir)
    # currentdir=$currentdir/$object
  # if [[ -f "$1" ]];
  # then
      #ask for permission to remove file
          read -p "remove $1? " response
          if [[ $response == Y* ]] || [[ $response == y* ]]
          then
              #remove file
                  # mv "$1" $trashPath
                  echo "$1 removed"
          #      # echo "$1 has been removed"
          else
              #file isn't remove
                  echo "$1 not removed"
          fi
   # fi
}

 backToRootDir(){
  # currentdir=$(dirname $currentdir)
  dirContentsCheck=$(ls -l "$currentdir" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)
  read -p "remove $currentdir? " response
    if [[ $response == Y* || $response == y* ]] && [[ $dirContentsCheck -eq 0 || $dirContentsCheck -gt 0 ]]
    then
      # remove
      move $currentdir
      echo "$currentdir removed"
    else
        echo "$currentdir not removed"
    fi

    }


recursiveActionInDirectory(){

     currentdir="$1"
     totalItems=$(ls -l "$currentdir" | sort -k1,1  | awk -F " " '{print $NF}' | sed -e '$ d')

    # dirContentsCheck=$(ls -l "$1" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)

          for object in $totalItems
          do

              # echo "looping again"
              if [[ -f "$currentdir/$object" ]]
              then
                # echo "$object is a file"
                  removeFunction $currentdir/$object
              else
                    dirContentsCheck=$(ls -l "$currentdir/$object" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)
                    doYouWantToExaminePrompt $currentdir/$object
                    if [[ $response == Y* || $response == y* ]]
                    then
                       if [[ $dirContentsCheck -gt 0 ]]
                       then
                        recursiveActionInDirectory $currentdir/$object
                      else
                        removeFunction $currentdir/$object
                      fi

                    else
                        echo "$currentdir/$object not examined"
                    fi

              fi
          done
           backToRootDir $currentdir/$object

           currentdir=$(dirname $currentdir)

}

doYouWantToExaminePrompt(){
  read -p "examine files in directory $1? " response
}

#===========================================================================================================================================

# FOR FILES
if [[ -f "$presentItem" ]];
then
    removeFunction $presentItem
fi

#FOR DIRECTORIES
if [[ -d "$1" ]];
then
      doYouWantToExaminePrompt $1
     if [[ $response == Y* ]] || [[ $response == y* ]]
     then
        recursiveActionInDirectory $1
     else
         echo "$1 not examined"
     fi
fi
