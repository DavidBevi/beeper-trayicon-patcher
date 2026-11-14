#!/usr/bin/env bash
#
# BEEPER TRAYICON PATCHER v1 - by DavidBevi
# - Brief: This script replaces the systray icons of Beeper AppImage (Linux)
# - Download: https://github.com/DavidBevi/beeper-trayicon-patcher
# - License: MIT (everything's allowed, no warranty)
#
# REQUIREMENTS
# - asar installed             - https://github.com/electron/asar
# - appimagetool.AppImage      - https://github.com/AppImage/appimagetool
# - Beeper.AppImage            - https://beeper.com
# - a new trayIcon.png         - suggested size 32x32 px
# - a new trayUnreadIcon.png   - suggested size 32x32 px
#
# The script works when files are in its same directory, or you can pass other
#   file-paths as arguments and the script will use them if they match names.
# Tests are lenient, case-insensitive, and ignore suffix like version and
#   architecture, so names like 'Beeper-4.3.308-x86_64.AppImage' are fine.
#
# USAGE
# - you can launch it via cli as usual, by typing the path of this file.
# - you can also double-click it in your file manager to launch a cli.
# - you can also drag required files on this script in your file manager.
#******************************************************************************

# ENSURE INTERACTIVITY
# when script is double-clicked but a cli doesn't show up this fixes it
# it tries to summon your default terminal emulator, a fallback is hardcoded
[[ -t 0 || -t 1 || -t 2 ]] || {
  xdg-terminal-exec "$0" "$@" || konsole --hold -e "$0" "$@"; }

# ENSURE CORRECT WORKING DIR
# when script is launched with drag-n-drop $PWD==$HOME
# this is wrong, so we use the path of the script
[[ "$PWD" == "$HOME" ]] && { cd "${0%/*}" || :; }

