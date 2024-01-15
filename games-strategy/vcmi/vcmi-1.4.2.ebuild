# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=(luajit)
# TODO: other targets (buildsystem is crazy and needs patches)

inherit cmake lua-single

DESCRIPTION="Heroes of Might and Magic III game engine rewrite"
HOMEPAGE="http://forum.vcmi.eu/index.php"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO: other arches
IUSE="+editor debug erm +launcher lua +nullkiller-ai +translations"

REQUIRED_USE="
	erm? ( lua )
	lua? ( ${LUA_REQUIRED_USE} )
"

CDEPEND="
	media-libs/libsdl2[video]
	media-libs/sdl2-image
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf
	media-video/ffmpeg
	launcher? (
		dev-qt/qtgui
		dev-qt/qtcore
		dev-qt/qtnetwork
		dev-qt/qtwidgets
		translations? ( dev-qt/linguist-tools )
	)
	editor? (
		dev-qt/qtgui
		dev-qt/qtcore
		dev-qt/qtnetwork
		dev-qt/qtwidgets
		translations? ( dev-qt/linguist-tools )
	)
	dev-libs/fuzzylite
	nullkiller-ai? ( dev-cpp/tbb )
	sys-libs/zlib[minizip]
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
# PDEPEND="
# 	games-strategy/vcmi-data
# "

src_configure() {
	local mycmakeargs=(
		-DENABLE_ERM=$(usex erm)
		-DENABLE_LUA=$(usex lua)
		-DENABLE_LAUNCHER=$(usex launcher)
		-DENABLE_EDITOR=$(usex editor)
		-DENABLE_TRANSLATIONS=$(usex translations)
		-DENABLE_PCH=$(usex !debug)
		-DENABLE_NULLKILLER_AI=$(usex nullkiller-ai)

		-DENABLE_MONOLITHIC_INSTALL=OFF
		-DFORCE_BUNDLED_FL=OFF
		-DFORCE_BUNDLED_MINIZIP=OFF
		-DENABLE_GITVERSION=OFF
		-DBoost_NO_BOOST_CMAKE=ON
	)
	export CCACHE_SLOPPINESS="time_macros"
	cmake_src_configure
}

pkg_postinst() {
	elog "For the game to work properly, please copy your"
	elog 'Heroes Of Might and Magic ("The Wake Of Gods" or'
	elog '"Shadow of Death" or "Complete edition")'
	elog "game directory into /usr/share/${PN}."
	elog "or use 'vcmibuilder' utility on your:"
	elog "   a) One or two CD's or CD images"
	elog "   b) gog.com installer"
	elog "   c) Directory with installed game"
	elog "(although installing it in such way is 'bad practices')."
	elog "For more information, please visit:"
	elog "http://wiki.vcmi.eu/index.php?title=Installation_on_Linux"
	elog ""
	elog "Also, you may want to install VCMI Extras and Wake of Gods"
	elog "mods from the launcher after you'll start the game"
}
