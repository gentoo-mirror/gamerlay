# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Modified Stratagus engine for Wyrmsun"
HOMEPAGE="https://andrettin.github.io/"
SRC_URI="https://github.com/Andrettin/Wyrmgus/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc mikmod mng ogg opengl static theora"

RDEPEND="dev-lang/lua:0
	dev-lua/toluapp
	media-libs/libpng:=
	media-libs/libsdl
	media-sound/fluidsynth
	mikmod? ( media-sound/mikmod )
	mng? (
		static? ( media-libs/libmng[static-libs] )
		!static? ( media-libs/libmng )
	)
	ogg? (
		static? ( media-libs/libvorbis[static-libs] )
		!static? ( media-libs/libvorbis )
	)
	theora? (
		static? ( media-libs/libtheora[static-libs] )
		!static? ( media-libs/libtheora )
	)
	static? (
		dev-db/sqlite:3[static-libs]
		dev-games/physfs[static-libs]
		media-sound/oaml[static-libs]
		sys-libs/zlib[static-libs]
		x11-libs/libICE[static-libs]
		x11-libs/libXext[static-libs]
	)
	!static? (
		dev-games/physfs
		dev-db/sqlite:3
		media-sound/oaml
		sys-libs/zlib
		x11-libs/libICE
		x11-libs/libXext
	)
"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN/w/W}-${PV}"

src_prepare() {
	sed -i 's#\(install(TARGETS stratagus DESTINATION \)${GAMEDIR})#\1${BINDIR})#' CMakeLists.txt
	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATIC=$(usex static)
		-DENABLE_DOC=$(usex doc)
		-DWITH_MIKMOD=$(usex mikmod)
		-DWITH_MNG=$(usex mng)
		-DWITH_OGGVORBIS=$(usex ogg)
		-DWITH_THEORA=$(usex theora)
		-DWITH_RENDERER=$(usex opengl OpenGL NativeSDL)
		-DWITH_BZIP2=ON
		-DWITH_FLUIDSYNTH=ON
		-DWITH_PHYSFS=ON
	)
	cmake-utils_src_configure
}

src_install() {
	newbin "${BUILD_DIR}/stratagus" wyrmgus
}
