# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

#PYTHON_COMPAT=( pypy{,3} python{2_7,3_{4,5}} )
# py3 is not yet tested by upstream -> not merged in master
PYTHON_COMPAT=( pypy python2_7 )

inherit eutils python-single-r1 cmake-utils

DESCRIPTION="Flexible Isometric Free Engine, 2D"
HOMEPAGE="http://fifengine.de"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"

KEYWORDS=""
SLOT="0"
IUSE="debug +log +opengl +zip +fifechan librocket cegui python"

RDEPEND="
	librocket? ( dev-libs/libRocket )
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
		dev-python/pyyaml[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
"
DEPEND="
	${RDEPEND}
	python? ( >=dev-lang/swig-1.3.40 )
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"


usx() { usex $* ON OFF; }

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${P}-unbundle-libpng.patch"
	default
}

src_configure() {
	local mycmakeargs=(
		-Dopengl=$(usx opengl)
		-Dfifechan=$(usx fifechan)
		-Dlibrocket=$(usx librocket)
		-Dcegui=$(usx cegui)
		-Dlogging=$(usx log)
		-Dbuild-python=$(usx python)
		-Dbuild-library=ON
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
