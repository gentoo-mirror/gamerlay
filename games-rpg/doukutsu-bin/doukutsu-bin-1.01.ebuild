# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit games

DESCRIPTION="Side-scrolling platformer written by StudioPixel (English translation)"
HOMEPAGE="http://www.cavestory.org"
SRC_URI="http://www.archive.org/download/CavestorydoukutsuForLinuxV1.01/linuxdoukutsu-1.01.tar.bz2"
#SRC_URI="http://www.scibotic.com/uploads/2008/04/linuxdoukutsu-${PV}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RESTRICT="strip"

RDEPEND="media-libs/libsdl[X]"

S=${WORKDIR}/linuxDoukutsu-${PV}

src_install() {
	dogamesbin doukutsu || die dogamesbin failed

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data Config.dat DoConfig.exe || die "doins failed"

	exeinto "${GAMES_DATADIR}"/${PN}
	doexe doukutsu.bin || die "doexe failed"

	dosym "${GAMES_STATEDIR}"/${PN}/Profile.dat "${GAMES_DATADIR}"/${PN}/Profile.dat || die "dosym failed"

	games_make_wrapper doukutsu ./doukutsu.bin "${GAMES_DATADIR}"/${PN} "${GAMES_DATADIR}"/${PN}

	dodoc doc/* || die "dodoc failed"

	touch Profile.dat || die "unable to create empty Profile.dat?"
	insopts -m 660
	insinto "${GAMES_STATEDIR}"/${PN}
	doins Profile.dat || die "doins failed"

	prepgamesdirs
}

pkg_postinst() {
	elog "This port does not provide a configuration tool for Config.dat."
	elog "The original DoConfig.exe is provided (if you can use wine),"
	elog "or help for configuring it manually is provided in:"
	elog "/usr/share/doc/${P}/configfileformat.txt"

	elog "If you need to back up your save file for any reason,"
	elog "it is located at /var/games/doukutsu-bin/Profile.dat"
}
