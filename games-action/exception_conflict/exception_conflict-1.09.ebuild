# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils games

DESCRIPTION="outstanding shmup using opengl and sdl"
HOMEPAGE="http://i-saint.skr.jp/exception_conflict/"
SRC_URI="http://xes.plala.jp/demo4/g4033/${PN}.zip
	http://i-saint.skr.jp/exception_conflict/update/109.zip"

LICENSE="${PN}"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/ftgl
	media-libs/freetype
	media-libs/libpng
	dev-ruby/rake
	virtual/opengl
	dev-libs/boost
	media-libs/glew
	media-libs/freeglut
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}/src

src_unpack() {
	unpack ${A}
	cp "${WORKDIR}"/src/src.zip "${S}"
	cd "${S}"
	unzip src.zip
}

src_prepare(){
	cd "${S}"/src
	epatch "${FILESDIR}"/${P}-*
	sed -i -e "s:resource/:"${GAMES_DATADIR}"/"${PN}"/resource/:" -i app.cc
	sed -i -e "s:resource/:"${GAMES_DATADIR}"/"${PN}"/resource/:" -i resource.cc

}

src_compile() {
	cd "${S}"/src
	rake || die
}

src_install() {
	dogamesbin "${S}"/src/${PN} || die "dogamesbin ${PN} failed"

	local datadir="${GAMES_DATADIR}"/"${PN}"
	dodir ${datadir}
	insinto "${datadir}"
	doins -r "${WORKDIR}"/${PN}/resource || die "doins resource failed"

	newicon "${FILESDIR}"/"${PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "${PN}"
	dodoc "${WORKDIR}"/${PN}/copyrights || die
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
