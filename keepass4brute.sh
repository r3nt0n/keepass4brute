#!/bin/bash

# https://github.com/r3nt0n/keepass4brute
# Name: keepass4brute.sh
# Author: r3nt0n
# Version: 1.0 (25/11/2022)

version="1.3"
/bin/echo -e "keepass4brute $version by r3nt0n"
/bin/echo -e "https://github.com/r3nt0n/keepass4brute\n"

if [ $# -ne 2 ]
then
  /bin/echo "Usage $0 <kdbx-file> <wordlist>"
  exit 2
fi

dep="keepassxc-cli"
command -v $dep >/dev/null 2>&1 || { /bin/echo >&2 "Error: $dep not installed.  Aborting."; exit 1; }

n_total=$( wc -l < $2 )
start_time=$(date +%s)

IFS=''
while read -r line; do
  n_tested=$((n_tested + 1))
  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))

  if [ $elapsed_time -gt 0 ]; then
    attempts_per_minute=$((n_tested * 60 / elapsed_time))
    remaining_attempts=$((n_total - n_tested))
    estimated_time_remaining_seconds=$((remaining_attempts * 60 / attempts_per_minute))
    
    estimated_time_remaining_minutes=$((estimated_time_remaining_seconds / 60))
    estimated_time_remaining_seconds=$((estimated_time_remaining_seconds % 60))

    estimated_time_remaining_hours=$((estimated_time_remaining_minutes / 60))
    estimated_time_remaining_minutes=$((estimated_time_remaining_minutes % 60))

    estimated_time_remaining_days=$((estimated_time_remaining_hours / 24))
    estimated_time_remaining_hours=$((estimated_time_remaining_hours % 24))

    estimated_time_remaining_weeks=$((estimated_time_remaining_days / 7))
    estimated_time_remaining_days=$((estimated_time_remaining_days % 7))

    if [ $estimated_time_remaining_weeks -gt 0 ]; then
      estimated_time_remaining="$estimated_time_remaining_weeks weeks, $estimated_time_remaining_days days"
    elif [ $estimated_time_remaining_days -gt 0 ]; then
      estimated_time_remaining="$estimated_time_remaining_days days, $estimated_time_remaining_hours hours"
    elif [ $estimated_time_remaining_hours -gt 0 ]; then
      estimated_time_remaining="$estimated_time_remaining_hours hours, $estimated_time_remaining_minutes minutes"
    elif [ $estimated_time_remaining_minutes -gt 0 ]; then
      estimated_time_remaining="$estimated_time_remaining_minutes minutes, $estimated_time_remaining_seconds seconds"
    else
      estimated_time_remaining="$estimated_time_remaining_seconds seconds"
    fi
  else
    attempts_per_minute=0
    estimated_time_remaining="Calculating..."
  fi

  /bin/echo -e "\e[2K\r[+] Words tested: $n_tested/$n_total - Attempts per minute: $attempts_per_minute - Estimated time remaining: $estimated_time_remaining"
  /bin/echo -e "\e[2K\r[+] Current attempt: $line"
  
  /bin/echo $line | keepassxc-cli open $1 &> /dev/null
  if [ $? -eq 0 ]
  then
    /bin/echo -ne "\n"
    /bin/echo "[*] Password found: $line"; exit 0;
  fi
  /bin/echo -ne "\e[2A"
done < $2

/bin/echo -ne "\n"
/bin/echo "[!] Wordlist exhausted, no match found"; exit 3;
