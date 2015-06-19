# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit games

TIMESTAMP_x86="1346296515"
TIMESTAMP_amd64="1346776333"

DESCRIPTION="Defend and control the field using a diverse selection of upgradeable towers."
HOMEPAGE="http://subatomicstudios.com/games/fieldrunners/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch strip"
IUSE=""

SRC_URI="
	x86? ( ${PN}-${PV}-32bit-${TIMESTAMP_x86}.tar.gz )
	amd64? ( ${PN}-linux-${PV}-64bit-${TIMESTAMP_amd64}.tar.gz )
"

RDEPEND="
	media-libs/alsa-lib
	media-libs/freeglut
	media-libs/libogg
	media-libs/libvorbis
	virtual/opengl
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXxf86vm

"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

MY_PN="${PN/f/F}"

DOCS=( README )

pkg_nofetch() {
        ewarn
        ewarn "Place ${A} to ${DISTDIR}"
        ewarn
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	local arch;
	use amd64 && arch="x86_64" || arch="x86"

	insinto "${dir}"
	doins -r "${PN}/Data"

	exeinto "${dir}"
	doexe "${PN}/${MY_PN}"

	games_make_wrapper "${PN}" "./${MY_PN}" "${dir}"
	doicon "${FILESDIR}/${PN}.png" || die
	make_desktop_entry "${PN}" "${MY_PN}"

	prepgamesdirs
}
