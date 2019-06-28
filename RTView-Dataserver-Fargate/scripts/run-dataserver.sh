#!/bin/bash

CWD=$(dirname "$0")

source "${CWD}/run-base.sh"

rundata.sh -propfilter:receiver $RTV_CMD_ARGS -log4jprops:default.log4j.properties $*
