# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils unpacker

HOMEPAGE="http://www.introversion.co.uk/defcon/"
DESCRIPTION="Global thermonuclear war simulation with multiplayer support"
SRC_URI="
	x86? ( https://www.introversion.co.uk/defcon/downloads/${PN}_$(ver_rs 2 -)_i386.deb )
	amd64? ( https://www.introversion.co.uk/defcon/downloads/${PN}_$(ver_rs 2 -)_amd64.deb )
"

LICENSE="Introversion"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"
IUSE=""

RDEPEND="
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
