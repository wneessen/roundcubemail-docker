#!/bin/bash
# set -eu

declare -A CMD=(
	[fpm-alpine]='php-fpm'
)

declare -A BASE=(
	[fpm-alpine]='alpine'
)

VERSION="${1:-$(curl -fsS https://roundcube.net/VERSION.txt)}"

#set -x
echo "Generating files for version $VERSION..."

for variant in fpm-alpine; do
	dir="$variant"
	mkdir -p "$dir"

	template="templates/Dockerfile-${BASE[$variant]}.templ"
	cp templates/docker-entrypoint.sh "$dir/docker-entrypoint.sh"
	cp templates/php.ini "$dir/php.ini"
	sed -E -e '
		s/%%VARIANT%%/'"$variant"'/;
		s/%%VERSION%%/'"$VERSION"'/;
		s/%%CMD%%/'"${CMD[$variant]}"'/;
	' $template | tr '¬' '\n' > "$dir/Dockerfile"

	echo "✓ Wrote $dir/Dockerfile"
done
echo "Done."
