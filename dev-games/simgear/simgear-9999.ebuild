# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_BRANCH="next"
EGIT_PROJECT="simgear.git"

inherit cmake-utils git-2

DESCRIPTION="Development library for simulation games"
HOMEPAGE="http://www.simgear.org/"
EGIT_REPO_URI="git://git.code.sf.net/p/flightgear/${PN}
		git://mapserver.flightgear.org/${PN}/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug headless test"

COMMON_DEPEND="
	sys-libs/zlib
	!headless? (
		>=dev-games/openscenegraph-3.2[png]
		dev-libs/expat
		media-libs/openal
		virtual/opengl
	)
"

DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.37
"

RDEPEND="${COMMON_DEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README Thanks)

src_configure() {
	local mycmakeargs=(
		-DENABLE_LIBSVN=OFF
		-DENABLE_RTI=OFF
		-DENABLE_SOUND=ON
		-DSG_SVN_CLIENT=ON
		-DSIMGEAR_SHARED=ON
		-DSYSTEM_EXPAT=ON
		$(cmake-utils_use headless SIMGEAR_HEADLESS)
		$(cmake-utils_use_enable test TESTS)
	)
	cmake-utils_src_configure
}
