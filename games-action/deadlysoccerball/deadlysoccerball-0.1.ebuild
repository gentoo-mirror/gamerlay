# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils games

MY_PN=deadlysoccerball

DESCRIPTION="space soccer ball shooting missiles around"
HOMEPAGE="http://www-graphics.stanford.edu/courses/cs248-videogame-competition/cs248-05/"
SRC_URI="http://www-graphics.stanford.edu/courses/cs248-videogame-competition/cs248-05/theDeadlySoccerBall.tar.gz"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/mesa"
RDEPEND=""

S=${WORKDIR}/${MY_PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}.diff
	cd src/
	sed -i \
	-e 's:"\(Sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i World.cpp \
	-e 's:"\(Textures/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i World.cpp \
		|| die "sed failed"
	sed -s \
	-e 's/\theDeadlySoccerBall/deadlysoccerball/g' -i Makefile \
		|| die "sed failed"
}

src_install() {
	dogamesbin theDeadlySoccerBall

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r Sounds Textures || die
	newicon "${FILESDIR}"/${PN}.png ${PN}.png
	make_desktop_entry theDeadlySoccerBall ${PN}
	dodoc README.txt
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
