# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#inherit eutils

DESCRIPTION="game similar to the PSX game Kula World / Roll Away"
HOMEPAGE="http://cubosphere.sourceforge.net/"
SRC_URI="https://download.sourceforge.net/${PN}/${PN}_beta${PV}_linux_src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/lua:0
	virtual/jpeg
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	media-libs/glew:0
	virtual/opengl
	virtual/glu"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"_beta"${PV}"/src

src_prepare() {
	default
	# respect ${GAMES_DATADIR}
	sed -i -e "s:llua5.1:llua:g" -i Makefile
	sed -i -e "s:PREFIX=/usr/local":PREFIX=/usr":g" -i Makefile
#	sed -i -e "s:BINDIR=\$(PREFIX)/bin:BINDIR=\$(PREFIX)/games/bin:g" -i Makefile
#	sed -i -e "s:DATADIR=\$(PREFIX)/share/cubosphere:DATADIR="${GAMES_DATADIR}"/"${PN}":g" -i Makefile
	sed -i -e "s:install\: all:install\::g" -i Makefile
}
