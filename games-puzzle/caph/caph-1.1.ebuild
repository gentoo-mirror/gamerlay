# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games

DESCRIPTION="sandbox physics game"
HOMEPAGE="http://sourceforge.net/projects/caphgame"
SRC_URI="mirror://sourceforge/caphgame/caph/${PN}game-${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libpng
	media-libs/libsdl"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-linux.patch"
}

src_compile() {
	cd src \
	&& CFLAGS="$CFLAGS -I../include" LFLAGS="-lpng -lSDL" ./mkgen > caph.mk \
	&& ./build \
	|| die "build failed"
}

src_install() {
	dogamesbin "bin/caph" || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}"
	doins -r "share/${PN}" || die "doins failed"
	dodoc "doc/${PN}/README" || die "dodoc failed"
	prepgamesdirs
}
