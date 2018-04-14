#!/bin/bash
# In sh "[[]]" won't work
gitUserName="User name"
gitUserEmail=user@emal.com
workFolder=/home/$USER


cmd=(dialog --separate-output --checklist "Please Select options to apply:" 22 76 16)
options=(1 "Work folder alias" off
  2 "Git user config" off
  3 "Nautilus: backspace shortcut" off
  4 "ecryptfs: Make dir ~/MD/pack for " off
  5 "VLC: disable controls in fullscreen" off
  6 "VisualVM plugins (manual)" off)
  choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
  clear
  for choice in $choices
do
  case $choice in
  1)
    #Bash
    # Make an alias to the poject. Type "work" in termintal to change dir.
    echo "Set alias for work folder"
    if [[ -e $HOME/.bashrc ]]
    then
      if [[ ! -z $workFolder ]]
      then
        grep_out=$(grep -E 'alias work' $HOME/.bashrc)
        if [[ $? -eq 0 ]]
          then
            echo "Found 'work' alias in $HOME/.bashrc. Replacing."
            sed -i -E "s|alias work.*$|alias work='cd $workFolder'|" $HOME/.bashrc
          else
            echo "NOT found any 'work' alias in $HOME/.bashrc. Adding work alias."
            echo "alias work='cd $workFolder'">>$HOME/.bashrc
        fi
      else
        echo "'workFolder' variable is empty"
        echo "Failed to set alias for work folder"
      fi
    else
      echo "WARN: no .bashrc found, creating."
      echo "alias work='cd $workFolder'">>$HOME/.bashrc
    fi
    ;;
  2)
    #Git
    git config --global push.default matching
    git config --global user.name $gitUserName
    git config --global user.email $gitUserEmail
    ;;
  3)
    #Nautilus
    # 'BackSpace' shortcut = go directory back
    nautilus_config="~/.config/nautilus/accels"
    if [[ -e "$nautilus_config" ]]
    then
      echo 'gtk_accel_path "/ShellActions/Up" "BackSpace"' >> $nautilus_config
    else
      echo 'Nautilus config not found'
    fi
    ;;
  4)
    #ecryptfs
    # Add folder to be encrypted
    mkdir ~/MD/pack
    ;;
  5)
    #VLC
    # 5.1. https://github.com/nurupo/vlc-pause-click-plugin
    echo "Please, manually install vlc-pause-click-plugin from https://github.com/nurupo/vlc-pause-click-plugin"
    # 5.2. Disable controls in fullscreen to evade crush:
    #  https://askubuntu.com/questions/969798/vlc-crash-on-ubuntu-17-10-screen-freezes
    #  Actual vefore VLC ver.3.*
    vlc_config=$HOME/.config/vlc/vlcrc
    setting_regexp='#?qt-fs-controller=.?'
    setting_new='qt-fs-controller=0'
    echo "Start VLC configuration: disable controls in fullscreen"
    if [[ -e $vlc_config ]]
    then
        grep_out=$(grep -E $setting_regexp $vlc_config)
        if [[ $? -eq 0 ]]
          then
            echo "Pattern FOUND, replacing '$grep_out' for '$setting_new'"
            sed -i -E "s/$setting_regexp/$setting_new/" $vlc_config
          else
            echo "Pattern '$setting_regexp' NOT FOUND in $vlc_config"
            echo '# Show a controller in fullscreen mode (boolean)' >> $vlc_config
            echo "$setting_new" >> $vlc_config
            echo "Added '$setting_new' setting to $vlc_config"
        fi
    else
      echo "VLC config NOT FOUND at $vlc_config. Is VLC installed?"
    fi
    echo "Done VLC configuration"
    ;;
  6)
    echo "Please, manually install plugins:"
    echo "Visual GC"
    echo "SAPlugin"
    echo "Startup Profiler"
    echo "Threads Inspector"
    ;;
  7)
    echo "Please, manually copy scripts to ~/bin"
    ;;
  esac
done