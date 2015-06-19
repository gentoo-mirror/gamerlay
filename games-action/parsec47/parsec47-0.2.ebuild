# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=p47
MY_PV=${PV//./_}

DESCRIPTION="Defeat retro enemies modenly. Retromodern hispeed shmup, 'PARSEC47'. "
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/windows/p47_e.html"
SRC_URI="http://www.asahi-net.or.jp/~cs8k-cyu/windows/${MY_PN}_${MY_PV}.zip
	mirror://debian/pool/main/p/${PN}/${PN}_${PV}.dfsg1-1.diff.gz"

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
	sed -i -e "s:${PN}-${PV}.dfsg1/::g" -i "${WORKDIR}"/${MY_PN}/${PN}-${PV}.dfsg1/debian/patches/makefile.patch
	epatch "${WORKDIR}"/${MY_PN}/${PN}-${PV}.dfsg1/debian/patches/fixes.patch
	epatch "${WORKDIR}"/${MY_PN}/${PN}-${PV}.dfsg1/debian/patches/windowed.patch
	epatch "${WORKDIR}"/${MY_PN}/${PN}-${PV}.dfsg1/debian/patches/dotfile.patch
	epatch "${WORKDIR}"/${MY_PN}/${PN}-${PV}.dfsg1/debian/patches/makefile.patch
	epatch "${WORKDIR}"/${MY_PN}/${PN}-${PV}.dfsg1/debian/patches/window-resizing.patch
	sed -i \
	-e 's:"\(images/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/Texture.d \
	-e 's:"\(sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/Sound.d \
	-e 's:"\(morph[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/p47/BarrageManager.d \
	-e 's:"\(small[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/p47/BarrageManager.d \
	-e 's:"\(smallmove[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/p47/BarrageManager.d \
	-e 's:"\(smallsidemove[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/p47/BarrageManager.d \
	-e 's:"\(middle[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/p47/BarrageManager.d \
	-e 's:"\(middlesub[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/p47/BarrageManager.d \
	-e 's:"\(middlemove[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/p47/BarrageManager.d \
	-e 's:"\(middlebackmove[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/p47/BarrageManager.d \
	-e 's:"\(large[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/p47/BarrageManager.d \
	-e 's:"\(largemove[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/p47/BarrageManager.d \
	-e 's:"\(morph_lock[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/p47/BarrageManager.d \
	-e 's:"\(small_lock[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/p47/BarrageManager.d \
	-e 's:"\(middlesub_lock[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/p47/BarrageManager.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r morph small smallmove smallsidemove middle middlesub middlemove \
		middlebackmove large largemove morph_lock small_lock middlesub_lock \
		images sounds || die

	newicon "${WORKDIR}"/${MY_PN}/${PN}-${PV}.dfsg1/debian/${PN}.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
