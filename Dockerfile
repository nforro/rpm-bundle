FROM ubuntu:precise
MAINTAINER Nikola Forró <nforro@redhat.com>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y --no-install-recommends install \
        apt-utils \
        build-essential \
        devscripts \
        equivs \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
