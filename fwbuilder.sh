#!/bin/bash
#
# build fwbuilder
#

set -e

if [ ! -f config ]; then
    echo "need config file. create from config.dist before running this script!"
    exit 1
fi

# import config
. "config"

#script
for OS_VERSION in ${OS_VERSIONS}; do
    echo -e "\n#######################\nbuilding ${PACKAGE} ${PACKAGE_VERSION} for OS ${OS_VERSION}\n#######################\n"

    export DEBFULLNAME=${DEBFULLNAME}

    export DEBEMAIL=${DEBEMAIL}

    if [ "${2}" == "nodelete" ]; then
        echo "no delete! uploading new version!"
        cd ${BUILD_DIR}
    else
        test -d ${BUILD_DIR} && rm -rf ${BUILD_DIR}
        test -d ${BUILD_DIR} || mkdir -p ${BUILD_DIR}
        cd ${BUILD_DIR}
        git clone ${FWBUILDER_GIT_REPO}
    fi

    REAL_PATH="$(realpath .)"

    cd $(find ${REAL_PATH} -maxdepth 1 -mindepth 1 -type d -name "*${PACKAGE}*")/debian

    debchange -D ${OS_VERSION} -v ${PACKAGE_VERSION}-${OS_VERSION}1 ${DEBCOMMENT}

    if [ "${LAUNCHPAD_UPLOAD}" == "yes" ]; then
        debuild -S

        dput ppa:${PPA_OWNER}/${PPA} $(find ${REAL_PATH} -name ${PACKAGE}*_source.changes | sort | tail -n1)
    else
        debuild -us -uc -i -I
    fi
done
