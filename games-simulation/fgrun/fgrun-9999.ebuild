# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games cmake-utils git-2

DESCRIPTION="A graphical frontend for the FlightGear Flight Simulator"
HOMEPAGE="http://sourceforge.net/projects/fgrun"
EGIT_REPO_URI="git://gitorious.org/fg/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="nls"

COMMON_DEPEND="
	>=dev-games/openscenegraph-3.0.1
	sys-libs/zlib
	x11-libs/fltk:1[opengl,threads]
"

DEPEND="${COMMON_DEPEND}
	>=dev-games/simgear-2.9
	>=dev-libs/boost-1.34
	nls? ( virtual/libintl )
"

RDEPEND="${COMMON_DEPEND}
	>=games-simulation/flightgear-2.9
"

DOCS=(AUTHORS NEWS)

src_configure() {
	mycmakeargs=(
	-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
	-DSIMGEAR_SHARED=ON
	$(cmake-utils_use_enable nls)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	make_desktop_entry ${PN} "${PN}" flightgear
	prepgamesdirs
}
