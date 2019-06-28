#!/bin/bash

CWD=$(dirname "$0")

source "${CWD}/run-base.sh"

runhist.sh -ds $RTV_CMD_ARGS -log4jprops:default.log4j.properties $*
