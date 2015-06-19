# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games check-reqs

MY_PN="${PN%-maps}"
DESCRIPTION="Xonotic maps"
HOMEPAGE="http://www.xonotic.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="unofficial"

RDEPEND=""
DEPEND="
	app-arch/unzip
	net-misc/wget
"
S="${WORKDIR}"
RESTRICT="test"

if use unofficial; then
	CHECKREQS_DISK_USR="1G"
else
	CHECKREQS_DISK_USR="155M"
fi

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	check-reqs_pkg_setup
	games_pkg_setup

	ewarn "Downloaded pk3 files will be stored in \"xonotic-maps\" subdirectory of your DISTDIR"
	echo

	if use unofficial; then
		ewarn "You have enabled \"unofficial\" USE flag. Incomplete, unstable or broken maps may be installed."
		echo
	fi
}

src_unpack() {
	# Used git.eclass,v 1.50 as example
	: ${MAPS_STORE_DIR:="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/xonotic-maps"}
	# initial download, we have to create master maps storage directory and play
	# nicely with sandbox
	if [[ ! -d ${MAPS_STORE_DIR} ]] ; then
		addwrite /
		mkdir -p "${MAPS_STORE_DIR}" \
			|| die "can't mkdir ${MAPS_STORE_DIR}."
		export SANDBOX_WRITE="${SANDBOX_WRITE%%:/}"
	fi
	# allow writing into MAPS_STORE_DIR
	addwrite "${MAPS_STORE_DIR}"

	# FETCHCOMMAND from make.globals is example
	local WGET="/usr/bin/wget -t 3 -T 60"
	local base_url="http://beta.xonotic.org/autobuild-bsp/"

	einfo "Downloading lists"
	$WGET -O all_maps.html \
		"${base_url}" || die

	$WGET -O official_maps.html \
		'http://git.xonotic.org/?p=xonotic/xonotic-maps.pk3dir.git;a=tree;f=maps' || die

	grep -e '\.map</a>' official_maps.html |\
		sed -e 's,.*">\([^<]*\).map<\/a>.*,\1,' > official_maps.txt || die
	[ -s official_maps.txt ] || die "List of official maps is empty"
	cp official_maps.txt install_maps.txt || die

	if use unofficial; then
	# For maps not in master branch we need to download fullpk3
		# AllMaps - OfficialMaps = UnofficialMaps
		grep all_maps.html \
			-e '<td class="mapname">' |\
		sed -e 's,.*="mapname">\([^<]*\)<.*,\1,' |\
		sort -u |\
		grep -v -x -e '' \
			-f official_maps.txt |\
		sed -e 's,$,-full,' > unofficial_maps.txt
		[ -s unofficial_maps.txt ] || die "List of unofficial maps is empty"
		cat unofficial_maps.txt >> install_maps.txt
	fi

	latest_pk3_version() {
		# latest builds of maps are above
		latest_version="$(
			grep all_maps.html -m1 \
				-e "href=\"${name%-full}-.*.pk3\">bspk3<" |\
			sed -e "s,.*href=\"${name%-full}-\([^\"]*\).pk3\">bspk3<.*,\1,"
		)"
	}

	validate_pk3() {
		if unzip -t "${1}" > /dev/null; then
			true
		else
			ewarn "\"${1}\" is not valid pk3 file, removing"
			rm -f "${1}" || die
		fi
	}

	# Remove obsolete and broken files from MAPS_STORE_DIR
	# If map becomes official, it changes branch and git hashes in name => no need to check both fullpk3 and bsppk3
	einfo "Cleaning \"${MAPS_STORE_DIR}\""
	for file in "${MAPS_STORE_DIR}"/*; do
		local name="$(
			echo "${file}" |\
			sed -e "s,${MAPS_STORE_DIR}/\([^/]*\)-[0-9a-f]\{40\}-[0-9a-f]\{40\}.pk3$,\1,"
		)"
		local version="$(
			echo "${file}" |\
			sed -e "s,${MAPS_STORE_DIR}/${name}-\([0-9a-f]\{40\}-[0-9a-f]\{40\}\).pk3$,\1,"
		)"
		latest_pk3_version

		if [ "${version}" != "${latest_version}" ]; then
			einfo "\"${file}\" is obsolete, removing"
			rm -f "${file}" || die
		elif [ "x${version}" = "x" ]; then
			ewarn "\"${file}\" has incorrect name, removing"
			rm -f "${file}" || die
		elif [ "x${latest_version}" = "x" ]; then
			ewarn "\"${file}\" is not available in ${base_url}, removing"
			rm -f "${file}" || die
		else
			validate_pk3 "${file}"
		fi
	done

	einfo "Downloading maps"
	while read name; do
		latest_pk3_version
		local file="${name}-${latest_version}.pk3"
		local path="${MAPS_STORE_DIR}/${file}"
		local url="${base_url}${file}"

		if [[ ! -f "${path}" ]]; then
			rm -f "${path}" 2> /dev/null || die
			einfo "Downloading ${file}"
			$WGET "${url}" -O "${path}" || ewarn "downloading \"${url}\" failed"
			validate_pk3 "${path}"
		fi
		echo "${file}" >> install_files.txt
	done < install_maps.txt
}

src_prepare() { :; }
src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto "${GAMES_DATADIR}/${MY_PN}/data"
	while read file; do
		nonfatal doins "${MAPS_STORE_DIR}/${file}" || ewarn "installing \"${file}\" failed"
	done < install_files.txt

	prepgamesdirs
}
