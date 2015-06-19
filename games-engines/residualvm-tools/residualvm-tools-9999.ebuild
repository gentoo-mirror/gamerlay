# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games git-2

DESCRIPTION="Utilities for the GrimE game engine"
HOMEPAGE="http://www.residualvm.org/"
#SRC_URI=""
EGIT_REPO_URI="https://github.com/residualvm/residualvm-tools"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="flac mad vorbis"

DEPEND="flac? ( media-libs/flac )
	mad? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis )
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_configure() {
	# econf can't work here, configure script not have some options
	./configure \
		--enable-release --disable-tremor \
		--prefix="${GAMES_PREFIX}" \
		--datadir="${GAMES_DATADIR}" \
		$(use_enable flac) \
		$(use_enable mad) \
		$(use_enable vorbis) \
	|| die "configure failed"
}

src_install() {
	local f
	for f in $(find tools -type f -perm +1 -print); do
		newgamesbin $f ${PN}-${f##*/} || die "newgamesbin $f failed"
	done
	prepgamesdirs
}
