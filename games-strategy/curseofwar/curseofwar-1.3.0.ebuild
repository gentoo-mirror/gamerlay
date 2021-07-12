# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

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
	sed -i -e "s:TARGET_LINK_LIBRARIES( curseofwar \${COMMON_LIBS} ncurses ):TARGET_LINK_LIBRARIES( curseofwar \${COMMON_LIBS} ncurses tinfo ):g" CMakeLists.txt
	sed -i -e 's:INSTALL_DATA:"/usr/share/curseofwar/":g' path.c || die "sed failed"
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DCW_NCURSE_FRONTEND=$(usex ncurses)
		-DCW_SDL_FRONTEND=$(usex sdl)
		-DCW_SDL_MULTIPLAYER=$(usex sdl)
	)
	cmake_src_configure
}

src_install() {
	if use ncurses ; then
		dobin "${BUILD_DIR}/${PN}"
		doman ${PN}.6
	fi
	if use sdl ; then
		dobin "${BUILD_DIR}/${PN}-sdl"
		doman ${PN}-sdl.6
		insinto "/usr/share/${PN}"
		doins -r images
	fi
	dodoc CHANGELOG README
}
