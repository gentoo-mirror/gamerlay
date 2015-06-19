# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils games

DESCRIPTION="A fast-paced action strategy game implemented using ncurses user interface."
HOMEPAGE="https://github.com/a-nikolaev/curseofwar/wiki"
SRC_URI="https://github.com/a-nikolaev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ncurses sdl"
REQUIRED_USE="|| ( ncurses sdl )"

DEPEND="ncurses? ( sys-libs/ncurses )
	sdl? ( media-libs/libsdl )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s:%VERSION%:${PV}:g" ${PN}{,-sdl}.6
	sed -i -e "s:/usr/local/share/:${GAMES_DATADIR}/:g" path.c
	epatch "${FILESDIR}/${P}-fix-gcc-error-compilation.patch"
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use ncurses CW_NCURSE_FRONTEND)
		$(cmake-utils_use sdl CW_SDL_FRONTEND)
		$(cmake-utils_use sdl CW_SDL_MULTIPLAYER)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	doicon pixmaps/${PN}-32x32.xpm
	if use ncurses ; then
		dogamesbin "${BUILD_DIR}/${PN}"
		make_desktop_entry ${PN} "Curse of War" ${PN}-32x32 "Game;StrategyGame" "Terminal=true"
		doman ${PN}.6
	fi
	if use sdl ; then
		dogamesbin "${BUILD_DIR}/${PN}-sdl"
		make_desktop_entry ${PN}-sdl "Curse of War (SDL)" ${PN}-32x32
		doman ${PN}-sdl.6
		insinto "${GAMES_DATADIR}/${PN}"
		doins -r images
	fi
	dodoc CHANGELOG README
}
