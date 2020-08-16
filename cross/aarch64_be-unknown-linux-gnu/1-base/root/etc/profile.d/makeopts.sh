#!/bin/bash

export MAKEOPTS="-j$(lscpu -p | grep -cv '#')"
