# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=gr
MY_PV=${PV//./_}

DESCRIPTION="Guns, Guns, Guns! 360-degree gunboat shooter, 'Gunroar'"
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/windows/gr_e.html"
SRC_URI="http://www.asahi-net.or.jp/~cs8k-cyu/windows/${MY_PN}${MY_PV}.zip
	mirror://debian/pool/main/g/${PN}/${PN}_${PV}.dfsg1-3.diff.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer"

DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

src_prepare(){
	# using frostworks patches with debian's cleanups and minor patches
	epatch "${WORKDIR}"/${PN}_${PV}.dfsg1-3.diff
	sed -i -e "s:a7xpg-0.11.dfsg1/::g" -i "${WORKDIR}"/${MY_PN}/${P}.dfsg1/debian/patches/makefile.patch
	epatch "${WORKDIR}"/${MY_PN}/${P}.dfsg1/debian/patches/01_sdl_fix_imports.diff
	epatch "${WORKDIR}"/${MY_PN}/${P}.dfsg1/debian/patches/02_d_language_changes.diff
	epatch "${WORKDIR}"/${MY_PN}/${P}.dfsg1/debian/patches/03_put_prefs_in_home_dir.diff
	epatch "${WORKDIR}"/${MY_PN}/${P}.dfsg1/debian/patches/04_adapt_build_file_to_linux.diff
	epatch "${WORKDIR}"/${MY_PN}/${P}.dfsg1/debian/patches/windowed.patch
	epatch "${WORKDIR}"/${MY_PN}/${P}.dfsg1/debian/patches/makefile.patch
	epatch "${WORKDIR}"/${MY_PN}/${P}.dfsg1/debian/patches/gdc-0.24-semantics-for-version.patch
	epatch "${WORKDIR}"/${MY_PN}/${P}.dfsg1/debian/patches/window-resizing.patch
	epatch "${WORKDIR}"/${MY_PN}/${P}.dfsg1/debian/patches/avoid-segfault-when-sdl-fails.patch
	sed -i \
	-e 's:"\(images/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/texture.d \
	-e 's:"\(sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/sound.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}
	dodir "${GAMES_STATEDIR}/${PN}" "${GAMES_STATEDIR}/${PN}/replay"
	local statedir="${GAMES_STATEDIR}"/${PN}

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r images sounds || die
	newicon "${WORKDIR}"/${MY_PN}/${P}.dfsg1/debian/${PN}.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
