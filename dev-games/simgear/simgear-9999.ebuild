# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_BRANCH="next"
EGIT_PROJECT="simgear.git"

inherit cmake-utils git-2

DESCRIPTION="Development library for simulation games"
HOMEPAGE="http://www.simgear.org/"
EGIT_REPO_URI="git://gitorious.org/fg/simgear.git
		git://mapserver.flightgear.org/simgear/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug headless +subversion test"

COMMON_DEPEND="
	sys-libs/zlib
	!headless? (
		>=dev-games/openscenegraph-3.0[png]
		dev-libs/expat
		media-libs/openal
		virtual/opengl
		subversion? (
			dev-libs/apr
			dev-vcs/subversion
		)
	)
"

DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.37
"

RDEPEND="${COMMON_DEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README Thanks)

src_configure() {
	local mycmakeargs=(
		-DENABLE_RTI=OFF
		-DENABLE_SOUND=ON
		-DJPEG_FACTORY=OFF
		-DSIMGEAR_SHARED=ON
		-DSYSTEM_EXPAT=ON
		$(cmake-utils_use_enable subversion LIBSVN)
		$(cmake-utils_use headless SIMGEAR_HEADLESS)
		$(cmake-utils_use_enable test TESTS)
	)
	cmake-utils_src_configure
}
