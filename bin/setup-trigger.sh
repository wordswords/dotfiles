#!/bin/bash -xe

cd ~/workspace
rm -rf ./perf-automation-venv
virtualenv --no-site-packages -p /usr/bin/python2.7  perf-automation-venv
source perf-automation-venv/bin/activate
pip install git+ssh://ds-gerrit.euhpc.arm.com:29418/scratch/flohah01/py-gocd git+ssh://ds-gerrit.euhpc.arm.com:29418/shoji/aarch64-perf-automation

cd ~/workspace
echo "Now type: source perf-automation-venv/bin/activate"


