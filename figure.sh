#!/bin/bash
num=$#
if [ $num -lt 2 ]; then
    echo "须指定模式和版本号"
    exit 0
fi
mode=$1
version=$2
name="figure"
group="bootapp"
dir=/var/$name
case $mode in
clean | C)
    chattr -i /var/$name/$name-$version.jar
    rm /etc/init.d/$name
    rm /var/$name/$name-$version.jar
    echo "$version 清理成功!"
    ;;
add | A)
    groupadd $group
    useradd -g bootapp -s /usr/sbin/nologin $name
    mkdir /var/$name
    chown $name:$group /var/$name
    cp application.properties /var/$name/application.properties
    chown $name:$group /var/$name/application.properties
    chmod 400 /var/$name/application.properties
    cp $name-$version.jar /var/$name/
    chown $name:$group /var/$name/$name-$version.jar
    chmod 500 /var/$name/$name-$version.jar
    chattr +i /var/$name/$name-$version.jar
    rm /etc/init.d/$name
    ln -s /var/$name/$name-$version.jar /etc/init.d/$name
    update-rc.d $name defaults
    service $name start
    systemctl daemon-reload
    service $name restart
    echo "$version 添加成功!"
    ;;
update | U)
    cp application.properties /var/$name/application.properties
    chattr -i /var/$name/$name-$version.jar
    cp $name-$version.jar /var/$name/
    chattr +i /var/$name/$name-$version.jar
    rm /etc/init.d/$name
    ln -s /var/$name/$name-$version.jar /etc/init.d/$name
    systemctl daemon-reload
    service $name restart
    echo "$version 更新成功!"
    ;;
*)
    echo "模式不正确"
    exit 0
    ;;
esac