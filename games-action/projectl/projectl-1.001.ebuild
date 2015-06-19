# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=projectL
MY_PV=${PV//./}

DESCRIPTION="Sword action STG inspired by projectN developed by D.K"
HOMEPAGE="http://www.mb.ccnw.ne.jp/hiz/game/projectL/index_en.html"
SRC_URI="http://www.mb.ccnw.ne.jp/hiz/game/projectL/${MY_PN}_${MY_PV}.zip
	mirror://debian/pool/main/p/${PN}/${PN}_${PV}.dfsg1-2.diff.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer
	dev-libs/libbulletml"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}_${MY_PV}

src_prepare(){
	# using frostworks patches with debian's cleanups and minor patches
	epatch "${WORKDIR}"/${PN}_${PV}.dfsg1-2.diff
	sed -i -e "s:${PN}-${PV}.dfsg1/::g" -i "${S}"/${PN}-${PV}.dfsg1/debian/patches/makefile.patch
	epatch "${S}"/${PN}-${PV}.dfsg1/debian/patches/import-opengl.patch
	epatch "${S}"/${PN}-${PV}.dfsg1/debian/patches/fixes.patch
	epatch "${S}"/${PN}-${PV}.dfsg1/debian/patches/makefile.patch
	epatch "${S}"/${PN}-${PV}.dfsg1/debian/patches/put_prefs_in_home_dir.patch
	sed -i \
	-e 's:"\(se/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/br/gamemanager.d \
	-e 's:"\(music/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/br/gamemanager.d \
	-e 's:"\(se/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/br/sound.d \
	-e 's:"\(voice/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/br/sound.d \
	-e 's:"\(music/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/br/sound.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r music se voice || die

	newicon "${S}"/${PN}-${PV}.dfsg1/debian/${PN}.xpm ${PN}.xpm
	make_desktop_entry projectL ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
