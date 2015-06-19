# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit games

TS=1371673270
MY_PN=StealthBastardDeluxe

DESCRIPTION="The fast-paced, nail-biting antidote to tippy-toed sneaking simulators that the world had so desperately been craving."
HOMEPAGE="http://www.stealthbastard.com/"
SRC_URI="${MY_PN}_${PV}_Linux_${TS}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RESTRICT="fetch strip"

DEPEND=""
RDEPEND="
	${DEPEND}
	x86? (
		dev-libs/openssl
		media-libs/openal
		sys-libs/zlib
		x11-libs/libX11
		x11-libs/libXxf86vm
	)
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-xlibs
	)
"

S="${WORKDIR}/${MY_PN}"
GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

pkg_nofetch() {
	einfo "Please download ${A}"
	einfo "from your personal page in Humble Indie Bundle site"
	einfo "(http://www.humblebundle.com)"
	einfo "and place it to ${DESTDIR}"
}

src_install() {
	insinto "${GAMEDIR}"
	doins -r assets
	exeinto "${GAMEDIR}"
	doexe "${MY_PN}"
	games_make_wrapper "${PN}" "./${MY_PN}" "${GAMEDIR}"
	newicon "assets/icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "${MY_PN}" "${PN}"

	prepgamesdirs
}
