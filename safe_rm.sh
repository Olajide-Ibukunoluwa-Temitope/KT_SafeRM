#!/bin/bash
# this is a test project

currentWD=$(pwd)
presentItem=$1
#item=$presentItem
itemPath=$currentWD/$presentItem
trashPath="$HOME/.Trash_Saferm"
vFlag=0
rFlag=0
dFlag=0
# vArg=""
# rArg=""
# dArg=""





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

}

backToRootDir(){

          dirContentsCheck=$(ls -l "$1" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)

          read -p "remove $1? " response
            if [[ $response == Y* || $response == y* ]] && [[ $dirContentsCheck -eq 0 ]] #|| $dirContentsCheck -gt 0 ]]
            then
                # move directory to trash
                mv $1 $trashPath
                echo "$1 removed"
            elif [[ $response == Y* || $response == y* ]] && [[ $dirContentsCheck -gt 0 ]]
            then
                echo "Safe_rm: $1: Directory not empty"
            else
                echo "$1 not removed"
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

directories(){
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
}

files(){
  if [[ -f "$presentItem" ]];
  then
      removeFunction $presentItem
  fi
}


 files $1

# directories $1

while getopts ":v:r:d:" opt; do

  # echo "${OPTARG:0:1} $opt $OPTARG"
  case $opt in

    v) #verbose
        vFlag=1
        vArg=$OPTARG

        if [[ $vFlag -eq 1 && -f "$vArg" ]];
        then
           mv $vArg $trashPath
          echo "$vArg removed"
        elif [[ $vFlag -eq 1 && -d "$vArg" ]];
        then
          echo "Safe_rm: $vArg: is a directory"
        fi

      ;;

    r) #recursive
      rFlag=1
      rArg=$OPTARG
      if [[ $rFlag -eq 1 && -d "$rArg" ]];
      then
          directories $rArg
      elif [[ $rFlag -eq 1 && -f "$rArg" ]];
      then
          echo "Safe_rm: $rArg: not directory"
      fi
      ;;

    d) #remove directories
      dFlag=1
      dArg=$OPTARG
      dirContentsCheck=$(ls -l "$dArg" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)
      if [[ $dFlag -eq 1 && -d "$dArg" && dirContentsCheck -eq 0 ]];
      then
          # echo "removed $dArg"
          mv $dArg $trashPath
      #     backToRootDir $dArg
      elif [[ $dFlag -eq 1 && -d "$dArg" && dirContentsCheck -gt 0 ]];
      then
            echo "Safe_rm: $dArg: Directory not empty"
      else
          mv $dArg $trashPath
          # echo "removed $dArg"
      #     removeFunction $dArg
       fi
      ;;

    ?) #unknown option/dFlag
      echo "Safe_rm: error invalid option: -$OPTARG"
      ;;

  esac
done
shift $((OPTIND - 1))
# shift `expr $OPTIND - 1`
# echo "$1"
