#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

set -x

java -Xms512M -Xmx1G -XX:MaxPermSize=128M -jar spigot.jar
