#!/usr/bin/env bash

pyscript=$1

if [[ -f pyzmq-venv/bin/activate ]] ; then
    source pyzmq-venv/bin/activate
    python $pyscript
    deactivate
else
    python $pyscript
fi
