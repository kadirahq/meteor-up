#!/bin/bash

APPNAME=<%= appName %>

sudo docker rm -f $APPNAME || :
sudo docker rm -f $APPNAME-letsencrypt || :
