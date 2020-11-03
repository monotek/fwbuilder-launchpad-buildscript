FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

ARG LAUNCHPAD_UPLOAD="no"
ARG OS_VERSIONS="focal"
ARG PACKAGE_VERSION="5.3.7"

WORKDIR /tmp

COPY config.dist /tmp/
COPY fwbuilder.sh /tmp/

RUN apt-get update -y;apt-get -y upgrade; \
    apt-get install --no-install-recommends -y build-essential cdbs cmake debhelper devscripts dput git libsnmp-dev libxml2-dev libxslt1-dev pkg-config qt5-qmake-bin qtbase5-dev qttools5-dev-tools zlib1g-dev 

RUN sed -r -e "s#DEBEMAIL=.*#DEBEMAIL=\"${DEBEMAIL}\"#g" \
    -e "s#DEBFULLNAME=.*#DEBFULLNAME=\"${DEBFULLNAME}\"#g" \
    -e "s#LAUNCHPAD_UPLOAD=.*#LAUNCHPAD_UPLOAD=\"${LAUNCHPAD_UPLOAD}\"#g" \
    -e "s#OS_VERSIONS=.*#OS_VERSIONS=\"${OS_VERSIONS}\"#g" \
    -e "s#PACKAGE_VERSION=.*#PACKAGE_VERSION=\"${PACKAGE_VERSION}\"#g" \
    -e "s#PPA_OWNER=.*#PPA_OWNER=\"${PPA_OWNER}\"#g" < /tmp/config.dist > /tmp/config

RUN ./fwbuilder.sh
