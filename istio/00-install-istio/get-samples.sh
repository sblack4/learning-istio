#!/bin/bash

kubectx EUS1DEVISTIOAKS
wget https://github.com/istio/istio/archive/1.9.0.tar.gz
tar xvzf 1.9.0.tar.gz
rm 1.9.0.tar.gz
cp -r istio-1.9.0/samples .
