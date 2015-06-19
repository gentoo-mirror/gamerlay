# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_PN=gnp

inherit eutils games

DESCRIPTION="multiplatform platform puzzle game"
HOMEPAGE="http://maglog.jp/alpha-secret-base/Article243291.html"
SRC_URI="http://www.geocities.jp/dij4121/alpha/data/${MY_PN}_${PV}.zip"
LICENSE="Yawaraka-flexible"
KEYWORDS="~x86"
IUSE=""
SLOT="0"

RDEPEND="media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-gfx
	media-libs/sdl-mixer[vorbis]"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_PN}_${PV}

src_prepare(){
	rm .depend
	epatch ${FILESDIR}/"${P}-makefile.patch"
	epatch ${FILESDIR}/"${P}-homedir.patch"
	sed -i -e "s:\.\./:"${GAMES_DATADIR}"/"${PN}"/:g" -i data/0/bmp.txt
	sed -i -e "s:\.\./:"${GAMES_DATADIR}"/"${PN}"/:g" -i data/1/bmp.txt
	sed -i -e "s:\.\./:"${GAMES_DATADIR}"/"${PN}"/:g" -i data/2/bmp.txt
	sed -i -e "s:sound/:"${GAMES_DATADIR}"/"${PN}"/sound/:g" -i init.c
	sed -i -e "s:data/:"${GAMES_DATADIR}"/"${PN}"/data/:g" -i act.c
	sed -i -e "s:image/:"${GAMES_DATADIR}"/"${PN}"/image/:g" -i act.c
	sed -i -e "s:image/:"${GAMES_DATADIR}"/"${PN}"/image/:g" -i logo.c
	sed -i -e "s:image/:"${GAMES_DATADIR}"/"${PN}"/image/:g" -i init.c
	sed -i -e "s:image/:"${GAMES_DATADIR}"/"${PN}"/image/:g" -i ending.c
	sed -i -e "s:image/:"${GAMES_DATADIR}"/"${PN}"/image/:g" -i option.c
	sed -i -e "s:image/:"${GAMES_DATADIR}"/"${PN}"/image/:g" -i title.c
}

src_compile() {
	emake -f Makefile.linux || die "make failed"
}
src_install() {
	dogamesbin ${PN}
	local datadir="${GAMES_DATADIR}"/"${PN}"
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/"${PN}"
	doins -r sound data image || die
	newicon "${MY_PN}_icon_alpha.png" "${PN}.png"
	make_desktop_entry "${PN}" "${PN}"
	dodoc readme.txt
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

}