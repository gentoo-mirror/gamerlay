# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit eutils cmake-utils flag-o-matic

DESCRIPTION="Heroes of Might and Magic III game engine rewrite"
HOMEPAGE="http://forum.vcmi.eu/index.php"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+debug erm +launcher"

CDEPEND="
	media-libs/libsdl2[video]
	media-libs/sdl2-image
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf
	virtual/ffmpeg
	sys-libs/zlib[minizip]
	launcher? (
		dev-qt/qtgui
		dev-qt/qtcore
		dev-qt/qtnetwork
		dev-qt/qtwidgets
	)
	dev-libs/fuzzylite
"

BDEPEND="
	>dev-libs/boost-1.48.0
	virtual/pkgconfig
"
DEPEND="
	${BDEPEND}
	${CDEPEND}
"
RDEPEND="
	${CDEPEND}
"
PDEPEND="
	games-strategy/vcmi-data
"

pkg_pretend() {
	ewarn 'Looks like current this release is incompatible with modern boost and fails to compile.'
	ewarn 'Please, report me in case if it will build fine for you'
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_ERM=$(usex erm)
		-DENABLE_LAUNCHER=$(usex launcher)
		-DENABLE_PCH=$(usex debug)
		# ^ cc1plus: warning: .../work/vcmi-0.99_build/lib/cotire/vcmi_CXX_prefix.hxx.gch: not used because `NDEBUG' is defined [-Winvalid-pch]
		# (cmake-utils_src_configure somewhy defines -DNDEBUG in release build. I dunno why on the earth it's author did that)
		-DENABLE_MONOLITHIC_INSTALL=OFF
		# ^ or not?
	)
	export CCACHE_SLOPPINESS="time_macros"
	cmake-utils_src_configure
	strip-cppflags -DNDEBUG
}

src_install() {
	cmake-utils_src_install
}
