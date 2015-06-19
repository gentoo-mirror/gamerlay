# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/dave/dave-1.0.ebuild,v 1.1 2008/09/02 13:31:40 frostwork Exp $

EAPI="2"

inherit games

DESCRIPTION="Dave - The ordinary spaceman"
HOMEPAGE="http://thykka.ath.cx/dave/?page=115"
SRC_URI="http://tyk-ry.utu.fi/~jupet/${PN}_sources.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/opengl
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/libogg
	media-libs/libvorbis
	media-libs/glew"
DEPEND="${RDEPEND}
	dev-util/cmake"

S="${WORKDIR}"/"${PN}"

src_prepare(){
	epatch "${FILESDIR}"/${P}-data.patch
	epatch "${FILESDIR}"/${P}-gcc43.patch
}

src_compile() {
	# dave does not allow out tree build
	cmake .
	emake || die "make failed"
}

src_install() {
	local datadir="${GAMES_DATADIR}"/${PN}

	dogamesbin ${PN}
	newgamesbin editor ${PN}-editor
	dodir ${datadir}
	insinto "${datadir}"
	doins -r audio graphics levels  || die "data install failed"
	insinto "${GAMES_SYSCONFDIR}"/${PN}
	newins ${PN}.conf.sample ${PN}.conf || die "conf install failed"

}
