# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: frostwork Exp $

EAPI="2"

inherit games

DESCRIPTION="Alex the Allegator 4 - Plenty of classic platforming in four nice colors guaranteed!"
HOMEPAGE="http://allegator.sourceforge.net"
SRC_URI="mirror://sourceforge/allegator/${PN}src_data.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=" media-libs/aldumb
	media-libs/allegro"

DEPEND="${RDEPEND}"

S="${WORKDIR}"/"${PN}src"

src_prepare(){
	epatch "${FILESDIR}"/${P}-linuxfixes.patch
	epatch "${FILESDIR}"/${P}-homepath.patch
	epatch "${FILESDIR}"/${P}-debian-allegro-4.2.patch
	epatch "${FILESDIR}"/${P}-config.patch
	sed -i \
	-e 's:"\(data/a45.dat[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/shooter.c \
	-e 's:"\(data/a45.dat[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/main.c \
	-e 's:"\(data/sfx[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/main.c \
	-e 's:"\(data/maps.dat[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/main.c \
	-e 's:"\(data/data.dat[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/main.c \
		|| die "sed failed"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	local datadir="${GAMES_DATADIR}"/${PN}
	dogamesbin ${PN}
	insinto "${datadir}"
	doins -r data alex4.ini || die "data install failed"
	dodoc readme.txt
}

pkg_postinst() {
	games_pkg_postinst
}

