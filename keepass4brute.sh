#!/bin/bash

# https://github.com/r3nt0n/keepass4brute
# Name: keepass4brute.sh
# Author: r3nt0n
# Version: 1.0 (25/11/2022)

version="1.1"
/bin/echo -e "\nkeepass4brute $version by r3nt0n"
/bin/echo -e "https://github.com/r3nt0n/keepass4brute\n"


if [ $# -ne 2 ]
then
  /bin/echo "Usage $0 <kdbx-file> <wordlist>"
  exit 2
fi

dep="keepassxc-cli"
command -v $dep >/dev/null 2>&1 || { /bin/echo >&2 "Error: $dep not installed.  Aborting."; exit 1; }

n_total=$( wc -l < $2 )
n_tested=0

IFS=''
while read -r line; do
  n_tested=$((n_tested + 1))
  /bin/echo -ne "[+] Words tested: $n_tested/$n_total ($line)                                          \r"

  if ! /bin/echo $line | keepassxc-cli open $1 2>&1 | /bin/grep -q "Error"
  then
    /bin/echo -ne "\n"
    /bin/echo "[*] Password found: $line"; exit 0;
  fi
done < $2

/bin/echo -ne "\n"
/bin/echo "[!] Wordlist exhausted, any match found"; exit 3;
