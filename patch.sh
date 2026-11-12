#!/usr/bin/env bash

script_title="Beeper.AppImage trayIcon patcher v0.1"
script_description="
This script replaces the systray icons of Beeper (Linux).
It unpacks Beeper.AppImage, then unpacks the underlying ASAR archive,
then finds the trayIcon/trayUnreadIcon files and replaces them, then
repacks the ASAR archive and finally outputs a new AppImage.

DEPENDENCIES
- appimagetool.AppImage (from github.com/AppImage/appimagetool)
- asar                  (from your package manager of choice)

REQUIRED FILES ALONGSIDE THIS SCRIPT
- Beeper.AppImage       (tested with v4.3.284)
- appimagetool.AppImage (tested with build 370)
- trayIcon.png          (any new icon, suggested size 32x32 pixels)
- trayUnreadIcon.png    (any new icon, suggested size 32x32 pixels)

THE SCRIPT CHECKS EVERYTHING
- If everything is ok it's all automatic
- If not you'll be told what's missing"

# Funcs #######################################################################
# #############################################################################

printred() { echo -e "\e[1;31m$1\e[0m"; }
printgreen() { echo -e "\e[1;32m$1\e[0m"; }
printyellow() { echo -e "\e[1;33m$1\e[0m"; }
printblue() { echo -e "\e[1;34m$1\e[0m"; }
print_section() { echo -e "\n\e[1;7m $1 \e[0m🭬"; }

ask_yn() {
    echo -en "$1 (y/n) "
    local input
    while [[ $input != "y" && $input != "n" ]]; do
        read -rsn1 input
    done
    [[ $input == "y" ]] || return 1
}

testfiles() {
    local abort=0
    for file in "$@"; do
        echo -n " ├─ $file "
        if [[ -a "$file" ]];
            then printgreen OK
            else printred KO; abort=1
        fi
    done
    return $abort
}

find_and_overwrite() {
    local error=0
    shopt -q globstar; local had_globstar=$?
    shopt -q nullglob; local had_nullglob=$?
    shopt -s globstar nullglob
    #
    for file in **/"$1"*.png; do
        echo -n " ├─ $file "
        if cp -f "$2" "$file";
            then printgreen OK
            else printred KO; error=1
        fi
    done
    #
    (( had_globstar )) && shopt -u globstar
    (( had_nullglob )) && shopt -u nullglob
    return $error
}

main() {
    # Print title and description
    print_section "$script_title"
    echo -e "$script_description\n"
    #
    # When called with -h or --help return here
    if [[ "$1" == *-h* ]]; then return 0; fi
    #
    # Ask user to start or abort
    printblue "Working directory is $PWD"
    if ask_yn "Are you ready to patch?";
        then printgreen "OK --> Continuing"
        else printyellow Aborted; return 0
    fi
    #
    print_section "Checking required files:"
    echo " ${PWD##*/}/"
    if testfiles "Beeper.AppImage" "appimagetool.AppImage" "trayIcon.png" \
      "trayUnreadIcon.png";
        then printgreen "OK, required files available"
        else printyellow Aborted; return 0
    fi
    #
    print_section "Checking required apps:"
    echo " - asar "
    if asar --version >/dev/null 2>&1;
        then printgreen "OK, required apps available"
        else printred KO; printyellow Aborted; return 0
    fi
    #
    print_section "Unpacking AppImg:"
    if ./Beeper.AppImage --appimage-extract;
        then printgreen "OK --> Unpacked in bpr/squashfs-root/"
        else printred Error; printyellow Aborted; return 1
    fi
    #
    print_section "Unpacking ASAR archive:"
    if asar extract squashfs-root/resources/app.asar app.asar.extracted;
        then printgreen "OK --> Unpacked in bpr/app.asar.extracted/"
        else printred Error; printyellow Aborted; return 1
    fi
    #
    print_section "Replacing icons:"
    echo " ${PWD##*/}/app.asar.extracted/"
    cd "app.asar.extracted" || :
    local beeper_patcher_fails=0
    if find_and_overwrite "trayIcon" "../trayIcon.png";
        then :; else ((beeper_patcher_fails+=1))
    fi
    if find_and_overwrite "trayUnreadIcon" "../trayUnreadIcon.png";
        then :; else ((beeper_patcher_fails+=2))
    fi
    if ((beeper_patcher_fails!=0)); then
        printyellow "Some icons were not overwritten"
        if ask_yn "Proceed with patching anyway?";
            then printgreen OK
            else printyellow NO; printyellow Aborted; return 1
        fi
    fi
    cd ..
    #
    print_section "Repacking ASAR archive:"
    if asar pack app.asar.extracted squashfs-root/resources/app.asar --unpack \
    '**/{.**,**}/**/*.node' --unpack-dir '**/node_modules/{sharp,@img}';
        then printgreen "OK --> Written bpr/squashfs-root/resources/app.asar/"
        else printred Error; printyellow Aborted; return 1
    fi
    #
    print_section "Repacking AppImage:"
    if ./appimagetool.AppImage ./squashfs-root;
        then printgreen "OK --> Written bpr/Beeper-x86_64.AppImage"
        else printred Error; printyellow Aborted; return 1
    fi
    #
    print_section "Cleaning up:"
    beeper_patcher_fails=0
    for dir in app.asar.extracted squashfs-root; do
        echo -n "Deleting $dir "
        if rm -rf $dir;
            then printgreen OK
            else printred KO; ((beeper_patcher_fails+=1))
        fi
    done
    if ((beeper_patcher_fails!=0)); then
        printyellow "Cleanup failed"
    fi
    #
    printgreen "ALL DONE, PATCHING SUCCESFUL"
}

# Main ########################################################################
# #############################################################################

# is script already in an interactive shell?
# -> if not relaunch with xdg-terminal-exec
#    -> if error relaunch with konsole
[[ -t 0 || -t 1 || -t 2 ]] && main $@ || {
  if xdg-terminal-exec "$0"; then main $@; else konsole --noclose -e "$0"; fi
}
