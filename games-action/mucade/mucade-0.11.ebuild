# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=mcd
MY_PTCH=mu-cade
MY_PV=${PV//./_}

DESCRIPTION="The Physics Centipede Invasion. Smashup waggly shmup, 'Mu-cade'."
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/windows/mcd_e.html"
SRC_URI="http://www.asahi-net.or.jp/~cs8k-cyu/windows/${MY_PN}${MY_PV}.zip
	mirror://debian/pool/main/m/${MY_PTCH}/${MY_PTCH}_${PV}.dfsg1-5.diff.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer
	<dev-games/ode-10.1
	dev-libs/libbulletml"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

src_prepare(){
	# using frostworks patches with debian's cleanups and minor patches
	epatch "${WORKDIR}"/${MY_PTCH}_${PV}.dfsg1-5.diff
	sed -i -e "s:b/::g" -i "${WORKDIR}"/${MY_PN}/${MY_PTCH}-${PV}.dfsg1/debian/patches/makefile.patch
	sed -i -e "s:mu-cade:mucade:g" -i "${WORKDIR}"/${MY_PN}/${MY_PTCH}-${PV}.dfsg1/debian/patches/makefile.patch
	sed -i -e "s:mu-cade:mucade:g" -i "${WORKDIR}"/${MY_PN}/${MY_PTCH}-${PV}.dfsg1/debian/patches/dotfile.patch
	epatch "${WORKDIR}"/${MY_PN}/${MY_PTCH}-${PV}.dfsg1/debian/patches/fixes.patch
	epatch "${WORKDIR}"/${MY_PN}/${MY_PTCH}-${PV}.dfsg1/debian/patches/windowed.patch
	epatch "${WORKDIR}"/${MY_PN}/${MY_PTCH}-${PV}.dfsg1/debian/patches/dotfile.patch
	epatch "${WORKDIR}"/${MY_PN}/${MY_PTCH}-${PV}.dfsg1/debian/patches/window-resize.patch
	epatch "${WORKDIR}"/${MY_PN}/${MY_PTCH}-${PV}.dfsg1/debian/patches/makefile.patch
	epatch "${WORKDIR}"/${MY_PN}/${MY_PTCH}-${PV}.dfsg1/debian/patches/gdc-0.24-semantics-for-version.patch
	epatch "${WORKDIR}"/${MY_PN}/${MY_PTCH}-${PV}.dfsg1/debian/patches/fullscreen-option.patch
	#epatch "${WORKDIR}"/${MY_PN}/${MY_PTCH}-${PV}.dfsg1/debian/patches/ode.patch
	sed -i \
	-e 's:"\(images/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/texture.d \
	-e 's:"\(barrage[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/mcd/barrage.d \
	-e 's:"\(sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/sound.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r barrage images sounds || die
	newicon "${WORKDIR}"/${MY_PN}/${MY_PTCH}-${PV}.dfsg1/debian/${MY_PTCH}.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
