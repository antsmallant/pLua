#! /bin/sh
set -e

dir=$(cd `dirname $0`;pwd)
projectdir=$dir
builddir="$projectdir/build"
rundir="$projectdir/bin"
luadir="$projectdir/dep/lua-5.3.6"
lua="$projectdir/dep/lua-5.3.6.tar.gz"

if [ -f "$lua" ] && [ ! -d "$luadir" ]; then
  cd $projectdir/dep && tar zxvf $lua
  #cd $projectdir && cp $projectdir/dep/lua-5.3.6/src/*.h $projectdir/src
fi

if [ ! -d "$rundir" ]; then
  mkdir -p $rundir && cd $rundir
fi

if [ -d "$builddir" ]; then
  rm $builddir -rf
  mkdir -p $builddir && cd $builddir
else
  mkdir -p $builddir && cd $builddir
fi

cmake ../
make

cd ../tools
# 使用 Go Modules 并设置代理以避免 golang.org/x 访问失败
export GOPROXY=${GOPROXY:-https://goproxy.cn,direct}
if [ ! -f "go.mod" ]; then
  go mod init plua-tools
fi
go mod tidy
go build plua.go
go build png.go

chmod a+x pprof
chmod a+x *.pl
chmod a+x *.sh
