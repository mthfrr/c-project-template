#!/bin/sh

[ $# -ne 3 ] && echo "Usage: $0 [installation_dir] [git_conf] [archi]" && exit 1

dir="$1"
[ ! -d "$dir" ] && echo "directory not found" && exit 1

if [ -n "$2" ]; then
    [ ! -d "$dir/.git" ] && echo "not a git repo" && exit 1
    cp hooks/* "$dir/.git/hooks/"
    cp gitignore "$dir/.gitignore"
    cp .clang-format "$dir/"
fi

if [ -n "$3" ]; then
    cp Makefile "$dir/Makefile"
    mkdir "$dir/include" "$dir/src" "$dir/test"
    cp -r include "$dir/include"
    cp -r src "$dir/src"
    cp -r "test" "$dir/test"
fi

exit 0
