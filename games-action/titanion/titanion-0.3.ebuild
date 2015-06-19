# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=ttn
MY_PV=${PV//./_}

DESCRIPTION="Strike down super high-velocity swooping insects. Fixed shooter in the good old days, 'Titanion'. "
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/windows/ttn_e.html"
SRC_URI="http://www.asahi-net.or.jp/~cs8k-cyu/windows/${MY_PN}${MY_PV}.zip
	mirror://debian/pool/main/t/${PN}/${PN}_${PV}.dfsg1-2.diff.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer"
RDEPEND=""

S=${WORKDIR}/${MY_PN}

src_unpack(){
	unpack ${A}
}

src_prepare(){
	# using frostworks patches with debian's cleanups and minor patches
	epatch "${WORKDIR}"/${PN}_${PV}.dfsg1-2.diff
	sed -i -e "s:${PN}-${PV}.dfsg1/::g" -i "${S}"/${PN}-${PV}.dfsg1/debian/patches/makefile.patch
	epatch "${S}"/${PN}-${PV}.dfsg1/debian/patches/fix.diff
	epatch "${S}"/${PN}-${PV}.dfsg1/debian/patches/windowed.patch
	epatch "${S}"/${PN}-${PV}.dfsg1/debian/patches/dotfile.patch
	epatch "${S}"/${PN}-${PV}.dfsg1/debian/patches/window-resize.patch
	epatch "${S}"/${PN}-${PV}.dfsg1/debian/patches/makefile.patch
	epatch "${S}"/${PN}-${PV}.dfsg1/debian/patches/gdc-0.24-semantics-for-version.patch
	sed -i \
	-e 's:"\(images/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/texture.d \
	-e 's:"\(sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/sound.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r images sounds || die
	newicon "${S}"/${PN}-${PV}.dfsg1/debian/${PN}.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