# BUILD THE GLOBALS
# info shared between functions, packed into an associative array to minimize
# collisions and simplify unsetting, for when the script is sourced
declare -A AIP_PATH
first_file_that_matches() { echo "${1%% *}"; }
AIP_PATH[bpr]=$(first_file_that_matches ./*eeper*.*pp*mage)
AIP_PATH[ait]=$(first_file_that_matches ./*pp*mage*ool*.*pp*mage)
AIP_PATH[ty]=$(first_file_that_matches ./*ray?con.png)
AIP_PATH[tuy]=$(first_file_that_matches ./*ray?nread?con.png)
AIP_PATH[out]="Beeper-patched.AppImage"
AIP_PATH[err]=""

# #############################################################################
# FUNCTIONS ###################################################################

echoOK() { echo -e "\e[1;32mOK\e[0m"; }

echoKO() { echo -e "\e[1;31mKO\e[0m"; }

print_title() { echo -e "\e[1;7m BEEPER TRAYICON PATCHER \e[0m🭬"; }

arg1_is_help() { # if arg1 isn't -h nor --help return 1 (=false in bash)
  [[ "$1" == "-h" || "$1" == "--help" ]] || return 1
}

print_help() { echo "
HELP PAGE
- Brief: This script replaces the systray icons of Beeper AppImage (Linux)
- Download: https://github.com/DavidBevi/beeper-trayicon-patcher
- License: MIT (everything's allowed, no warranty)

REQUIREMENTS
- asar installed             - https://github.com/electron/asar
- appimagetool.AppImage      - https://github.com/AppImage/appimagetool
- Beeper.AppImage            - https://beeper.com
- a new trayIcon.png         - suggested size 32x32 px
- a new trayUnreadIcon.png   - suggested size 32x32 px

The script works when files are in its same directory, or you can pass other
  file-paths as arguments and the script will use them if they match names.
Tests are lenient, case-insensitive, and ignore suffix like version and
  architecture, so names like 'Beeper-4.3.308-x86_64.AppImage' are fine.

USAGE
- you can launch it via cli as usual, by typing the path of this file.
- you can also double-click it in your file manager to launch a cli.
- you can also drag required files on this script in your file manager.
"; }

fetch_paths_from_args() {
  for arg in "$@"; do
    [[ -x "$arg" && "$arg" == *eeper*.*pp*mage ]] && AIP_PATH[bpr]="$arg"
    [[ -x "$arg" && "$arg" == *pp*mage*ool*.*pp*mage ]] && AIP_PATH[ait]="$arg"
    [[ "$arg" == *ray[^Uu]*(I|i)con.png ]] && AIP_PATH[ty]="$arg"
    [[ "$arg" == *ray?nread?con.png ]] && AIP_PATH[tuy]="$arg"
    [[ "$arg" == test ]] && echo
  done
}

validate_paths() { # test paths, invalid things get logged into AIP_PATH[err]
  ${AIP_PATH[bpr]} --appimage-version >/dev/null 2>&1 || AIP_PATH[err]+="-bpr"
  ${AIP_PATH[ait]} --appimage-version >/dev/null 2>&1 || AIP_PATH[err]+="-ait"
  asar --version >/dev/null 2>&1 || AIP_PATH[err]+="-asar"
  [[ -f "${AIP_PATH[ty]}" ]] || AIP_PATH[err]+="-ty"
  [[ -f "${AIP_PATH[tuy]}" ]] || AIP_PATH[err]+="-tuy"
  true 2>/dev/null >> "${AIP_PATH[out]}" || AIP_PATH[err]+="-out"
}

paths_are_bad() {
  [[ -n "${AIP_PATH[err]}" ]] && return 0 || return 1
}

print_summary() {
  local N="\e[0m" R="\e[1;31m" G="\e[1;32m" Y="\e[1;33m" col=""
  echo -e "Working directory: $G$PWD$N"
  #
  [[ "${AIP_PATH[err]}" != *-bpr* ]] && col=$G || col=$R
  echo -e "AppImage to patch: $col${AIP_PATH[bpr]}$N"
  #
  [[ "${AIP_PATH[err]}" != *-ty* ]] && col=$G || col=$R
  echo -e "New trayIcon.png: $col${AIP_PATH[ty]}$N"
  #
  [[ "${AIP_PATH[err]}" != *-tuy* ]] && col=$G || col=$R
  echo -e "New trayUnreadIcon.png: $col${AIP_PATH[tuy]}$N"
  #
  [[ "${AIP_PATH[err]}" != *-asar* ]] && col=${G} || col=${R}un
  echo -e "asar (cli program): ${col}installed$N"
  #
  [[ "${AIP_PATH[err]}" != *-ait* ]] && col=${G} || col=${R}
  [[ "${AIP_PATH[err]}" != *-ait* ]] && col=${G} || col=${R}
  echo -e "appimagetool (file): $col${AIP_PATH[ait]}$N"
  #
  if [[ "${AIP_PATH[err]}" == *-out* ]]; then
    echo -e "Output file: $R${AIP_PATH[out]}$N"
    echo -e "${R}Error$N: output file cannot be written."
    echo -e "${Y}Tip$N: ensure that output file isn't running."
  elif [[ ! -f "${AIP_PATH[out]}" ]]; then
    echo -e "Output file: $G${AIP_PATH[out]}$N"
  else
    echo -e "$Y!!$N Output file: $G${AIP_PATH[out]}$N"
    echo -e "$Y!!$N Output file will be overwritten"
  fi
    #
  echo "————————————————————————————————————————————————"
  if [[ -z "${AIP_PATH[err]}" ]]; then
    echo -e "${G}READY TO PATCH$N"
  else
    echo -e "${Y}Cancelled$N\nAborted"
    return 1
  fi
}

wait_for_answer() {
  local key
  # loop to catch the first "y" or "n"
  while [[ $key != "y" && $key != "n" ]]; do read -rsn1 key; done
  # loop to consume/empty the input buffer
  while IFS= read -rsn1 -t 0.01; do :; done
  echo "$key"
  echo "————————————————————————————————————————————————"
  [[ $key == "y" ]] && return 0 || return 1
}

unpack_appimage() {
  echo -n "Unpacking AppImg: "
  chmod +x "${AIP_PATH[bpr]}" # prevents unpacking issues
  if "${AIP_PATH[bpr]}" --appimage-extract \
    >/var/tmp/appimagetool.log 2>&1;
  then echoOK;
  else echoKO;
   printf "Log: \e[3;38;5;225m"
   cat /var/tmp/appimagetool.log
   echo -e "\e[0mAborted"
   return 1
  fi
  chmod -R a+rX squashfs-root # prevents repacking issues
}

unpack_asar() {
  echo -n "Unpacking ASAR archive: "
  if asar extract squashfs-root/resources/app.asar asar-tmp \
    >/var/tmp/asar.log 2>&1;
  then echoOK;
  else echoKO;
   printf "Log: \e[3;38;5;225m"
   cat /var/tmp/asar.log
   echo -e "\e[0mAborted"
   return 1
  fi
}

replace_files() {
  shopt -q globstar; local had_globstar=$?
  shopt -q nullglob; local had_nullglob=$?
  shopt -s globstar nullglob
  #
  local error=0
  echo -n "Replacing icons: "
  for file in ./asar-tmp/**/"trayIcon"*.png; do
    cp -f "${AIP_PATH[ty]}" "$file" || {
      echo "$file not overwritten"; error=1; }
  done
  for file in ./asar-tmp/**/"trayUnreadIcon"*.png; do
    cp -f "${AIP_PATH[tuy]}" "$file" || {
        echo "$file not overwritten"; error=1; }
  done
  ((error==0)) && echoOK || echoKO
  #
  (( had_globstar )) && shopt -u globstar
  (( had_nullglob )) && shopt -u nullglob
}

