#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

set -x

shopt -s nullglob

bungeecord_directory="bungeecord"
buildtools_directory="buildtools"
spigot_directory="spigot"

function delete_all_artifacts()
{
    rm -rf ${bungeecord_directory}/
    rm -rf ${buildtools_directory}/
    rm -rf ${spigot_directory}/
}

function copy_latest_bungeecord()
{
    bungeecord_files=("http://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar"
    "http://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/module/cmd-alert/target/cmd_alert.jar"
    "http://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/module/cmd-find/target/cmd_find.jar"
    "http://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/module/cmd-list/target/cmd_list.jar"
    "http://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/module/cmd-send/target/cmd_send.jar"
    "http://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/module/cmd-server/target/cmd_server.jar"
    "http://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/module/reconnect-yaml/target/reconnect_yaml.jar")
    for bungeecord_file in ${bungeecord_files[@]}; do
        wget ${bungeecord_file} --directory-prefix=${bungeecord_directory}/
    done
}

function copy_latest_buildtools()
{
    wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar --directory-prefix=${buildtools_directory}/
}

function build_spigot()
{
    pushd ${buildtools_directory}/
    java -jar BuildTools.jar
    popd
}

delete_all_artifacts
copy_latest_bungeecord
cp ./start-bungeecord.sh ${bungeecord_directory}/run.sh
chmod +x ${bungeecord_directory}/run.sh

copy_latest_buildtools
build_spigot

mkdir ${spigot_directory}/
for spigot_jar_filename in ${buildtools_directory}/spigot*.jar; do
    cp $spigot_jar_filename ${spigot_directory}/spigot.jar
done

pushd ${spigot_directory}/
java -jar spigot.jar
sed -i -- 's/eula=false/eula=true/g' eula.txt
popd
