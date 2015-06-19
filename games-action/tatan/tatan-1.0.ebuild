# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=tatan
MY_PV=${PV//./_}

DESCRIPTION="pointing STG by HIZ "
HOMEPAGE="http://http://hizuoka.web.fc2.com/game/tatan/index_en.html"
SRC_URI="http://hizuoka.web.fc2.com/game/tatan/${MY_PN}.zip
	mirror://debian/pool/main/t/${PN}/${PN}_${PV}.dfsg1-1.diff.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer
	dev-libs/libbulletml"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

src_prepare(){
	# using frostworks patches with debian's cleanups and minor patches
	epatch "${WORKDIR}"/${PN}_${PV}.dfsg1-1.diff
	sed -i -e "s:${PN}-${PV}/::g" -i "${S}"/${PN}-${PV}.dfsg1/debian/patches/makefile.patch
	epatch "${S}"/${PN}-${PV}.dfsg1/debian/patches/import-opengl.patch
	epatch "${S}"/${PN}-${PV}.dfsg1/debian/patches/fixes.patch
	epatch "${S}"/${PN}-${PV}.dfsg1/debian/patches/makefile.patch
	sed -i \
	-e 's:"\(resource/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i import/hell2.d \
	-e 's:"\(image/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/br/gamemanager.d \
	-e 's:"\(image/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/br/screen.d \
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
	doins -r image music voice resource se || die
	newicon "${S}"/${PN}-${PV}.dfsg1/debian/${PN}.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
