# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-apps/dunan/dunan-0.5.ebuild,v 1.0 2010/03/03 11:52:29 by frostwork Exp $

EAPI="2"

inherit eutils

DESCRIPTION="animated 3D MMD models on the desktop"
HOMEPAGE="http://www.frostworx.de"
SRC_URI="http://www.frostworx.de/dunan/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="sdl -fmod"

RDEPEND="media-libs/ftgl
	media-libs/libmmd
	virtual/opengl
	sdl? ( media-libs/sdl-mixer )
	fmod? ( =media-libs/fmod-3* )"
DEPEND="${RDEPEND}"

src_prepare() {
	if use sdl && use fmod ; then
	ewarn "both sdl and fmod useflag not possible!"
	die "disable fmod useflag in favour of sdl-mixer"
	fi
	if use fmod; then
	echo "SOUNDFLAGS = -DFMOD -DMUSIC" >> Makefile
	echo "SOUNDLIBS  = -lfmod" >> Makefile
	fi
	if use sdl; then
	echo "SOUNDFLAGS = -DSDLMIXER -DMUSIC `sdl-config --cflags`" >> Makefile
	echo "SOUNDLIBS  = `sdl-config --libs` -lSDL_mixer" >> Makefile
	fi
}

src_install() {
	dobin ${PN}
	newicon ${PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN}
	dodoc README
}
