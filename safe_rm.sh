#!/bin/bash
# this is a test project

currentWD=$(pwd)
presentItem=$1
itemPath=$currentWD/$presentItem
trashPath="$HOME/.Trash_Saferm"
vFlag=0
rFlag=0
dFlag=0
RFlag=0

# FUNCTIONS

createTrashIfNotAlreadyExisting(){
        if [[ ! -d "$trashPath" ]]
        then
            mkdir $trashPath
            echo "$trashPath created"
        fi
}

removeFunction(){

          itemPath=$currentWD/$1
          read -p "remove $1? " response
          #if user responds yes then do this
          if [[ $response == Y* ]] || [[ $response == y* ]]
          then
                #move item to trash
                mv $itemPath $trashPath
                echo "$itemPath" >> $trashPath/.log

          fi

}

backToRootDir(){

          dirContentsCheck=$(ls -l "$1" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)

          read -p "remove $1? " response
            #if user responds yes and the directory is empty then do this
            if [[ $response == Y* || $response == y* ]] && [[ $dirContentsCheck -eq 0 ]] #|| $dirContentsCheck -gt 0 ]]
            then
                # move directory to trash
                mv $itemPath $trashPath
                echo "$itemPath" >> $trashPath/.log
            #if user responds yes and directory is has contents then give error message
            elif [[ $response == Y* || $response == y* ]] && [[ $dirContentsCheck -gt 0 ]]
            then
                echo "Safe_rm: $1: Directory not empty"
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
                    # else
                    #     echo "$currentdir/$object not examined"
                    fi
               fi
          done
          #function for recursively looping out of directories
           backToRootDir $currentdir

           currentdir=$(dirname $currentdir)

}

doYouWantToExaminePrompt(){
  read -p "examine files in directory $1? " response
}

recoverActionForObjectsWithMultiplePaths(){
  numberOfPathOccurence=$(cat $trashPath/.log | grep $item | wc -l | xargs)
  pathsOfItemToBeRecovered=$(cat $trashPath/.log | grep $item)
  tes=$(dirname $pathsOfItemToBeRecovered)
  read -p "Do you want to recover $item? " response
    if [[ $response == Y* || $response == y* ]]
    then
    #if response is yes or anything starting with a Y or y then do this
        mv $trash $tes
        echo "$item recovered"
    else
    #if response is anything other than yes then do this
        echo "$item not recovered"
    fi
}

directories(){
  if [[ -d "$1" ]];
  then
      #if arguement passed is a directory then ask if user wants to examine directory
        doYouWantToExaminePrompt $1
       if [[ $response == Y* ]] || [[ $response == y* ]]
       then
         #if user responds yes to examining directory then perform recursive function
          recursiveActionInDirectory $1
       fi
  fi
}

files(){
  #if item is a file
  if [[ -f "$presentItem" ]]
  then
      #do this for files
      removeFunction $presentItem
  #if item is a directory
  elif [[ -d "$presentItem" ]]
  then
      #for directory do this
      echo "Safe_rm: $presentItem: is a directory"
  else
      #for neither file or directory then do this
      echo "Safe_rm: $presentItem: No such file or directory"
  fi
  }

createTrashIfNotAlreadyExisting



#FLAGS=============FLAGS================FLAGS===============FLAGS=================FLAGS================FLAGS===============FLAGS==================

  while getopts "v:r:d:R:" opt; do

    case $opt in

      v) #for verbose action
          vFlag=1
          vArg=$OPTARG
          itemPath=$currentWD/$vArg
          #if -v option is used and argument passed to it is a file then do this
          if [[ $vFlag -eq 1 && -f "$vArg" ]];
          then
            #move argument passed to trash and let user know it has been removed
             mv $itemPath $trashPath
            echo "removed $vArg"
          #if -v option is used and argument passed to it is a directory then do this
          elif [[ $vFlag -eq 1 && -d "$vArg" ]];
          then
            echo "Safe_rm: $vArg: is a directory"
          #if file or directory doesn't exist then do this
          else
            echo "Safe_rm: $vArg: No such file or Directory"
          fi

          ;;

      r) #to recursively delete contents of a directory
        rFlag=1
        rArg=$OPTARG
        # if -r is used on a directory then do this
        if [[ $rFlag -eq 1 && -d "$rArg" ]];
        then
            directories $rArg
        #if -r is used on a directory then do this
        elif [[ $rFlag -eq 1 && -f "$rArg" ]];
        then
            removeFunction $rArg
            # echo "Safe_rm: $rArg: is not directory"
        #if file or directory doesn't exist then do this
        else
            echo "Safe_rm: $rArg: No such file or Directory"
        fi
        ;;

      d) #for removing files or empty directories
        dFlag=1
        dArg=$OPTARG
        dirContentsCheck=$(ls -l "$dArg" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)
            #if -d option is used, the argument passed to it is a directory and the directory is empty then do this
            if [[ $dFlag -eq 1 && -d "$dArg" && $dirContentsCheck -eq 0 ]];
            then
                removeFunction $dArg
            #if -d option is used, the argument passed to it is a directory and the directory is not empty then do this
            elif [[ $dFlag -eq 1 && -d "$dArg" && dirContentsCheck -gt 0 ]];
            then
                  echo "Safe_rm: $dArg: Directory not empty"
            fi
            if [[ $dFlag -eq 1 && -f "$dArg" ]]
            then
                #if argument passed is not a directory (i.e a file) then do this
                removeFunction $dArg
             fi
        ;;

        R) #for recovering deleted items/objects
          RFlag=1
          RArg=$OPTARG
          itemPath=$currentWD/$RArg
          objectpath=$(dirname $itemPath)
          trash=$trashPath/$RArg
          numberOfPathOccurence=$(cat $trashPath/.log | grep $RArg | wc -l | xargs)
          pathsOfItemToBeRecovered=$(cat $trashPath/.log | grep $RArg)
          tes=$(dirname $pathsOfItemToBeRecovered)


          # if -R (recover) is used then do this
          if [[ $RFlag -eq 1 ]]
          then
              #if more than one path of a particular item exists
              if [[ $numberOfPathOccurence -gt 1 ]]
              then
                  #for every item with same name as argument do
                  for item in $pathsOfItemToBeRecovered
                  do
                    recoverActionForObjectsWithMultiplePaths
                  done
              elif [[ $numberOfPathOccurence -eq 1 ]]
              then
                read -p "Do you want to recover $RArg? " response
                  if [[ $response == Y* || $response == y* ]]
                  then
                  #if response is yes or anything starting with a Y or y then do this
                      mv $trash $tes
                      echo "$RArg recovered"
                  else
                  #if response is anything other than yes then do this
                      echo "$RArg not recovered"
                  fi
              fi
          fi
          ;;


      ?) #for unknown option/Flag
        echo "Safe_rm: error invalid option: -$OPTARG"
        ;;

    esac
  done
  shift $((OPTIND - 1))




#===================================================================================================================================================

  #when flags are not used do this
  if [[ $vFlag -eq 0 ]] && [[ $rFlag -eq 0 ]] && [[ $dFlag -eq 0 ]] && [[ $RFlag -eq 0 ]]
  then
      files
  fi
