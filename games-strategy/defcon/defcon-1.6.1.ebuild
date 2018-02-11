# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils unpacker versionator

MY_PV=$(replace_version_separator 2 '-')

DESCRIPTION="http://www.introversion.co.uk/defcon/"
HOMEPAGE="Global thermonuclear war simulation with multiplayer support"
BASE_URI="https://www.introversion.co.uk/defcon/downloads/${PN}_${MY_PV}___ARCH__.deb"
SRC_URI="
	x86? ( ${BASE_URI/__ARCH__/i386} )
	amd64? ( ${BASE_URI/__ARCH__/amd64} )
"

LICENSE="Introversion"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RESTRICT="strip"
IUSE=""

DEPEND=""
RDEPEND="
		${DEPEND}
		virtual/glu
		media-libs/libogg
		media-libs/libvorbis
		media-libs/libsdl:0
"

S="${WORKDIR}"

src_install() {
	local dir="/opt/${PN}"
	local exe="${PN}.bin.${ARCH/amd/x86_}"
	#use x86 && exe="${PN}.bin.x86"
	#use amd64 && exe="${PN}.bin.x86_64"

	insinto "${dir}"
	exeinto "${dir}"
	cd "${S}/usr/local/games/${PN}"
	doexe "${exe}"
	doicon "${PN}.png"
	dodoc "linux.txt" "license.txt"
	doins sounds.dat main.dat

	make_wrapper "${PN}" "./${exe}" "${dir}"
	make_desktop_entry "${PN}" "${PN}" "${PN}"
}
