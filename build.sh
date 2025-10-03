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
  cd $projectdir && cp $projectdir/dep/lua-5.3.6/src/*.h $projectdir/src
fi

cd $projectdir/dep/lua-5.3.6 && make linux && make local

cd $projectdir && cp $projectdir/dep/lua-5.3.6/src/*.h $projectdir/src

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
go mod tidy
go build -o plua ./plua.go
go build -o png ./png.go

chmod a+x pprof
chmod a+x *.pl
chmod a+x *.sh
