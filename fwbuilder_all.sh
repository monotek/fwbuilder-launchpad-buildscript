#!/bin/bash
#
# build fwbuilder
#

if [ ! -f config ]; then
    echo "need config file. create from config.dist before running this script!"
    exit 1
fi

# import config
. "config"

#script

for OS in ${OS_VERSION_ALL}; do
        echo -e "\n#######################\nbuilding ${PACKAGE} ${PACKAGE_VERSION} for OS ${OS}\n#######################\n"
        /bin/bash fwbuilder.sh ${OS} ${PACKAGE_VERSION}
done
