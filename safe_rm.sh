#!/bin/bash
# this is a test project

currentWD=$(pwd)
presentItem=$1
#item=$presentItem
itemPath=$currentWD/$presentItem
trashPath="$HOME/.Trash_Saferm"



#FUNCTIONS


removeFunction(){

          read -p "remove $1? " response
          if [[ $response == Y* ]] || [[ $response == y* ]]
          then
                #remove file
                mv $1 $trashPath
                echo "$1 removed"
          else
                echo "$1 not removed"
          fi
   # fi
}

 backToRootDir(){

          dirContentsCheck=$(ls -l "$currentdir" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)

          read -p "remove $currentdir? " response
            if [[ $response == Y* || $response == y* ]] && [[ $dirContentsCheck -eq 0 ]] #|| $dirContentsCheck -gt 0 ]]
            then
                # move directory to trash
                mv $currentdir $trashPath
                echo "$currentdir removed"
            elif [[ $response == Y* || $response == y* ]] && [[ $dirContentsCheck -gt 0 ]]
            then
                echo "Safe_rm: $currentdir: Directory not empty"
            else
                echo "$currentdir not removed"
            fi
  }

recursiveActionInDirectory(){

     currentdir="$1"
     totalItems=$(ls -l "$currentdir" | sort -k1,1  | awk -F " " '{print $NF}' | sed -e '$ d')


          for object in $totalItems
          do
            #for files in directory
              if [[ -f "$currentdir/$object" ]]
              then
                  #if file in directory or subdirectory is found then do this
                  removeFunction $currentdir/$object
              else
                  #for sub-directories found in parent directory
                    dirContentsCheck=$(ls -l "$currentdir/$object" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)
                    #prompt user to examine directory
                    doYouWantToExaminePrompt $currentdir/$object
                    if [[ $response == Y* || $response == y* ]]
                    then
                      #if user responds yes then check if directory has contents
                       if [[ $dirContentsCheck -gt 0 ]]
                       then
                         #if directory has contents then go into it
                        recursiveActionInDirectory $currentdir/$object
                      else
                        #else if it doesn't have contents then perform remove function
                        removeFunction $currentdir/$object
                      fi
                      #if user responds no to examining directory then do this
                    else
                        echo "$currentdir/$object not examined"
                    fi
              fi
          done
          #function for recursively looping out f directories
           backToRootDir $currentdir

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
    #if arguement passed is a directory then ask if user wants to examine directory
      doYouWantToExaminePrompt $1
     if [[ $response == Y* ]] || [[ $response == y* ]]
     then
       #if user responds yes to examining directory then perform recursive function
        recursiveActionInDirectory $1
     else
       #else if user responds no to examining directory then do this
         echo "$1 not examined"
     fi
fi
