# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Lightweight cross platform GUI C++ library designed for games"
HOMEPAGE="http://fifengine.github.io/fifechan/"
SRC_URI="https://github.com/fifengine/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="allegro +opengl +sdl irrlicht"

DEPEND="
	x11-libs/libXext
	irrlicht? (
		dev-games/irrlicht
	)
	sdl? (
		media-libs/libsdl2
		media-libs/sdl-ttf
		media-libs/sdl2-image[png]
	)
	opengl? (
		virtual/opengl
		virtual/glu
	)
	allegro? (
		media-libs/allegro:0
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_ALLEGRO=$(usex allegro)
		-DENABLE_OPENGL=$(usex opengl)
#		-DENABLE_OPENGL_CONTRIB=$(usx opengl)
		-DENABLE_SDL=$(usex sdl)
		-DENABLE_SDL_CONTRIB=$(usex sdl)
		-DENABLE_IRRLICHT=$(usex irrlicht)
	)
	cmake_src_configure
}
