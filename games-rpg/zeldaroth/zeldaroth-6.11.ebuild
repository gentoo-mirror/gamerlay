# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/zeldaroth/zeldaroth-6.11.ebuild,v 1.0 2010/10/10 09:17:32 frostwork Exp $

EAPI="2"

MY_PN="ZeldaROTH_US-src-linux"

inherit games

DESCRIPTION="The Legend of Zelda - Return of the Hylian"
HOMEPAGE="http://www.zeldaroth.fr/us/zroth.php"
SRC_URI="http://www.zeldaroth.fr/us/files/ROTH/Linux/${MY_PN}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl
	media-libs/sdl-gfx
	media-libs/sdl-image
	media-libs/sdl-mixer[midi]
"

src_prepare() {
	epatch "${FILESDIR}/${PN}-homedir.patch"
	sed -i -e "s:ZeldaROTH_US:"${PN}":g" -i ${MY_PN}/src/Makefile
	sed -i -e "s:CFLAGS  =:#CFLAGS  =:g" -i ${MY_PN}/src/Makefile
	for i in `find ${MY_PN}/src -name *.cpp`; do sed -i "$i" -e "s:data/:"${GAMES_DATADIR}"/"${PN}/data/":g"; done
}

src_compile() {
	cd ${MY_PN}/src
	emake || die "emake failed"
}


src_install() {
	dogamesbin ${MY_PN}/src/${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r ${MY_PN}/src/data  || die "data install failed"
	newicon ${MY_PN}/src/data/images/logos/triforce.ico ${PN}.png
	make_desktop_entry ${PN}

	prepgamesdirs
}


