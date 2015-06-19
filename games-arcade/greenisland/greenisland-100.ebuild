# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_PN=bubble

inherit eutils games

DESCRIPTION="multiplatform platform puzzle game"
HOMEPAGE="http://maglog.jp/alpha-secret-base/Article717753.html"
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

S=${WORKDIR}/${MY_PN}

src_prepare(){
	rm src/.depend src/*.o
	rm image/player/*.psd
	epatch ${FILESDIR}/"${P}-makefile.patch"
	epatch ${FILESDIR}/"${P}-homedir.patch"
	sed -i -e "s:sound/:"${GAMES_DATADIR}"/"${PN}"/sound/:g" -i src/init.c
	sed -i -e "s:data/:"${GAMES_DATADIR}"/"${PN}"/data/:g" -i src/act.c
	sed -i -e "s:image/:"${GAMES_DATADIR}"/"${PN}"/image/:g" -i src/demo.c
	sed -i -e "s:image/:"${GAMES_DATADIR}"/"${PN}"/image/:g" -i src/ending.c
	sed -i -e "s:image/:"${GAMES_DATADIR}"/"${PN}"/image/:g" -i src/act.c
	sed -i -e "s:image/:"${GAMES_DATADIR}"/"${PN}"/image/:g" -i src/logo.c
	sed -i -e "s:image/:"${GAMES_DATADIR}"/"${PN}"/image/:g" -i src/init.c
	sed -i -e "s:image/:"${GAMES_DATADIR}"/"${PN}"/image/:g" -i src/option.c
	sed -i -e "s:image/:"${GAMES_DATADIR}"/"${PN}"/image/:g" -i src/title.c
	sed -i -e "s:image/:"${GAMES_DATADIR}"/"${PN}"/image/:g" -i src/stageselect.c
}

src_compile() {
	cd src
	emake || die "make failed"
}
src_install() {
	dogamesbin ${PN}
	local datadir="${GAMES_DATADIR}"/"${PN}"
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/"${PN}"
	doins -r sound data image || die
	make_desktop_entry "${PN}" "${PN}"
	dodoc readme_e.txt
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

}