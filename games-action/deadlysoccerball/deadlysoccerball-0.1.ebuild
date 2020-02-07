# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

DESCRIPTION="space soccer ball shooting missiles around"
HOMEPAGE="http://www-graphics.stanford.edu/courses/cs248-videogame-competition/cs248-05/"
SRC_URI="http://www-graphics.stanford.edu/courses/cs248-videogame-competition/cs248-05/theDeadlySoccerBall.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/mesa"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}/${P}.patch" )

src_prepare() {
	default

	sed -i \
	-e 's:"\(Sounds/[^"]*\)":"/usr/share/'${PN}'/\1":g' -i src/World.cpp \
	-e 's:"\(Textures/[^"]*\)":"/usr/share/'${PN}'/\1":g' -i src/World.cpp \
		|| die "sed failed"
	sed -s \
	-e 's/\theDeadlySoccerBall/deadlysoccerball/g' -i src/Makefile \
		|| die "sed failed"
}

src_install() {
	dobin theDeadlySoccerBall

	insinto "/usr/share/${PN}"
	doins -r Sounds Textures || die
	doicon "${FILESDIR}/${PN}.png"
	make_desktop_entry theDeadlySoccerBall ${PN}
	dodoc README.txt
}
