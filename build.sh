#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Print all executed commands to terminal.
# set -x

if [[ -f build/bin/phpdesktop ]]; then
    rm build/bin/phpdesktop
fi

if [[ -f build/bin/debug.log ]]; then
    rm build/bin/debug.log
fi

count=`ls -1 build/bin/phpdesktop/*.log 2>/dev/null | wc -l`
if [[ ${count} != 0 ]]; then
    rm build/bin/*.log
fi

make -n -R -f Makefile "$@"

rc=$?;
if [[ ${rc} = 0 ]]; then
    echo "OK phpdesktop was built";
    cp src/php.ini build/bin/
    cp src/settings.json build/bin/
    cp src/resources/app-icon.png build/bin/app-icon.png
    cp CEF.License.txt build/bin/
    cp CEF.Readme.txt build/bin/
    cp License.txt build/bin/
    if [[ -d build/bin/www ]]; then
        rm -r build/bin/www
    fi
    cp -r src/www/ build/bin/
    ./build/bin/phpdesktop
    #rm -r build/bin/blob_storage/
    #rm -r build/bin/GPUCache/
else
    echo "ERROR";
    exit ${rc};
fi
