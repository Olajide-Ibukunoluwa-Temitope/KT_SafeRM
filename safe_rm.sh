#!/bin/bash
# this is a test project

currentWD=$(pwd)
presentItem=$1
item=$presentItem
Itempath=$currentWD/$presentItem
Trashpath="/Users/kaitechstudent2/.Trash_Saferm"
TotalItems=$(ls -l "$Itempath" | sort -k1,1  | awk -F " " '{print $NF}' | sed -e '$ d')


#FUNCTIONS	
enterDirectory(){
	for item in $TotalItems;
	do
        until [[ ! -f "$@" && ! -d "@" ]];
        do
            #For files
		if [[ -f "$item" ]];
            	then
                    read -p "Do you want to remove $item? " response
                    if [[ $response == Y* ]] || [[ $response == y* ]]
                    then
                            mv "$Itempath" $Trashpath
                            echo "$presentItem has been removed"
                    elif [[ $response == N* ]] || [[ $response == n* ]]
                    then
                            echo "$presentItem not removed"
                    fi
            fi
            #for Directory
            if [[ -d "$item" ]];
            then
                read -p "Do you want to examine $presentItem? " response
		if [[ $response == Y* ]] || [[ $respnose == y* ]]
		then
			EnterDirectory "$Itempath"
		else
			echo "Directory not examined"
		fi
            fi
        done


	done
}

removeFiles(){
        if [[ -f "$item" ]];
                then
                        read -p "Do you want to remove $presentItem ? " response
                        if [[ $response == Y* ]] || [[ $response == y* ]]
                        then
                                mv "$Itempath" $Trashpath
                                echo "$presentItem has been removed"
                        elif [[ $response == N* ]] || [[ $response == n* ]]
                        then
                                echo "$presentItem not removed"
                        fi
         fi
}


#For Files
if [[ -f "$1" ]];
then
	removeFiles
fi

#For Directories
#if [[ -d "$1" ]];
#then
#	read -p "Do you want to examine $presentItem? " reply
#	if [[ $reply == Y* ]] || [[ $reply == y* ]]
#	then
#		enterDirectory $1
#	elif [[ $reply == N* ]] || [[ $reply == n* ]]
#
#        then
#                echo "$presentItem not removed"
#	fi
#fi
enterDirectory $1
