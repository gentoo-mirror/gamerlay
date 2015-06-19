# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils games cmake-utils

DESCRIPTION="Heroes of Might and Magic III game engine rewrite"
HOMEPAGE="http://forum.vcmi.eu/index.php"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug editor launcher +erm"

CDEPEND="
	media-libs/libsdl2[video]
	media-libs/sdl2-image
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf
	virtual/ffmpeg
	sys-libs/zlib[minizip]
	editor? (
		dev-qt/qtgui
		dev-qt/qtcore
		dev-qt/qtwidgets
	)
	launcher? (
		dev-qt/qtgui
		dev-qt/qtcore
		dev-qt/qtnetwork
		dev-qt/qtwidgets
	)
	dev-libs/fuzzylite
"

DEPEND="
	>dev-libs/boost-1.48.0
	virtual/pkgconfig
	${CDEPEND}
"
RDEPEND="
	${CDEPEND}
"
PDEPEND="
	games-strategy/vcmi-data
"

src_configure() {
	local MY_DATADIR="${GAMES_DATADIR#/usr/}/${PN}"
	local MY_GAMESLIBDIR=$(games_get_libdir)
	local MY_LIBDIR=${MY_GAMESLIBDIR#/usr/}
	local MY_BINDIR=${GAMES_BINDIR#/usr/}

	use editor && ewarn "Editor seems to be broken. At least, it fails to build for me"
	use debug || ewarn "Somewhy, buildsystem don't want to use cotire (compile time reducer) generated pch (precompiled header) with disabled debug, so, you will see the warnings on each target."

	local mycmakeargs=(
		-DDATA_DIR="${MY_DATADIR}"
		-DLIB_DIR="${MY_LIBDIR}"
		-DBIN_DIR="${MY_BINDIR}"
		$(cmake-utils_use_enable erm ERM)
		$(cmake-utils_use_enable editor EDITOR)
		$(cmake-utils_use_enable launcher LAUNCHER)
	)
	export CCACHE_SLOPPINESS="time_macros"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
