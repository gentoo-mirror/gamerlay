# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games check-reqs git-2

MY_PN="${PN%-data}"
DESCRIPTION="Xonotic data files"
HOMEPAGE="http://www.xonotic.org/"
BASE_URI="git://git.xonotic.org/${MY_PN}/${MY_PN}"
EGIT_REPO_URI="${BASE_URI}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+client +convert low +zip"

RDEPEND=""
DEPEND="
	dev-lang/perl
	~games-util/gmqcc-9999
	convert? (
		media-gfx/imagemagick[jpeg,png]
		low? ( media-sound/vorbis-tools )
	)
	zip? ( app-arch/p7zip )
"
RESTRICT="test"

if use !client; then
	CHECKREQS_DISK_BUILD="3000M"
	CHECKREQS_DISK_USR="320M"
else
	if use zip; then
		CHECKREQS_DISK_BUILD="3850M"
		CHECKREQS_DISK_USR="1830M"
	else
		CHECKREQS_DISK_BUILD="7020M"
		CHECKREQS_DISK_USR="3520M"
	fi
fi

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	ewarn "You need at least 4 Gb diskspace for distfiles."
	check-reqs_pkg_setup
	games_pkg_setup

	if use convert; then
		ewarn "cached-converter.sh will use \"xonotic-cached-converter\" subdirectory of your DISTDIR"
		echo
	fi

	if use !client; then
		ewarn "You have disabled client USE flag, only files for server will be installed."
		ewarn "This feature is experimental, if anything goes wrong, contact the maintainer."
		echo
	fi
}

src_unpack() {
	# root
	git-2_src_unpack

	# Data
	git_pk3_unpack() {
		EGIT_REPO_URI="${BASE_URI}-${1}.pk3dir.git" \
		EGIT_SOURCEDIR="${S}/data/${MY_PN}-${1}.pk3dir" \
		git-2_src_unpack
	}
	git_pk3_unpack data
	git_pk3_unpack maps
	# needed only for client
	if use client; then
		git_pk3_unpack music
		git_pk3_unpack nexcompat
	else
		rm -rf "${S}"/data/font-*.pk3dir || die
	fi
}

src_prepare() {
	# Data
	if use !client; then
		pushd data || die
		rm -rf \
			xonotic-data.pk3dir/gfx \
			xonotic-data.pk3dir/particles \
			xonotic-data.pk3dir/sound/cyberparcour01/rocket.txt \
			xonotic-data.pk3dir/textures \
			xonotic-maps.pk3dir/textures \
			|| die
		rm -f \
			$(find -type f -name '*.jpg') \
			$(find -type f -name '*.png' ! -name 'sky??.png') \
			$(find -type f -name '*.svg') \
			$(find -type f -name '*.tga') \
			$(find -type f -name '*.wav') \
			$(find -type f -name '*.ogg') \
			$(find -type f -name '*.mp3') \
			$(find -type f -name '*.ase') \
			$(find -type f -name '*.map') \
			$(find -type f -name '*.zym') \
			$(find -type f -name '*.obj') \
			$(find -type f -name '*.blend') \
			|| die
		find -type d \
			-exec rmdir '{}' &>/dev/null \; || die
		sed -i \
			-e '/^qc-recursive:/s/menu.dat//' \
			xonotic-data.pk3dir/qcsrc/Makefile || die
		popd || die
	fi
}

src_compile() {
	# Data
	cd data || die
	pushd xonotic-data.pk3dir || die
	emake \
		QCC="${EPREFIX}/usr/bin/gmqcc" \
		QCCFLAGS_WATERMARK=''
	popd || die

	if use convert; then
		# Used git.eclass,v 1.50 as example
		: ${CACHE_STORE_DIR:="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/xonotic-cached-converter"}
		# initial download, we have to create master maps storage directory and play
		# nicely with sandbox
		if [[ ! -d ${CACHE_STORE_DIR} ]] ; then
			addwrite "${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}" # git.eclass was used, DISTDIR sure exists
			mkdir -p "${CACHE_STORE_DIR}" \
				|| die "can't mkdir ${CACHE_STORE_DIR}."
			export SANDBOX_WRITE="${SANDBOX_WRITE%%:/}"
		fi
		# allow writing into CACHE_STORE_DIR
		addwrite "${CACHE_STORE_DIR}"

		if use low; then
			export jpeg_qual_rgb=80
			export jpeg_qual_a=97
			export do_ogg=true
			export ogg_qual=1
		else
			export jpeg_qual_rgb=97
			export jpeg_qual_a=99
			export do_ogg=false
		fi

		for i in data music maps nexcompat; do
			einfo "Converting ${i}"
			find xonotic-${i}.pk3dir -type f -print0 |
				git_src_repo="${S}"/data/xonotic-${i}.pk3dir \
				CACHEDIR="${CACHE_STORE_DIR}" \
				do_jpeg=true                 \
				do_dds=false                 \
				del_src=true                 \
				xargs -0 "${S}"/misc/tools/cached-converter.sh || die
		done
	fi

	einfo "Removing useless files"
	rm -rvf \
		$(find -name '.git*') \
		$(find -type d -name '.svn') \
		$(find -type d -name 'qcsrc') \
		$(find -type f -name '*.sh') \
		$(find -type f -name '*.pl') \
		$(find -type f -name 'Makefile') \
		|| die

	if use zip; then
		for d in *.pk3dir; do
			pushd "${d}" || die
			einfo "Compressing ${d}"
			7za a -tzip "../${d%dir}" . || die
			popd || die
			rm -rf "${d}" || die
		done
	fi
}

src_install() {
	# Data
	insinto "${GAMES_DATADIR}/${MY_PN}"
	doins -r data

	prepgamesdirs
}
