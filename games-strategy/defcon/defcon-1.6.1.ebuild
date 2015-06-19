# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games
inherit versionator

MY_PV=$(replace_version_separator 2 '-')

DESCRIPTION="http://www.introversion.co.uk/defcon/"
HOMEPAGE="Global thermonuclear war simulation with multiplayer support"
SRC_URI="${PN}_${MY_PV}_amd64.tar.gz"

LICENSE="Introversion"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="fetch strip"
IUSE=""

DEPEND=""
RDEPEND="
		virtual/glu
		media-libs/libogg
		media-libs/libvorbis
		media-libs/libsdl:0
		"

S="${WORKDIR}/${PN}"

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	local exe="${PN}.bin.x86_64"

	insinto "${dir}"
	exeinto "${dir}"
	doexe "${exe}"
	doicon "${PN}.png"
	doins sounds.dat main.dat

	games_make_wrapper "${PN}" "./${exe}" "${dir}"
	make_desktop_entry "${PN}" "${PN}" "${PN}"

	prepgamesdirs
}
