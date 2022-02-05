#!/bin/zsh

## ZSH script (because apparently bash sucks?) intended for simplifying and 
## learning particular fuzzing and web scanning tools
## Ferox buster (Potentially adding Fuff ¯\_(ツ)_/¯ )
## Program created by @Topazstix

# Copyright (c) 2021 Topazstix <topazstix@protonmail.com>

#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

scriptVersion="rc.1.0"


######################
# Print tool disclaimer
######################

warning () {
    echo '##################################################################'
    echo '#      THIS PROGRAM WILL NOT BE USED FOR ILLEGAL PURPOSES.       #'
    echo '#  The user will assume FULL responsibility for this tools use,  #'
    echo '# The developers hold ZERO responsibility for the misuse of this #'
    echo '# Please make sure that any site you are scanning, you have full #'
    echo '#                 WRITTEN CONSENT to do so.                      #'
    echo '##################################################################'
}



######################
# User Agents
######################
## $1 iPhone
## $2 Android
## $3 Windows 10
## $4 Linux/Ubuntu
## $5 Mac OS X
## https://developers.whatismybrowser.com/useragents/explore/
userAgents=(
    "Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
    "Mozilla/5.0 (Linux; Android 10; Android SDK built for x86) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
    "Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:24.0) Gecko/20100101 Firefox/24.0"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15"
)

## Most Common Extentions
## https://github.com/danielmiessler/SecLists/blob/master/Fuzzing/extensions-most-common.fuzz.txt
fileExtentions=(
    "asp"
    "aspx"
    "php"
    "php3"
    "php4"
    "php5"
    "txt"
    "shtm"
    "shtml"
    "phtm"
    "phtml"
    "jhtml"
    "pl"
    "jsp"
    "cfm"
    "cfml"
    "py"
    "rb"
    "cfg"
    "zip"
    "pdf"
    "gz"
    "tar"
    "tar.gz"
    "tgz"
    "doc"
    "docx"
    "xls"
    "xlsx"
    "conf"
)

## .........


#####################
# Begin Flags Phase
#####################

case $1 in
	# --help) displayHelp; exit 0;;
	--version) printf "Feroffuf Script ver. "$scriptVersion ; exit 0;;
esac


#####################
# Menus Section
#####################


## General Interactive Menu
interactiveMenu() {
    warning
    printf "\n\n"
    while :; do
        printf "Welcome to the feroffuf tool. Select an option to start: \n"
        printf "1. Scanning\n"
        # printf "2. FUZZ\n" ##NOT IMPLEMENTED, yet
        # printf "3. Combo\n" ##NOT IMPLEMENTED, yet
        printf "4. Exit Program\n"
        printf "\n> "
        read menu
        [[ $menu =~ ^[14]+$ ]] || { clear; printf "***Incorrect syntax. Enter number 1 or 4***\n\n"; continue; }
        if [ $menu -eq "1" ]; then
            scanningMenu
            break
        # elif [ $menu -eq "2" ]; then
        #     echo "Menu two is for Ffufing."
        #     echo "Not to be confused with FLUFFING"
        #     continue
        # elif [ $menu -eq "3" ]; then
        #     echo "This third menu is for shit to work together, or utilize ferox default fuzzing tools"
        #     printf "runstuff\n"
        #     continue
        elif [ $menu -eq "4" ]; then
            printf "Program exiting\nARE YOU SURE?[Y|N] "
            read confirm 
            if [ $confirm = "Y" ] || [ $confirm = "y" ];then
                break
            else 
                clear;continue
            fi
        fi
    done
}

