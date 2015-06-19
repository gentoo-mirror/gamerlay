# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils games

DESCRIPTION="a 3D physics platform game - won the grand prize in the 10th annual CS 248 video game competition!"
HOMEPAGE="http://cs.stanford.edu/people/mbostock/polly/"
SRC_URI="http://graphics.stanford.edu/~mbostock/polly-src.zip"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	virtual/opengl
	media-libs/sdl-image
	media-libs/glew
	media-libs/freeglut
	dev-libs/tinyxml
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN/b-gone/src}

src_prepare(){
	epatch "${FILESDIR}"/"${PV}"-libs.patch \
		"${FILESDIR}"/"${PV}"-Makefile.patch

	cd "${S}"
	sed -i -e "s:resources/:"${GAMES_DATADIR}"/"${PN}"/resources/:" -i resource.cpp
}

src_install() {
	dogamesbin ${PN} || die "dogamesbin ${PN} failed"

	local datadir="${GAMES_DATADIR}"/"${PN}"
	dodir ${datadir}
	insinto "${datadir}"
	doins -r resources || die "doins resources failed"

	newicon "${FILESDIR}"/"${PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "${PN}"
	dodoc README* || die
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}

