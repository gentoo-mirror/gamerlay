# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit d-games

MY_PV=${PV//./_}

DESCRIPTION="The retro modern high speed shooting game"
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/windows/a7xpg_e.html"
SRC_URI="http://abagames.sakura.ne.jp/windows/${PN}${MY_PV}.zip
	http://old-releases.ubuntu.com/ubuntu/pool/universe/a/${PN}/${PN}_${PV}.dfsg1-4.diff.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_unpack(){
	unpack ${A}
}

src_prepare(){
	# using frostworks patches with debian's cleanups and minor patches
	epatch "${WORKDIR}"/${PN}_${PV}.dfsg1-4.diff
	sed -i -e "s:a7xpg-0.11.dfsg1/::g" -i "${WORKDIR}"/${PN}/${P}.dfsg1/debian/patches/makefile.patch
	epatch "${WORKDIR}"/${PN}/${P}.dfsg1/debian/patches/01_port_opengl_headers.diff
	epatch "${WORKDIR}"/${PN}/${P}.dfsg1/debian/patches/02_sdl_import_remove_windows_code.diff
	epatch "${WORKDIR}"/${PN}/${P}.dfsg1/debian/patches/03_sdl_import_fix_weird_sdl_keysym_problem.diff
	epatch "${WORKDIR}"/${PN}/${P}.dfsg1/debian/patches/04_sdl_import_d_language_updates.diff
	epatch "${WORKDIR}"/${PN}/${P}.dfsg1/debian/patches/05_remove_windows_code.diff
	epatch "${WORKDIR}"/${PN}/${P}.dfsg1/debian/patches/06_d_language_changes.diff
	epatch "${WORKDIR}"/${PN}/${P}.dfsg1/debian/patches/07_store_prefs_in_home_dir.diff
	epatch "${WORKDIR}"/${PN}/${P}.dfsg1/debian/patches/08_adapt_build_file_to_linux_gdc.diff
	epatch "${WORKDIR}"/${PN}/${P}.dfsg1/debian/patches/windowed.patch
	epatch "${WORKDIR}"/${PN}/${P}.dfsg1/debian/patches/makefile.patch
	epatch "${WORKDIR}"/${PN}/${P}.dfsg1/debian/patches/window-resizing.patch
	epatch "${WORKDIR}"/${PN}/${P}.dfsg1/debian/patches/allow-sound-init-to-fail.patch
	sed -i \
	-e 's:"\(images/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/Texture.d \
	-e 's:"\(sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/Sound.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/"${PN}"
	doins -r images sounds || die

	newicon "${WORKDIR}"/${PN}/${P}.dfsg1/debian/${PN}.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
