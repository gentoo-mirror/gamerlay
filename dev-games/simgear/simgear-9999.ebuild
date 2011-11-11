# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_BRANCH="next"

inherit cmake-utils git-2

DESCRIPTION="Development library for simulation games"
HOMEPAGE="http://www.simgear.org/"
EGIT_REPO_URI="git://gitorious.org/fg/simgear.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="subversion X"

RDEPEND="dev-libs/boost
	subversion? ( dev-vcs/subversion )
	X? (	>=dev-games/openscenegraph-3.0[png]
		media-libs/freealut )
"

DEPEND="${RDEPEND}"

DOCS=(NEWS AUTHORS)

src_configure() {
	mycmakeargs=(
	$(cmake-utils_use subversion ENABLE_LIBSVN)
	$(cmake-utils_use !X SIMGEAR_HEADLESS)
	)

	cmake-utils_src_configure
}
