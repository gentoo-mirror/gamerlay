# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Open Source Flight Simulator"
HOMEPAGE="http://www.flightgear.org/"
EGIT_REPO_URI="git://git.code.sf.net/p/${PN}/${PN}"
EGIT_BRANCH="next"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dbus debug fgcom fgpanel +jsbsim oldfdm qt5 test +udev +yasim"

COMMON_DEPEND="
	dev-db/sqlite:3
	>=dev-games/openscenegraph-3.2[png]
	~dev-games/simgear-${PV}[-headless]
	sys-libs/zlib
	virtual/opengl
	dbus? ( sys-apps/dbus )
	qt5? (
		>=dev-qt/qtcore-5.4.1:5
		>=dev-qt/qtgui-5.4.1:5
		>=dev-qt/qtwidgets-5.4.1:5
	)
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
		-DFG_DATA_DIR=/usr/share/${PN}-live
		-DENABLE_FGADMIN=OFF
		-DLOGGING=ON
		-DENABLE_PROFILE=OFF
		-DENABLE_RTI=OFF
		-DSIMGEAR_SHARED=ON
		-DSP_FDMS=OFF
		-DSYSTEM_SQLITE=ON
		-DUSE_DBUS=$(usex dbus)
		-DENABLE_FGCOM=$(usex fgcom)
		-DENABLE_IAX=$(usex fgcom)
		-DWITH_FGPANEL=$(usex fgpanel)
		-DENABLE_JSBSIM=$(usex jsbsim)
		-DENABLE_LARCSIM=$(usex oldfdm)
		-DENABLE_UIUC_MODEL=$(usex oldfdm)
		-DENABLE_QT=$(usex qt5)
		-DENABLE_TESTS=$(usex test)
		-DEVENT_INPUT=$(usex udev)
		-DENABLE_YASIM=$(usex yasim)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doicon -s scalable icons/scalable/flightgear.svg
	newmenu package/${PN}.desktop ${PN}.desktop
}

pkg_postinst() {
	elog "FlightGear is now installed, but to run it you"
	elog "have to download fgdata as well, which is expected under"
	elog "/usr/share/${PN}-live"
	elog
	elog "You can save it anywhere else but then you have to set"
	elog "FG_ROOT to that directory or create an \"--fg-root=\" entry in ~/.fgfsrc"
	elog
	elog "To download fgdata, use"
	elog "\"git clone git://git.code.sf.net/p/flightgear/fgdata SOMEPATH\"."
	elog
	elog "Don't forget that before updating FlightGear you will most likely"
	elog "have to update Simgear, too"
}
