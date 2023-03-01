#!/bin/sh

error=0

if [ $# -ne 1 ]; then
    echo "Usage: $0 name-of-manifest-in-current-sysupgrade-dir"
    error=1
else
    if [ ! -e "$1" ]; then
	echo "$0: $1 not found"
        error=1
    fi
fi

if [ $error -ne 0 ]; then
    exit 1
fi

SRCFILE="$1"
TGTFILE="/tmp/manifest.ffbi-remove-the-suffix"

/bin/echo -e "BRANCH=stable\n\n# model version sha512sum filename" >${TGTFILE}
echo "Checksumming ..."
awk <${SRCFILE} 'NF==5 {printf("echo \"%s %s $(sha512sum %s)\"|sed -e %cs/  / /%c\n", $1, $2, $NF, 39, 39);}' | /bin/sh >>${TGTFILE}
echo "Copying ..."
awk <${SRCFILE} 'NF==5 {printf("rsync -av --progress %s /firmware/ffbi/gluon/\n", $NF);}' | /bin/sh
/bin/echo -e "\n# after three dashes follow the ecdsa signatures of everything above the dashes" >>${TGTFILE}
echo "FFBI-style manifest at ${TGTFILE}"
