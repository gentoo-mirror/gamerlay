# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_BRANCH="next"
EGIT_PROJECT="flightgear.git"

inherit games cmake-utils git-2

DESCRIPTION="Open Source Flight Simulator"
HOMEPAGE="http://www.flightgear.org/"
EGIT_REPO_URI="git://git.code.sf.net/p/${PN}/${PN}
		git://mapserver.flightgear.org/${PN}/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug fgcom fgpanel +jsbsim oldfdm test +udev +yasim"

COMMON_DEPEND="
	dev-db/sqlite:3
	>=dev-games/openscenegraph-3.2[png]
	>=dev-games/simgear-9999[-headless]
	sys-libs/zlib
	virtual/opengl
	udev? ( virtual/udev )
	fgpanel? (
		media-libs/freeglut
		media-libs/libpng:0
	)
"

DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.37
	media-libs/openal
	>=media-libs/plib-1.8.5
"

RDEPEND="${COMMON_DEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README Thanks)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
		-DFG_DATA_DIR="${GAMES_DATADIR}"/${PN}-live
		-DENABLE_FGADMIN=OFF
		-DLOGGING=ON
		-DENABLE_PROFILE=OFF
		-DENABLE_RTI=OFF
		-DSIMGEAR_SHARED=ON
		-DSP_FDMS=OFF
		-DSYSTEM_SQLITE=ON
		$(cmake-utils_use_enable fgcom)
		$(cmake-utils_use_enable fgcom IAX)
		$(cmake-utils_use_with fgpanel)
		$(cmake-utils_use_enable jsbsim)
		$(cmake-utils_use_enable oldfdm LARCSIM)
		$(cmake-utils_use_enable oldfdm UIUC_MODEL)
		$(cmake-utils_use_enable test TESTS)
		$(cmake-utils_use udev EVENT_INPUT)
		$(cmake-utils_use_enable yasim)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doicon -s scalable icons/scalable/flightgear.svg
	newmenu package/${PN}.desktop ${PN}.desktop
	prepgamesdirs
}

pkg_postinst() {
	elog "FlightGear is now installed, but to run it you"
	elog "have to download fgdata as well, which is expected under"
	elog "${GAMES_DATADIR}/${PN}-live"
	elog
	elog "You can save it anywhere else but then you have to set"
	elog "FG_ROOT to that directory or create an \"--fg-root=\" entry in ~/.fgfsrc"
	elog
	elog "To download fgdata, use"
	elog "\"git clone git://mapserver.flightgear.org/fgdata/ SOMEPATH\"."
	elog
	elog "Don't forget that before updating FlightGear you will most likely"
	elog "have to update Simgear, too"
	elog
	elog
	elog "It is recommended that you install a launcher,"
	elog "as it provides easy access to startup options:"
	elog "* games-simulation/fgrun"
}
