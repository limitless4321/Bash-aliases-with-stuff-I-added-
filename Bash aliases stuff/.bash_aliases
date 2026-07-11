# .bash_aliases
# color var to green if not already
if [ -z "$TERM_COLOR" ]; then
    export TERM_COLOR="\e[0;32m"
fi

unalias ls 2>/dev/null
#alias ls='ls --color=auto && printf "$TERM_COLOR"'

ls() {
    command ls --color=auto "$@"
    printf "$TERM_COLOR"
}

# ls color anti change

#grntm() {
#     printf "\e]11;#4AF626\a\e[0;32m"
#     printf "\e]10;#0B2410\a\e[0;32m"
#     clear
#}
grntm() {
    export TERM_COLOR="\e[0;32m"
    printf "\e]11;#4AF626\a"
    printf "$TERM_COLOR"
    clear
}
mroms() {
    grntm
    if mountpoint -q /roms; then
        echo "Unmounting /roms..."
        if sudo umount /roms 2>/dev/null; then
            #printf "\e[1;32mSuccessfully unmounted.\e[0;32m\n"
            #=================================================
            export TERM_COLOR="\e[0;32m"
            printf "${TERM_COLOR}Successfully unmounted.\n"
            (speaker-test -t sine -f 700 -l 1 > /dev/null 2>&1 & PID=$!; sleep 0.3; kill $PID) 2>/dev/null
        else
            #printf "\e[1;31mFailed to unmount. Device might be busy.\e[0;32m\n"
            printf "\e[1;31mFailed to unmount. Device might be busy.$TERM_COLOR\n"
        fi
    else
        echo "Mounting..."
        if sudo mount /dev/mmcblk1p3 /roms 2>/dev/null; then
            printf "\e[1;32mSuccess!\e[0;31m\n"
            (speaker-test -t sine -f 1000 -l 1 > /dev/null 2>&1 & PID=$!; sleep 0.1; kill $PID) 2>/dev/null
            
            # updt mem var to red
            export TERM_COLOR="\e[1;31m\n"
            # apply immediately
            printf "$TERM_COLOR"
            # ^comment these when dont wanna use
        else
            #printf "\e[1;31mFailed to mount.\e[0;32m\n"
            printf "\e[1;31mFailed to mount.$TERM_COLOR\n"
            (speaker-test -t sine -f 500 -l 1 > /dev/null 2>&1 & PID=$!; sleep 0.2; kill $PID) 2>/dev/null
            (speaker-test -t sine -f 500 -l 1 > /dev/null 2>&1 & PID=$!; sleep 0.2; kill $PID) 2>/dev/null
        fi
    fi
}
bt() {
    CAP=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null)
    if [ -z "$CAP" ]; then
        printf "\e[1;31mError: No battery found.\e[0;32m\n"
        return 1
    fi
    if [ "$CAP" -le 30 ]; then
        #printf "\e[1;31mBattery is low CHARGE NOW(${CAP}%%)\e[0;32m\n"
        printf "\e[1;31mBattery is low CHARGE NOW(${CAP}%%)$TERM_COLOR\n"
        (speaker-test -t sine -f 500 -l 1 > /dev/null 2>&1 & PID=$!; sleep 0.2; kill $PID) 2>/dev/null
        (speaker-test -t sine -f 500 -l 1 > /dev/null 2>&1 & PID=$!; sleep 0.2; kill $PID) 2>/dev/null
    else
        #printf "\e[0;32mBattery is okay(${CAP}%%)\e[0;32m\n"
        printf "\e[0;32mBattery is okay(${CAP}%%)$TERM_COLOR\n"
        (speaker-test -t sine -f 800 -l 1 > /dev/null 2>&1 & PID=$!; sleep 0.2; kill $PID) 2>/dev/null
    fi
}

mche() {
    if mountpoint -q /cheese; then
        printf "\e[1;31mCheese is already mounted, please run 'uche'.$TERM_COLOR\n"
    else
        if sudo mount -o loop /cheese.img /cheese 2>/dev/null; then
            printf "\e[0;32mCheese is now mounted! To unmount, run 'uche'$TERM_COLOR\n"
        else
            printf "\e[1;31mCheese could not be mounted.$TERM_COLOR\n"
        fi
    fi
}

uche() {
    if mountpoint -q /cheese; then
        if sudo umount /cheese 2>/dev/null; then
            printf "\e[0;32mCheese is now unmounted!$TERM_COLOR\n"
        else
            printf "\e[1;31mCheese could not be unmounted.$TERM_COLOR\n"
        fi
    else
        printf "\e[1;31mCheese is not mounted, please run 'mche'.$TERM_COLOR\n"
    fi
}

nba() {
     nano ~/.bash_aliases
}
srba() {
      source ~/.bashrc
}
lscmd() {
       (speaker-test -t sine -f 600 -l 1 > /dev/null 2>&1 & PID=$!; sleep 0.2; kill $PID) 2>/dev/null
       (speaker-test -t sine -f 800 -l 1 > /dev/null 2>&1 & PID=$!; sleep 0.1; kill $PID) 2>/dev/null
       printf "\e[0;32mlscmd: lists custom commands.$TERM_COLOR\n\n"
       printf "\e[0;32mmroms: mounts or unmounts the EASYROMS partition.$TERM_COLOR\n\n"
       printf "\e[0;32mbt: outputs battery percentage and whether to charge or not.$TERM_COLOR\n\n"
       printf "\e[0;32mmche: mounts the cheese partition.$TERM_COLOR\n\n"
       printf "\e[0;32muche: unmounts the cheese partition.$TERM_COLOR\n\n"
       printf "\e[0;32mnba: Executes 'nano ~/.bash_aliases'.$TERM_COLOR\n\n"
       printf "\e[0;32msrba: Executes 'source .bashrc'.$TERM_COLOR\n\n"
       printf "\e[0;32mkey: Changes keyboard layout between US and GB.$TERM_COLOR\n"
}
key() {
    CURRENT_LAYOUT=$(cat /keyboardmapthing/us-gb.txt)
    
    if [ "$CURRENT_LAYOUT" = "us" ]; then
        sudo loadkeys gb
        echo "gb" > /keyboardmapthing/us-gb.txt
        printf "${TERM_COLOR}Switched layout: US -> UK (GB)\n"
    else
        sudo loadkeys us
        echo "us" > /keyboardmapthing/us-gb.txt
        printf "${TERM_COLOR}Switched layout: UK (GB) -> US\n"
    fi
}
