# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=vr
MY_PD=val-and-rick
MY_PV=${PV//./_}

DESCRIPTION="Guns, Guns, Guns! Inofficial and secret 1st version of gunroar"
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/"
SRC_URI="http://www.asahi-net.or.jp/~cs8k-cyu/windows/${MY_PN}${MY_PV}.zip
	mirror://debian/pool/main/v/${MY_PD}/${MY_PD}_${PV}.dfsg1-2.diff.gz"

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
	epatch "${WORKDIR}"/${MY_PD}_${PV}.dfsg1-2.diff
	sed -i -e "s:${MY_PD}-${PV}.dfsg1/::g" -i "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/makefile.patch
	sed -i -e "s:${MY_PD}:${PN}:g" -i "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/makefile.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/import.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/fixes.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/makefile.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/windowed.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/homedir.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/resizable.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/endian-clean.patch
	epatch "${S}"/${MY_PD}-${PV}.dfsg1/debian/patches/avoid-segfault-when-sdl-fails.patch
	sed -i \
	-e 's:"\(images/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/texture.d \
	-e 's:"\(sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/sound.d \
	-e 's:"\(barrage[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/vr/barrage.d \
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
