#!/bin/sh
#-
# SPDX-License-Identifier: BSD-2-Clause-FreeBSD
#
# Copyright 2024 Michael Dexter
# All rights reserved
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted providing that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

ports="22 80 443 3389 8080"
low="1"
high="255"
subnet=$( netstat -4rn | grep default | awk '{print $2}' | cut -d "." -f1,2,3 )

while getopts p:s:l:h: opts ; do
        case $opts in
        p) ports="$OPTARG" ;; # Would be nice to validate
        s) subnet="$OPTARG" ;; # Would be nice to validate
        l) low="$OPTARG" ;;
        h) high="$OPTARG" ;;
	*)
		echo Usage: sh hipscan.sh to attempt to scan the current subnet
		echo
		echo sh hipscan.sh -s 10.0.0 - to scan subnet 10.0.0
		echo sh hipscan.sh -p \"23 25\" - to scan ports 23 and 25
		echo sh hipscan.sh -l 100 - to begin at low IP \<subnet\>.100 
		echo sh hipscan.sh -h 200 - to end at high IP \<subnet\>.200 
		exit 1
	;;
	esac
done

while [ "$low" -le "$high" ] ; do
	for port in $ports ; do
result=$( timeout .01 nc -w 1 -n -z ${subnet}.$low $port 2>&1 >/dev/null )
		if [ "$result" != "" ] ; then
			result=$( echo $result | cut -d " " -f 4 )
			open_ports="$open_ports $result"
		fi
	done
		if [ "$open_ports" != "" ] ; then
			echo -n "${subnet}.$low " ; echo $open_ports
		fi
		open_ports=""
		low=$(( $low + 1 ))
done
