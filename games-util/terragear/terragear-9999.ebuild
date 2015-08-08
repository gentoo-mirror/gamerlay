# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-2

DESCRIPTION="Terrain editing programs for FlightGear"
HOMEPAGE="http://terragear.sourceforge.net/"
EGIT_REPO_URI="git://git.code.sf.net/p/flightgear/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-games/simgear-3.1.0
	dev-libs/boost
	>=sci-libs/gdal-2.0.0
	>=sci-mathematics/cgal-4.0[gmp]
"

RDEPEND="${DEPEND}
	app-arch/unzip
"

src_configure() {
	mycmakeargs=(
	-DSIMGEAR_SHARED=ON
	)

	cmake-utils_src_configure
}
