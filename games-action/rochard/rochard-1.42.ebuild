# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit games multilib

TIMESTAMP="1371746492"

# Hope, this is temporary. Dunno why they using a second-biger TS for x86 tarball
TIMESTAMP_X86_TEMP="1371746493"

MY_PN="Rochard"

X86_URI="${MY_PN}_v${PV}_Linux_x86_${TIMESTAMP_X86_TEMP}.tar.gz"
AMD64_URI="${MY_PN}_v${PV}_Linux_x64_${TIMESTAMP}.tar.gz"
HT_X86_URI="${MY_PN}_Hard_Times_v${PV}_Linux_x86_${TIMESTAMP}.tar.gz"
HT_AMD64_URI="${MY_PN}_Hard_Times_v${PV}_Linux_x64_${TIMESTAMP}.tar.gz"

DESCRIPTION="A side-scrolling platformer packed with action, gravity-bending puzzles, space bandits and absurdly powerful astro-mining tools."
HOMEPAGE="http://rochardthegame.com/"

SLOT="0"
LICENSE="Rochard-EULA"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch"
IUSE="dlc"

SRC_URI="
	!dlc? (
		x86? ( ${X86_URI} )
		amd64? ( ${AMD64_URI} )
	)
	dlc? (
		x86? ( ${HT_X86_URI} )
		amd64? ( ${HT_AMD64_URI} )
	)
"

RDEPEND="virtual/opengl
	app-arch/gzip
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}";
	local bit;

	use x86 && bit=86;
	use amd64 && bit=64;

	S="${WORKDIR}/${MY_PN}_x${bit}"
	cd "${S}"

	insinto "${dir}"
	doins -r "${MY_PN}_Data"
	exeinto "${dir}"
	doexe "${MY_PN}"

	games_make_wrapper "${PN}" "./${MY_PN}" "${dir}" "${dir}"
	newicon "${FILESDIR}/${MY_PN}.png" "${PN}.png" || die
	make_desktop_entry "${PN}" "${MY_PN}" "${MY_PN}"

	dodoc README.txt changelog.txt
	prepgamesdirs
}
