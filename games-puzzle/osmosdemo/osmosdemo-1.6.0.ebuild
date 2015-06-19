# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils games

MY_PN="OsmosDemo"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Play as a single-celled organism absorbing others"
HOMEPAGE="http://www.hemispheregames.com/osmos/"
SRC_URI="http://www.hemispheregames.com/blog/wp-content/uploads/2010/04/${MY_P}.tar.gz"

LICENSE="OSMOS"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="mirror strip"
PROPERTIES="interactive"

RDEPEND="virtual/opengl
    virtual/glu
    x11-libs/libX11
    media-libs/freetype:2
    sys-libs/glibc
    media-libs/openal
    media-libs/libvorbis"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

GAMES_CHECK_LICENSE="yes"

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	exeinto "${dir}"
	doexe ${MY_PN} ${MY_PN}.bin{32,64} || die "doexe"
	dohtml readme.html
	doins -r Fonts/ Sounds/ Textures/ Osmos-* *.cfg || die "doins failed"
	newicon Icons/256x256.png ${PN}.png

	games_make_wrapper ${PN} ./${MY_PN} "${dir}"
	make_desktop_entry ${PN} "Osmos Demo"

	prepgamesdirs
}
