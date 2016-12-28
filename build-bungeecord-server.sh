#!/bin/bash

set -euo pipefail
#IFS=$'\n\t'

set -x

shopt -s nullglob

#install java
#install git?
#install mysql
#sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5072E1F5
#echo "deb http://repo.mysql.com/apt/ubuntu/ trusty mysql-5.7" >> /etc/apt/sources.list.d/mysql.list
#sudo apt-get update -y
#sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password bla'
#sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password bla'
#sudo apt-get -y install mysql-server
#sudo apt-get install mysql-server -y

bungeecord_directory_name="bungeecord"
buildtools_directory_name="buildtools"
spigot_directory_name="spigot"
plugin_directory_name="plugins"

function delete_all_artifacts()
{
    rm -rf artifacts/
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
        wget ${bungeecord_file} --directory-prefix=artifacts/${bungeecord_directory_name}/
    done
}

function copy_latest_buildtools()
{
    wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar --directory-prefix=artifacts/${buildtools_directory_name}/
}

function copy_plugins()
{
    declare -A plugin_urls
    plugin_urls=(['PermissionsEx.jar']='https://dev.bukkit.org/projects/permissionsex/files/909154/download'
    ['Essentials.jar']='https://dev.bukkit.org/projects/essentials/files/780922/download' )
    mkdir -p artifacts/${plugin_directory_name}/
    for plugin_name in ${!plugin_urls[*]}; do
        wget ${plugin_urls[$plugin_name]} --output-document=artifacts/${plugin_directory_name}/${plugin_name}
    done
}

function build_spigot()
{
    pushd artifacts/${buildtools_directory_name}/
    java -jar BuildTools.jar
    popd
}

delete_all_artifacts
copy_latest_bungeecord
cp ./start-bungeecord.sh artifacts/${bungeecord_directory_name}/run.sh
chmod +x artifacts/${bungeecord_directory_name}/run.sh

copy_latest_buildtools
build_spigot

mkdir artifacts/${spigot_directory_name}/
for spigot_jar_filename in artifacts/${buildtools_directory_name}/spigot*.jar; do
    cp $spigot_jar_filename artifacts/${spigot_directory_name}/spigot.jar
done

pushd artifacts/${spigot_directory_name}/
java -jar spigot.jar
sed -i -- 's/eula=false/eula=true/g' eula.txt
popd

cp start-spigot.sh artifacts/${spigot_directory_name}/run.sh

copy_plugins
