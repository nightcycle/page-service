#!/bin/sh
is_serve=false
for arg in "$@"
do
	if [ "$arg" = "--serve" ]; then
		is_serve=true
	fi
done

ROJO_PROJECT="dev.project.json"
aftman install
set -e
sh scripts/download-types.sh
sh scripts/wally-install.sh "$ROJO_PROJECT"
# npm i --package-lock-only
# sh scripts/npm-install.sh
if [ "$is_serve" = true ]; then
	sh scripts/build.sh "$ROJO_PROJECT" --serve
else
	sh scripts/build.sh "$ROJO_PROJECT"
fi
