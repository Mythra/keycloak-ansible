#!/usr/local/bin/bash

echo "Bash based mounter for FreeBSD OpenJDK compatability."
echo "OpenJDK requires procfs to point to /proc, and fdescfs to point to /dev/fd."
echo "This script will create the necessary mount points if they don't exist."
echo "And then add them to fstab for long term compatability."

__lines=$(df | wc -l | xargs)
__line_count=$(( $__lines - 1 ))
readarray __block_devices < <(df | tail -n "$__line_count" | sed -e 's/^[ \t]*//')

__has_fdescfs="0"
__has_procfs="0"

for __block_device in "${__block_devices[@]}"; do
  readarray __last_read_block < <(echo "$__block_device" | awk '{printf "%s\n%s", $1, $6}')
  __block_simple_name=$(echo "${__last_read_block[0]}" | xargs)
  __block_path=$(echo "${__last_read_block[1]}" | xargs)

  if [[ "$__block_simple_name" == "procfs" ]]; then
    if [[ "$__block_path" == "/proc" ]]; then
      __has_procfs="1"
    fi
  fi
  if [[ "$__block_simple_name" == "fdescfs" ]]; then
    if [[ "$__block_path" == "/dev/fd" ]]; then
      __has_fdescfs="1"
    fi
  fi
done

if [[ "$__has_fdescfs" == "0" ]]; then
  echo "fdescfs mount at /dev/fd does not exist! Creating!"
  mount -t fdescfs fdesc /dev/fd
  echo "fdesc   /dev/fd         fdescfs         rw      0       0" > /etc/fstab
fi

if [[ "$__has_procfs" == "0" ]]; then
  echo "procfs does not exist pointed at /proc! Creating!"
  mount -t procfs proc /proc
  echo "proc    /proc           procfs          rw      0       0" > /etc/fstab
fi

echo "Mount points have been created!"
