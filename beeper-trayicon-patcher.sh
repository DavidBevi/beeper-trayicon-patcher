#!/usr/bin/env bash
#
# BEEPER TRAYICON PATCHER v1.1 - by DavidBevi
# - Brief: This script replaces the systray icons of Beeper AppImage (Linux)
# - Download: https://github.com/DavidBevi/beeper-trayicon-patcher
# - License: MIT (everything's allowed, no warranty)
#
# REQUIREMENTS
# - Beeper.AppImage            - https://beeper.com
# - appimagetool.AppImage      - https://github.com/AppImage/appimagetool
# - asar installed             - https://github.com/electron/asar
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
  if xdg-terminal-exec "$0" "$@"; then return $?;
  elif konsole --hold -e "$0" "$@"; then return $?;
  fi; }

# ENSURE CORRECT WORKING DIR
# when script is launched with drag-n-drop $PWD==$HOME
# this is wrong, so we use the path of the script
[[ "$PWD" == "$HOME" ]] && { cd "${0%/*}" || :; }

# THE NEXT LINE THAT GETS EXECUTED IS THE LAST ONE
# what follows it's the entire patcher laid out in a single function
# basically it's main(), but with a meaningful and unique name
# this is done to retain a single functional object when sourced
beeper-trayicon-patcher() {
  # print_title ---------------------------------------------------------------
  echo -e "\e[1;7m BEEPER TRAYICON PATCHER \e[0m🭬"

  # if_arg1_is_help_print_help ------------------------------------------------
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then echo "
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
"; return 0; fi

  # shared_variables ----------------------------------------------------------
  local pathBPR pathAIT pathTY pathTUY pathOUT
  local  argBPR  argAIT  argTY  argTUY  argOUT
  local  errBPR  errAIT  errTY  errTUY  errOUT  errASAR
  local N="\e[0m" R="\e[1;31m" G="\e[1;32m" Y="\e[1;33m"

  # helper_functions ----------------------------------------------------------
  echoOK() { echo -e "\e[1;32mOK\e[0m"; }
  echoKO() { echo -e "\e[1;31mKO\e[0m"; }
  echoABORT() { echo -e "${R}ABORT - EXIT$N\n"; }
  echoCANCELLED() { echo -e "${G}CANCELLED - EXIT$N\n"; }
  echoFINISHED() { echo -e "${G}FINISHED - EXIT$N\n"; }
  first_file_that_matches() { echo "${1%% *}"; }
  pretty_cat() { printf "Log: \e[3;38;5;225m"; cat "$1"; echo -e "\e[0m"; }

  # find_required_files_in_working_directory ----------------------------------
  pathBPR=$(first_file_that_matches ./*eeper*.*pp*mage)
  pathAIT=$(first_file_that_matches ./*pp*mage*ool*.*pp*mage)
  pathTY=$(first_file_that_matches ./*ray?con.png)
  pathTUY=$(first_file_that_matches ./*ray?nread?con.png)
  pathOUT="Beeper-patched.AppImage"

  # fetch_paths_from_args -----------------------------------------------------
  for arg in "$@"; do
    [[ -x "$arg" && "$arg" == *eeper*.*pp*mage ]] && argBPR="$arg"
    [[ -x "$arg" && "$arg" == *pp*mage*ool*.*pp*mage ]] && argAIT="$arg"
    [[ "$arg" == *ray[^Uu]*(I|i)con.png ]] && argTY="$arg"
    [[ "$arg" == *ray?nread?con.png ]] && argTUY="$arg"
    [[ "$arg" == --out=* || "$arg" == -o=* ]] && argOUT="${arg#*=}"
  done

  # validate_paths ------------------------------------------------------------
  # for each file do a test on the path provided as argument
  # if it fails do a test on the path fetched from working dir
  # if both fail flag a specific variable, we use it later to abort
  # beeper
  $argBPR --appimage-version >/dev/null 2>&1  && pathBPR="$argBPR" || {
  $pathBPR --appimage-version >/dev/null 2>&1 || errBPR=1; }
  # appimagetool
  $argAIT --appimage-version >/dev/null 2>&1  && pathAIT="$argAIT" || {
  $pathAIT --appimage-version >/dev/null 2>&1 || errAIT=1; }
  # asar
  asar --version >/dev/null 2>&1              || errASAR=1
  # trayIcon
  [[ -f "$argTY" ]]                           && pathTY="$argTY"   || {
  [[ -f "$pathTY" ]]                          || errTY=1; }
  # trayUnreadIcon
  [[ -f "$argTUY" ]]                          && pathTUY="$argTUY" || {
  [[ -f "$pathTUY" ]]                         || errTUY=1; }
  # output
  if [[ ! -f "$argOUT" ]] && touch "$argOUT" 2>/dev/null; then
    pathOUT="$argOUT"; rm "$pathOUT"
  elif [[ -f "$argOUT" ]] && true 2>/dev/null >> "$argOUT"; then
    pathOUT="$argOUT"
  elif [[ ! -f "$pathOUT" ]] && touch "$pathOUT" 2>/dev/null; then
    rm "$pathOUT"
  elif not true 2>/dev/null >> "$pathOUT"; then
    errOUT=1
  fi

  # print_summary -------------------------------------------------------------
  # uses the results of validation to set colors
  local X
  echo -e "Working directory: $G$PWD$N"
  # beeper
  [[ $errBPR ]] && X=$R || X=$G
  echo -e "AppImage to patch: $X$pathBPR$N"
  # appimagetool
  [[ $errAIT ]] && X=$R || X=$G
  echo -e "appimagetool (file): $X$pathAIT$N"
  # asar
  [[ $errASAR ]] && X=${R}un || X=$G
  echo -e "asar (cli program): ${X}installed$N"
  # trayIcon
  [[ $errTY ]] && X=$R || X=$G
  echo -e "New trayIcon.png: $X$pathTY$N"
  # trayUnreadIcon
  [[ $errTUY ]] && X=$R || X=$G
  echo -e "New trayUnreadIcon.png: $X$pathTUY$N"
  # output
  if [[ $errOUT ]]; then
    echo -e "Output file: $R$pathOUT$N"
    echo -e "${R}Error$N: output file cannot be written."
    echo -e "${Y}Tip$N: ensure that output file isn't running."
  elif [[ -f "$pathOUT" ]]; then
    echo -e "$Y!!$N Output file: $G$pathOUT$N"
    echo -e "$Y!!$N Output file will be overwritten"
  else
    echo -e "Output file: $G$pathOUT$N"
  fi
  echo "————————————————————————————————————————————————"

  # if_paths_are_bad_then_exit ------------------------------------------------
  ((errBPR+errAIT+errTY+errTUY+errOUT+errASAR!=0)) && echoABORT && return 1

  # start_patching_prompt -----------------------------------------------------
  echo -en "${G}READY TO PATCH.$N Continue? (y/n) "
  local key
  while IFS= read -rsn1 key; do
    case "$key" in
      y|"") key="y"; break;; n|$'\e') key="n"; break;;
    esac
  done
  if [[ "$key" == y ]];
    then echo -e "\e[99D\e[0K${G}PROCEEDING TO PATCHING$N"
    else echo "n"; echoCANCELLED; return 0
  fi

  # unpack_appimage -----------------------------------------------------------
  echo -n "Unpacking AppImg: "
  chmod +x "$pathBPR" # prevents unpacking issues
  if "$pathBPR" --appimage-extract \
        >/var/tmp/appimagetool.log 2>&1;
    then echoOK;
    else echoKO; pretty_cat /var/tmp/appimagetool.log; echoABORT; return 2
  fi
  chmod -R a+rX squashfs-root # prevents repacking issues

  # unpack_asar ---------------------------------------------------------------
  echo -n "Unpacking ASAR archive: "
  if asar extract squashfs-root/resources/app.asar asar-tmp \
        >/var/tmp/asar.log 2>&1;
    then echoOK;
    else echoKO; pretty_cat /var/tmp/asar.log; echoABORT; return 3
  fi

  # replace_files -------------------------------------------------------------
  shopt -q globstar; local had_globstar=$?
  shopt -q nullglob; local had_nullglob=$?
  shopt -s globstar nullglob
  #
  local error=0
  echo -n "Replacing icons: "
  for file in ./asar-tmp/**/"trayIcon"*.png; do
    cp -f "$pathTY" "$file" || { echo "$file not overwritten"; error=1; }
  done
  for file in ./asar-tmp/**/"trayUnreadIcon"*.png; do
    cp -f "$pathTUY" "$file" || { echo "$file not overwritten"; error=1; }
  done
  #
  (( had_globstar )) && shopt -u globstar
  (( had_nullglob )) && shopt -u nullglob
  #
  if ((error==0));
    then echoOK
    else echoKO; echoABORT; return 4
  fi

  # repack_asar ---------------------------------------------------------------
  echo -n "Repacking ASAR archive: "
  if asar pack asar-tmp squashfs-root/resources/app.asar \
        --unpack '**/{.**,**}/**/*.node' \
        --unpack-dir '**/node_modules/{sharp,@img}' \
        >/var/tmp/asar.log 2>&1;
    then echoOK; rm -rf asar-tmp;
    else echoKO; rm -rf asar-tmp;
      pretty_cat /var/tmp/asar.log; echoABORT; return 5
  fi

  # repack_appimage -----------------------------------------------------------
  echo -n "Repacking AppImage: "
  if "$pathAIT" squashfs-root Beeper-patched.AppImage \
        >/var/tmp/appimagetool.log 2>&1;
    then echoOK; rm -rf squashfs-root;
    else echoKO; rm -rf squashfs-root;
      pretty_cat /var/tmp/appimagetool.log; echoABORT; return 6
  fi

  # good_ending ---------------------------------------------------------------
  echo "————————————————————————————————————————————————"
  echoFINISHED
  return 0
}

# FINAL CALL TO THE FUNCTION THAT CONTAINS THE SCRIPT
#
beeper-trayicon-patcher "$@"
