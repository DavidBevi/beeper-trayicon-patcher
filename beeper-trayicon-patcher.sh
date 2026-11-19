#!/usr/bin/env bash
# BEEPER TRAYICON PATCHER
# - Brief: This script replaces the systray icons of Beeper AppImage (Linux)
# - Download: https://github.com/DavidBevi/beeper-trayicon-patcher
# - License: MIT (everything's allowed, no warranty)
# HELP and more INFO on line 39 ###############################################

# ENSURE INTERACTIVITY
# when script is double-clicked but a cli doesn't show up this fixes it
# it tries to use your system's default terminal emulator, with fallbacks
[[ -t 0 || -t 1 || -t 2 ]] || {
  if xdg-terminal-exec --hold -e "$0" "$@"; then return $?;
  elif konsole         --hold -e "$0" "$@"; then return $?;
  elif alacritty       --hold -e "$0" "$@"; then return $?;
  fi; }

# ENSURE CORRECT WORKING DIR
# when script is launched with drag-n-drop $PWD becomes $HOME
# this is wrong, so we manually change it to the script's dir
[[ "$PWD" == "$HOME" ]] && { cd "${0%/*}" || :; }

###############################################################################
# THE NEXT LINE THAT GETS EXECUTED IS THE LAST ONE
###############################################################################

