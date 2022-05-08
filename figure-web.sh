#!/bin/bash
num=$#
if [ $num -lt 1 ]; then
    echo "指定部署的版本号"
    exit 0
fi
arg=$1
name="figure"
dir=/var/www/$name
case $arg in
clean | C)
    rm $dir -r
    echo "$dir 清理成功!"
    ;;
*)
    if [ ! -d "$dir" ]; then
        mkdir ${dir}
        echo "已创建目录$dir"
    fi
    version=$arg
    file=./figure-web-$version.tar
    if [ ! -f "$file" ]; then
        echo "当前目录下不存在$file"
    else
        tar -xf figure-web-$version.tar -C /var/www/$name/
        service nginx reload
        echo "figure-web-$version 部署成功!位置$dir"
    fi
    ;;
esac
