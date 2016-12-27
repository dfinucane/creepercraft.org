#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

set -x

java -Xms512M -Xmx512M -jar BungeeCord.jar
