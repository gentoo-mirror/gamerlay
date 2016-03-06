# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Development library for simulation games"
HOMEPAGE="http://www.simgear.org/"
EGIT_REPO_URI="git://git.code.sf.net/p/flightgear/${PN}"
EGIT_BRANCH="next"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="curl debug headless test"

COMMON_DEPEND="
	sys-libs/zlib
	curl? ( net-misc/curl )
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
		-DENABLE_CURL=$(usex curl)
		-DENABLE_LIBSVN=OFF
		-DENABLE_RTI=OFF
		-DENABLE_SOUND=ON
		-DENABLE_TESTS=$(usex test)
		-DSG_SVN_CLIENT=ON
		-DSIMGEAR_HEADLESS=$(usex headless)
		-DSIMGEAR_SHARED=ON
		-DSYSTEM_EXPAT=ON
	)
	cmake-utils_src_configure
}
