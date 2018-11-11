# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit cmake-utils

DESCRIPTION="A fast-paced action strategy game implemented using ncurses user interface."
HOMEPAGE="https://github.com/a-nikolaev/curseofwar/wiki"
SRC_URI="https://github.com/a-nikolaev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ncurses sdl"
REQUIRED_USE="|| ( ncurses sdl )"

DEPEND="ncurses? ( sys-libs/ncurses:0 )
	sdl? ( media-libs/libsdl )"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i -e "s:%VERSION%:${PV}:g" ${PN}{,-sdl}.6
	sed -i -e "s:/usr/local/share/:${GAMES_DATADIR}/:g" path.c
	epatch "${FILESDIR}/${P}-fix-gcc-error-compilation.patch"
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DCW_NCURSE_FRONTEND=$(usex ncurses)
		-DCW_SDL_FRONTEND=$(usex sdl)
		-DCW_SDL_MULTIPLAYER=$(usex sdl)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	doicon pixmaps/${PN}-32x32.xpm
	if use ncurses ; then
		dobin "${BUILD_DIR}/${PN}"
		make_desktop_entry ${PN} "Curse of War" ${PN}-32x32 "Game;StrategyGame" "Terminal=true"
		doman ${PN}.6
	fi
	if use sdl ; then
		dobin "${BUILD_DIR}/${PN}-sdl"
		make_desktop_entry ${PN}-sdl "Curse of War (SDL)" ${PN}-32x32
		doman ${PN}-sdl.6
		insinto "/usr/share/${PN}"
		doins -r images
	fi
	dodoc CHANGELOG README
}
