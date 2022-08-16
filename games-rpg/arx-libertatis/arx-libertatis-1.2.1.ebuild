# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_WARN_UNUSED_CLI=yes
inherit cmake

DESCRIPTION="Cross-platform port of Arx Fatalis, a first-person role-playing game"
HOMEPAGE="https://arx-libertatis.org/"
SRC_URI="https://github.com/arx/ArxLibertatis/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crash-reporter debug static tools +unity-build"

COMMON_DEPEND="
	media-libs/freetype
	media-libs/glm
	media-libs/libepoxy
	media-libs/libsdl2[X,video,opengl]
	media-libs/openal
	sys-libs/zlib:=
	virtual/opengl
	crash-reporter? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5[ssl]
		dev-qt/qtwidgets:5
	)
	!static? ( media-libs/glew:= )"
RDEPEND="${COMMON_DEPEND}
	crash-reporter? ( sys-devel/gdb )"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	static? ( media-libs/glew[static-libs] )"
BDEPEND="virtual/pkgconfig"

DOCS=( README.md AUTHORS CHANGELOG )

src_configure() {
	local mycmakeargs=(
		-DBUILD_TOOLS=$(usex tools)
		-DDEBUG=$(usex debug)
		-DICONDIR=/usr/share/icons/hicolor/128x128/apps
		-DINSTALL_SCRIPTS=ON
		-DSET_OPTIMIZATION_FLAGS=OFF
		-DSTRICT_USE=ON
		-DUNITY_BUILD=$(usex unity-build)
		-DUSE_NATIVE_FS=ON
		-DUSE_OPENAL=ON
		-DUSE_OPENGL=ON
		-DBUILD_CRASHREPORTER=$(usex crash-reporter)
		$(usex crash-reporter "-DUSE_QT5=ON" "")
		-DUSE_STATIC_LIBS=$(usex static)
	)

	cmake_src_configure
}

pkg_postinst() {
	elog
	elog "This package only installs the game binary."
	elog "You need the demo or full game data. Also see:"
	elog "http://wiki.arx-libertatis.org/Getting_the_game_data"
	elog
	elog "If you have already installed the game or use the STEAM version,"
	elog "run \"/usr/bin/arx-install-data\""
}