## Menu for setting the feroxbuster arguments 
## Arguments will be passed and executed in the executionFunct
scanningMenu() {
    clear
    echo "################################"
    echo "# So you want to scan a thing. #"
    echo "# we're going to need a little #"
    echo "# more information to do so :) #"
    echo "#         FEROX BUSTER         #"
    echo "################################"
    ## Set verbosity // Optional
    while :; do
        printf "\n************\nVerbosity: '-v[v]'\n\n"
        printf "Would you like the output to be verbose?\n*This will display more information about the tasks as they run\n\n[Y]es/[N]o\n> "
        read input 
        [[ $input =~ ^["YN"]+$ ]] || { printf "\n\n***Incorrect syntax. Enter [Y]es or [N]o\n"; continue; }
        if [ $input = "Y" ];then
            printf "Level of Verbosity: [1/2]\n> "
            read input 
            if [ $input -eq 1 ];then
                verbosity="-v"
                break
            elif [ $input -eq 2 ];then
                verbosity="-vv"
                break
            fi
        elif [ $input = "N" ];then
            break
        fi
    done
    ## Set recursion // Optional
    while :; do
        printf "\n************\nRecursion Depth: '-d [0-9]'\n\n"
        printf "Set the depth of directories to search for\nIf a directory is found, it will scan thru this new directory path x times until stopping\n\nWould you like to set the depth? [Y]es/[N]o\n(No will run default depth)\n> "
        read input
        [[ $input =~ ^["YN"]+$ ]] || { printf "\n\n***Incorrect syntax. Enter [Y]es or [N]o\n"; continue; }
        if [ $input = "Y" ];then
            printf "Enter depth: [0-9]\n> "
            read input
            [[ $input =~ ^[0-9]+$ ]] || { printf "\n\n***Incorrect syntax. Enter number 0-9***\n"; continue; }
            if [ $input ]; then
                depth="-d $input" 
                break
            fi
        elif [ $input = "N" ];then
            break
        fi
    done
    ## Set outfile // Optional
    while :; do
        printf "\n************\nOutput file: '-o /path/to/file'\n\n"
        printf "This will output results to a file for future viewing.\nThis program will create a directory 'scans' in the present directory\nand place the output file there.\n\nWould you like to specify an output file? [Y]es/[N]o\n> "
        read input
        [[ $input =~ ^["YN"]+$ ]] || { printf "\n\n***Incorrect syntax. Enter [Y]es or [N]o\n"; continue; }
        if [ $input = "Y" ];then
            printf "\nEnter output file name:\n> "
            read input 
            if [ -d "scans" ];then
                outfile="-o scans/"$input
                break
            elif [ ! -d "scans" ];then
                mkdir scans
                outfile="-o scans/"$input
                break
            fi
        elif [ $input = "N" ];then
            break
        fi
    done
    ## Set threads // Optional  [default is 50, I like 420]
    while :; do
        printf "\n************\nThreads to use: '-t [###]'\n\n"
        printf "This will specify the number of threads for the program to use.\n50 is the default, I typically use 420\n\nWould you like to specify threads for the program to use? [Y]es/[N]o\n> "
        read input
        [[ $input =~ ^["YN"]+$ ]] || { printf "\n\n***Incorrect syntax. Enter [Y]es or [N]o\n"; continue; }
        if [ $input = "Y" ];then
            printf "\nEnter the total threads to use:\n> "
            read input
            if [ $input -ne 0 ];then
                threads="-t $input"
                break
            elif [ $input -le 0 ];then
                printf "\n\n***Enter a number above zero\n" 
                continue
            fi
        elif [ $input = "N" ];then
            break  
        fi
    done
    ## Set useragent // Optional
    while :; do
        printf "\n************\nUser Agent: '-a \"AGENT\"'\n\n"
        printf "This flag will tell the program to act like a specific web browser rather than\nthe default 'feroxbuster' useragent\nAgents are 1)iphone, 2)android, 3)windows, 4)linux, 5)mac\n\nSpecify a user agent? [Y]es/[N]o\n> "
        read input
        [[ $input =~ ^["YN"]+$ ]] || { printf "\n\n***Incorrect syntax. Enter [Y]es or [N]o\n"; continue; }
        if [ $input = "Y" ];then
            for i in {1..5};do
                printf "$i) $userAgents[$i]\n"
            done
            printf "\nEnter User Agent number\n> "
            read input 
            [[ $input =~ ^[1-5]+$ ]] || { printf "\n\n***Incorrect syntax. Select a number 1-5\n"; continue; }
            case $input in
                $input) agent="-a \"$userAgents[$input]\""
            esac
            break
        elif [ $input = "N" ];then
            break
        fi
    done
    ## Set URL // Mandatory
    while :; do 
        printf "\n************\nSpecify a URL to target:\n> "
        read input
        [[ $input =~ "^http://|https://|www\." ]] || { printf "\n***Please specify a website address to scan.\nie; http(s)://www.net.xyz\n\n"; continue; }
        url="-u $input"
        break

    done
    ## Set wordlist // Mandatory
    ## If you dont have SecLists, I recommend grabbing it
    ## https://github.com/danielmiessler/SecLists
    while :; do 
        printf "\n************\nSpecify a wordlist to use: [give the FULL path to the wordlist]\nie; /path/to/wordlist\n> "
        read input
        if [ -e $input ];then
            wordlist="-w $input"
            break
        else
            printf "\n\n***The file given does not exist. Check the directory and try again.\n"
            continue
        fi
    done
    execution
}

## Execution Function
## This section is intended to print the correct syntax for ferox buster
## per the users requested parameters. The user should then copy/paste
## the results and run the scan on their own in a terminal

execution () {
    clear
    echo "################################"
    echo "#  Alright! So we have all the #"
    echo "#  information we need, next   #"
    echo "#  you will copy this command  #"
    echo "#  into a terminal and run it  #"
    echo "#         FEROX BUSTER         #"
    echo "################################"
    printf "\n\nPlease take the following command and paste it into a terminal and run it:\n\n"
    printf "feroxbuster $verbosity $depth $threads $outfile $url $agent $wordlist"
}

## ......

## MAIN FUNCTION

mainFunct () {
    interactiveMenu
}

mainFunct