repack_asar() {
  echo -n "Repacking ASAR archive: "
  if asar pack asar-tmp squashfs-root/resources/app.asar \
     --unpack '**/{.**,**}/**/*.node' \
     --unpack-dir '**/node_modules/{sharp,@img}' \
     >/var/tmp/asar.log 2>&1;
  then echoOK; rm -rf /var/tmp/asar-tmp;
  else echoKO; rm -rf /var/tmp/asar-tmp;
    printf "Log: \e[3;38;5;225m"
    cat /var/tmp/asar.log
    echo -e "\e[0mAborted"
    return 1
  fi
}

repack_appimage() {
  echo -n "Repacking AppImage: "
  if "${AIP_PATH[ait]}" squashfs-root Beeper-patched.AppImage \
      >/var/tmp/appimagetool.log 2>&1;
  then echoOK; rm -rf /var/tmp/squashfs-root;
  else echoKO; rm -rf /var/tmp/squashfs-root;
    printf "Log: \e[3;38;5;225m"
    cat /var/tmp/appimagetool.log
    echo -e "\e[0mAborted"
    return 1
  fi
}

unset_globals() { unset AIP_PATH; }

# #############################################################################
# MAIN ########################################################################

main() {
  print_title
  if arg1_is_help "$1"; then
    print_help
    unset_globals; return 0
  fi
  fetch_paths_from_args "$@"
  validate_paths
  print_summary
  if paths_are_bad; then
    unset_globals; return 1
  fi
  echo -n "Continue? (y/n) "
  if wait_for_answer; then
    unpack_appimage || { unset_globals; return 2; }
    unpack_asar     || { unset_globals; return 3; }
    replace_files   || { unset_globals; return 4; }
    repack_asar     || { unset_globals; return 5; }
    repack_appimage || { unset_globals; return 6; }
  fi

  echo "————————————————————————————————————————————————"
  echo "Finished"
  unset_globals; return 0
}

# #############################################################################
# BODY ########################################################################

main "$@"
