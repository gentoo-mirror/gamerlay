# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games

DESCRIPTION="Retro-styled open-world 2D puzzle platformer"
HOMEPAGE="http://thelettervsixtim.es/"
SRC_URI="${PN}_${PV}_Linux.tar.gz"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RESTRICT="fetch strip"
IUSE=""

DEPEND=""
RDEPEND="
		media-libs/sdl-mixer
		media-libs/sdl-image:0
		media-libs/libsdl:0
		"

S="${WORKDIR}/${PN}"

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	if use amd64 ; then
		local exe="${PN}_64"
	else
		local exe="${PN}_32"
	fi

	insinto "${dir}"
	exeinto "${dir}"
	doexe "$exe"
	newicon -s 32 "data/icons/32_2.png" "${PN}.png"
	newicon -s 16 "data/icons/16.png" "${PN}.png"
	doins -r data

	games_make_wrapper "${PN}" "./${exe}" "${dir}"
	make_desktop_entry "${PN}" "${PN}" "${PN}"

	prepgamesdirs
}
