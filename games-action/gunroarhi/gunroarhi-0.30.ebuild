# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PD=gunroar
MY_PDV=0_15
MY_PDPV=0.15
MY_PN=gr_hi
MY_PV=${PV//./_}

DESCRIPTION="Guns, Guns, Guns! 360-degree gunboat shooter, fork of ABAs 'Gunroar'"
HOMEPAGE="http://www.edit.ne.jp/~otoyan/soft/gr_hi.html"
SRC_URI="http://www.edit.ne.jp/~otoyan/soft/gr_hi/${MY_PN}${MY_PV}.zip
	mirror://debian/pool/main/g/${MY_PD}/${MY_PD}_${MY_PDPV}.dfsg1-3.diff.gz"

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
	epatch "${WORKDIR}"/${MY_PD}_${MY_PDPV}.dfsg1-3.diff
	sed -i -e "s:a7xpg-0.11.dfsg1/::g" -i "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/patches/makefile.patch
	sed -i -e "s:${MY_PD}:${PN}:g" -i "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/patches/makefile.patch
	sed -i -e "s:${MY_PD}_${MY_PDPV}.dfsg1.orig/:old-gr:g" -i "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/patches/03_put_prefs_in_home_dir.diff
	sed -i -e "s:${MY_PD}_${MY_PDPV}.dfsg1/:new-gr:g" -i "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/patches/03_put_prefs_in_home_dir.diff
	sed -i -e "s:${MY_PD}_${MY_PDPV}.dfsg1.hi.orig/:old-gr:g" -i "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/patches/gunroar-hot-iron.patch
	sed -i -e "s:${MY_PD}_${MY_PDPV}.dfsg1.hi/:new-gr:g" -i "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/patches/gunroar-hot-iron.patch
	epatch "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/patches/01_sdl_fix_imports.diff
	epatch "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/patches/02_d_language_changes.diff
	epatch "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/patches/04_adapt_build_file_to_linux.diff
	epatch "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/patches/windowed.patch
	epatch "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/patches/makefile.patch
	epatch "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/patches/gdc-0.24-semantics-for-version.patch
	epatch "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/patches/window-resizing.patch
	epatch "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/patches/avoid-segfault-when-sdl-fails.patch
	epatch "${FILESDIR}"/03_put_prefs_in_home_dir.diff
	sed -i \
	-e 's:"\(images/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/texture.d \
	-e 's:"\(sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/sound.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r images sounds || die
	newicon "${S}"/${MY_PD}-${MY_PDPV}.dfsg1/debian/${MY_PD}.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
