# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils multilib toolchain-funcs flag-o-matic

DESCRIPTION="Animated sprite editor & pixel art tool"
HOMEPAGE="http://www.aseprite.org"
SRC_URI="https://github.com/aseprite/aseprite/releases/download/v${PV}/Aseprite-v${PV}-Source.zip"

LICENSE="GPL-2 FTL"
SLOT="0"
# giflib still unkeyworded
KEYWORDS="~amd64 ~x86"

IUSE="debug memleak webp"

RDEPEND="dev-libs/tinyxml
	media-libs/allegro:0[X,png]
	media-libs/freetype
	media-libs/giflib
	webp? ( media-libs/libwebp )
	media-libs/libpng:0
	sys-libs/zlib
	virtual/jpeg:0
	x11-libs/libX11
	x11-libs/pixman"
DEPEND="${RDEPEND}
	app-arch/unzip"

PATCHES=( "${FILESDIR}"/${P}_underlinking.patch
	"${FILESDIR}"/${P}_cmake.patch )

DOCS=( docs/files/ase.txt
	docs/files/fli.txt
	docs/files/msk.txt
	docs/files/pic.txt
	docs/files/picpro.txt
	README.md )

S="${WORKDIR}"

src_prepare() {
	cmake-utils_src_prepare

	# Fix to make flag-o-matic work.
	if use debug ; then
		sed -i '/-DNDEBUG/d' CMakeLists.txt || die
	fi
	# Replace to actual version
	sed -i -e "s:1.1.2-dev:1.1.3:g" src/config.h data/gui.xml || die
}

src_configure() {
	use debug && append-cppflags -DDEBUGMODE -D_DEBUG

	local mycmakeargs=(
		-DENABLE_UPDATER=OFF
		-DFULLSCREEN_PLATFORM=ON
		-DUSE_SHARED_ALLEGRO4=ON
		-DUSE_SHARED_CURL=ON
		-DUSE_SHARED_FREETYPE=ON
		-DUSE_SHARED_GIFLIB=ON
		-DUSE_SHARED_JPEGLIB=ON
		-DUSE_SHARED_LIBLOADPNG=ON
		-DUSE_SHARED_LIBPNG=ON
		-DUSE_SHARED_PIXMAN=ON
		-DUSE_SHARED_TINYXML=ON
		-DUSE_SHARED_ZLIB=ON
		$(cmake-utils_use_with webp WEBP_SUPPORT)
		$(cmake-utils_use_enable memleak)
	)

	cmake-utils_src_configure
}
