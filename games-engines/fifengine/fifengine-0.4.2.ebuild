# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit eutils python-single-r1 cmake

DESCRIPTION="Flexible Isometric Free Engine, 2D"
HOMEPAGE="http://fifengine.de"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug +log +opengl +zip +fifechan cegui python"

RDEPEND="
	cegui? ( dev-games/cegui )
	fifechan? ( games-engines/fifechan )
	dev-libs/tinyxml
	media-libs/libpng
	media-libs/mesa
	>=dev-libs/boost-1.33.1
	media-libs/libsdl2
	media-libs/sdl2-ttf
	media-libs/sdl2-image[png]
	media-libs/libvorbis
	media-libs/libogg
	media-libs/openal
	>=sys-libs/zlib-1.2
	x11-libs/libXcursor
	x11-libs/libXext
	virtual/opengl
	virtual/glu
	python? (
		dev-python/pyyaml
		${PYTHON_DEPS}
	)
"
DEPEND="
	${RDEPEND}
	python? ( >=dev-lang/swig-1.3.40 )
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}/${P}-unbundle-libpng.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-Dopengl=$(usex opengl)
		-Dfifechan=$(usex fifechan)
		-Dlibrocket=OFF
		-Dcegui=$(usex cegui)
		-Dlogging=$(usex log)
		-Dbuild-python=$(usex python)
		-Dbuild-library=ON
	)

	cmake_src_configure
}
