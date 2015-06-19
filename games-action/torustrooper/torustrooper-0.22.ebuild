# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=tt
MY_PV=${PV//./_}
MY_PD=torus-trooper

DESCRIPTION="Speed! More speed! Speeding ship sailing through barrage, 'Torus Trooper'"
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/windows/tt_e.html"
SRC_URI="http://www.asahi-net.or.jp/~cs8k-cyu/windows/${MY_PN}${MY_PV}.zip
	mirror://debian/pool/main/t/${MY_PD}/${MY_PD}_${PV}.dfsg1-5.diff.gz"

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
	epatch "${WORKDIR}"/${MY_PD}_${PV}.dfsg1-5.diff
	sed -i -e "s:b/::g" -i "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/fixes.patch
	sed -i -e "s:${MY_PD}:${PN}:g" -i "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/fixes.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/fixes.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/windowed.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/dotfile.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/gdc-0.24-semantics-for-version.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/window-resizing.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/save-score-444372.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/level-select-444948.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/avoid-segfault-when-sdl-fails.patch
	sed -i \
	-e 's:"\(images/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/texture.d \
	-e 's:"\(sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/sound.d \
	-e 's:"\(barrage[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/tt/barrage.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r barrage images sounds || die
	newicon "${S}"/${MY_PD}-${PV}.dfsg1/debian/${MY_PD}.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