# MAIN ——— but with a meaningful and unique name ———
# sourcing is done cleanly, loading only this object
beeper-trayicon-patcher() {
  # print_title ---------------------------------------------------------------
  echo -e "\e[1;7m BEEPER TRAYICON PATCHER \e[0m🭬"

  # if_arg1_is_version_print_version_and_return --------------------------------
  if [[ "$1" == -v || "$1" == --ver* ]]; then echo "v1.4"; return 0; fi

  # if_arg1_is_help_print_help_and_return -------------------------------------
  if [[ "$1" == -h || "$1" == --help ]]; then
   echo "This script replaces the systray icons of Beeper AppImage (Linux)

REQUIREMENTS
- asar installed            - https://github.com/electron/asar
- appimagetool.AppImage     - https://github.com/AppImage/appimagetool
- Beeper.AppImage           - https://beeper.com
- a new trayIcon.png        - suggested size 32x32 px
- a new trayUnreadIcon.png  - suggested size 32x32 px

The script looks for files with these names in its same directory.
You can override this by passing the paths of other files as args.
The script checks filenames ignoring suffixes, like version and
  architecture, so names like 'Beeper-4.3-x86_64.AppImage' are ok.

OTHER OPTIONS
 -h | --help        print this page (must be first arg)
 -h | --version     print version   (must be first arg)
 -f | --force       skip confirmation prompt
 -o=output/path     set custom output file

ALSO
This script is designed to run with double-click, and also to run
with custom files when these are drag-n-dropped onto it.
"; return 0; fi

  # shared_variables ----------------------------------------------------------
  local pathBPR pathAIT pathTY pathTUY pathOUT
  local argBPR  argAIT  argTY  argTUY  argOUT
  local OPT  ERR="-bpr-ko--ait-ko--asar-ko--ty-ko--tuy-ko--out-ko"
  local N="\e[0m" R="\e[1;31m" G="\e[1;32m" Y="\e[1;33m"

  # helper_functions ----------------------------------------------------------
  echoOK() { echo -e "${G}OK$N"; }
  echoKO() { echo -e "${R}KO$N"; }
  echoABORT() { echo -e "${R}ABORT - EXIT$N\n"; }
  echoCANCELLED() { echo -e "${G}CANCELLED - EXIT$N\n"; }
  echoFINISHED() { echo -e "${G}FINISHED - EXIT$N\n"; }
  catERR() { printf "Log: \e[3;38;5;225m"; cat "$1" >&2; echo -e "\e[0m"; }
  unERR() { ERR="${ERR/$1-ko/$1-${2:-ok}}"; }
  spin() { local pid=$! i=0 sp='\|/-'; while kill -0 "$pid" 2>/dev/null; do
    printf "%c\b" "${sp:i++%4:1}"; sleep 0.1; done; wait "$pid"; return $?; }

  # arg_parsing ---------------------------------------------------------------
  for i in "$@"; do
    [[ "$i" == "-f" || "$i" == "--force" ]]         && OPT+=-forced
    [[ -x "$i" && "$i" == *eeper*.*pp*mage ]]       && argBPR="$i"
    [[ -x "$i" && "$i" == *pp*mage*ool*.*pp*mage ]] && argAIT="$i"
    [[ "$i" == *ray[^Uu]*(I|i)con.png ]]            && argTY=" $i"
    [[ "$i" == *ray?nread?con.png ]]                && argTUY="$i"
    [[ "$i" == --out=* || "$i" == -o=* ]]           && argOUT="${i#*=}"
  done

  # validate_paths ------------------------------------------------------------
  # beeper
  for p in "$argBPR" ./?eeper*.?pp?mage; do
    pathBPR="$p";
    "$p" --appimage-version >/dev/null 2>&1 && { unERR bpr; break; }
  done
  # appimagetool
  for p in "$argAIT" ./?pp?mage?ool*.?pp?mage; do
    pathAIT="$p";
    "$p" --appimage-version >/dev/null 2>&1 && { unERR ait; break; }
  done
  # asar
  if asar --version >/dev/null 2>&1; then unERR asar; fi
  # trayIcon
  for p in "$argTY" ./?ray?con.png; do
    pathTY="$p";
    [[ -f "$p" ]] && { unERR ty; break; }
  done
  # trayUnreadIcon
  for p in "$argTUY" ./?ray?nread?con.png; do
    pathTUY="$p";
    [[ -f "$p" ]] && { unERR tuy; break; }
  done
  # output
  for p in "$argOUT" "./Beeper-patched.AppImage"; do
    pathOUT="$p";
    if [[ ! -f "$p" ]] && touch "$p" 2>/dev/null;
      then unERR out; rm "$p"; break
    elif [[ -f "$p" ]] && true 2>/dev/null >> "$p";
      then unERR out ow; break
    fi; done

  # print_summary -------------------------------------------------------------
  # uses the results of validation to set colors
  # echo -e "Working directory: $G$PWD$N"
  case "$ERR" in
    # beeper
    *bpr-ok*) echo -e "AppImage to patch: $G$pathBPR$N";;&
    *bpr-ko*) echo -e "AppImage to patch: $R$pathBPR$N";;&
    # appimagetool
    *ait-ok*) echo -e "appimagetool (file): $G$pathAIT$N";;&
    *ait-ko*) echo -e "appimagetool (file): $R$pathAIT$N";;&
    # asar
    *asar-ok*) echo -e "asar (cli program): ${G}installed$N";;&
    *asar-ko*) echo -e "asar (cli program): ${R}uninstalled$N";;&
    # trayIcon
    *ty-ok*) echo -e "New trayIcon.png: $G$pathTY$N";;&
    *ty-ko*) echo -e "New trayIcon.png: $R$pathTY$N";;&
    # trayUnreadIcon
    *tuy-ok*) echo -e "New trayUnreadIcon.png: $G$pathTUY$N";;&
    *tuy-ko*) echo -e "New trayUnreadIcon.png: $R$pathTUY$N";;&
    # output
    *out-ok*) echo -e "Output file: $G$pathOUT$N";;&
    *out-ow*) echo -e "Output file: $G$pathOUT$N\n"\
      "$Y!!$N Output file will be overwritten";;&
    *out-ko*) echo -e "Output file: $R$pathOUT$N\n"\
      "${R}Error$N: output file cannot be written.\n"\
      "${Y}Tip$N: ensure that output file isn't running.";;&
    *) echo "————————————————————————————————————————————————";;
  esac

  # if_error_abort ------------------------------------------------------------
  [[ "$ERR" == *ko* ]] && echoABORT && return 1

  # prompt_startpatching_yn ---------------------------------------------------
  if [[ "$OPT" != *forced* ]]; then
    echo -en "${G}READY TO PATCH.$N Continue? (Y/n) "
    local key
    while IFS= read -rsn1 key; do
      case "$key" in
        y|"") key="y"; break;;         # "y" or "enter" > continue
        n) break;;                     # "n"" > return
        $'\e') read -rst 0.1 key;      # "escape" is $`\e`, but special keys
          if [[ $key == "" ]]; then    # start with it, if rest of input
            key="n"; break; fi         # is empty > "escape" > return
      esac; done
    if [[ "$key" == y ]];
      then echo -e "\e[99D\e[0K${G}PROCEEDING TO PATCHING$N"
      else echo "n"; echoCANCELLED; return 0
    fi
  fi

  # unpack_appimage -----------------------------------------------------------
  echo -n "Unpacking AppImg:       "
  chmod +x "$pathBPR" # get permissions, avoid unpacking issues
  if "$pathBPR" --appimage-extract \
        >/var/tmp/appimagetool.log 2>&1 & spin;
    then echoOK;
    else echoKO; catERR /var/tmp/appimagetool.log; echoABORT; return 2
  fi
  chmod -R +rx squashfs-root # get permissions, avoid repacking issues

  # unpack_asar ---------------------------------------------------------------
  echo -n "Unpacking ASAR archive: "
  if asar extract squashfs-root/resources/app.asar asar-tmp \
        >/var/tmp/asar.log 2>&1 & spin;
    then echoOK;
    else echoKO; catERR /var/tmp/asar.log; echoABORT; return 3
  fi

  # replace_files -------------------------------------------------------------
  shopt -q globstar; local had_globstar=$?
  shopt -q nullglob; local had_nullglob=$?
  shopt -s globstar nullglob
  #
  local error=0
  echo -n "Replacing icons:        "
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
        >/var/tmp/asar.log 2>&1 & spin;
    then echoOK; rm -rf asar-tmp;
    else echoKO; rm -rf asar-tmp;
      catERR /var/tmp/asar.log; echoABORT; return 5
  fi

  # repack_appimage -----------------------------------------------------------
  echo -n "Repacking AppImage:     "
  if "$pathAIT" squashfs-root Beeper-patched.AppImage \
        >/var/tmp/appimagetool.log 2>&1 & spin;
    then echoOK; rm -rf squashfs-root;
    else echoKO; rm -rf squashfs-root;
      catERR /var/tmp/appimagetool.log; echoABORT; return 6
  fi

  # good_ending ---------------------------------------------------------------
  echo "————————————————————————————————————————————————"
  echoFINISHED
  return 0
}

# LAUNCH THE SCRIPT (WITH ARGUMENTS)
beeper-trayicon-patcher "$@"
