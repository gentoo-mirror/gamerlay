# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils games unpacker

TS="1381858841"

DESCRIPTION="Legendary Worms™ Game. SinglePlayer-only."
HOMEPAGE="http://www.team17.com/games/worms/worms-reloaded/"
SRC_URI="WormsReloaded_Linux_${TS}.sh"

RESTRICT="fetch strip"
LICENSE="as-is"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-sdl
	)
	x86? (
		media-libs/libsdl2
		media-libs/openal
		sys-libs/zlib
	)
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

src_unpack() {
	unpack_zip "${A}";
}

src_prepare() {
	rm -r "${S}/x86/lib/libopenal.so.1"
}

src_install() {
	# Install documentation
	dodoc noarch/README.linux
	rm noarch/README.linux

	# Install data
	insinto "${GAMEDIR}"
	doins -r noarch/* x86/lib
	exeinto "${GAMEDIR}"
	doexe x86/WormsReloaded.bin.x86

	# Install icon and desktop file
	newicon "x86/WormsReloaded.png" "${PN}.png"
	make_desktop_entry "${PN}" "Worms Reloaded" "${PN}"
	games_make_wrapper "${PN}" "./WormsReloaded.bin.x86" "${GAMEDIR}" "${GAMEDIR}/lib"

	# Setting permissions.
	prepgamesdirs
}
