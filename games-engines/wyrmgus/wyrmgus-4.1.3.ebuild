# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 )

inherit cmake lua-single

DESCRIPTION="Modified Stratagus engine for Wyrmsun"
HOMEPAGE="https://andrettin.github.io/"
SRC_URI="https://github.com/Andrettin/Wyrmgus/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 doc opengl X"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	bzip2? ( app-arch/bzip2:= )
	opengl? ( virtual/opengl )
	X? ( x11-libs/libX11 )
	dev-libs/boost:=
	dev-lua/toluapp
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtlocation
	dev-qt/qtmultimedia
	dev-qt/qtwidgets
	media-libs/libsdl
	media-libs/sdl-mixer
	sys-libs/zlib
"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/Wyrmgus-${PV}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOC=$(usex doc)
		-DWITH_RENDERER=$(usex opengl OpenGL NativeSDL)
		-DWITH_BZIP2=$(usex bzip2)
		-DWITH_X11=$(usex X)
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/wyrmgus"
	dodoc README.MD
}
