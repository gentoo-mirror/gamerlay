# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils games unpacker

TS="2014-06-09"

DESCRIPTION="Famous 2D shooting game"
HOMEPAGE="http://www.snkplaymore.co.jp/us/games/steam/metalslug3/"
SRC_URI="MetalSlug3-Linux-${TS}.sh"

RESTRICT="fetch strip"
LICENSE="as-is"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	app-arch/unzip
"
RDEPEND="
	media-libs/libsdl2
	media-libs/sdl2-mixer
	sys-libs/zlib
"

S="${WORKDIR}/data"

GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

pkg_nofetch() {
	einfo ""
	einfo "Please buy and download \"${SRC_URI}\" from"
	einfo "HumbleIndieBundle or ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo ""
}

#src_unpack() {
#	unpack_zip "${A}";
#}

src_install() {
	local arch;

	use amd64 && arch="x86_64";
	use x86 && arch="x86";

	# Install documentation
	dodoc noarch/README.linux noarch/LICENSES.txt noarch/ARPHICPL.TXT
	rm noarch/README.linux noarch/LICENSES.txt noarch/ARPHICPL.TXT

	# Install data
	insinto "${GAMEDIR}"
	doins -r noarch/*
	exeinto "${GAMEDIR}"
	doexe "${arch}/MetalSlug3.bin.${arch}"

	# Install icon and desktop file
	newicon "noarch/icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "Metal Slug 3" "${PN}"
	games_make_wrapper "${PN}" "./MetalSlug3.bin.${arch}" "${GAMEDIR}"

	# Setting permissions.
	prepgamesdirs
}
