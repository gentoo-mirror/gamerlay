# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/soulfu-1.5.2.ebuild,v 1.1 2008/09/08 13:18:32 frostwork Exp $

EAPI="2"

inherit games

DESCRIPTION="Secret of Ultimate Legendary Fantasy: Unleashed"
HOMEPAGE="http://www.soulfu.com/"
SRC_URI="http://macdonellba.googlepages.com/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[X,opengl]
	media-libs/sdl-net
	media-libs/jpeg
	media-libs/libvorbis
"

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoopaths.patch"
}

src_compile() {
	cd build/unix
	emake || die "emake failed"
}


src_install() {
	dogamesbin build/unix/${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r sdf/datafile.sdf  || die "data install failed"
	doicon "${FILESDIR}"/${PN}.png
	make_desktop_entry ${PN}

	prepgamesdirs
}


