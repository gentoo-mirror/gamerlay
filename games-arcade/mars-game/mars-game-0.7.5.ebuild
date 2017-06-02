# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# No tagged release tarball after github dropped "download"
EGIT_COMMIT="c855d044094a1d92317e38935d81ba938946132e"

inherit cmake-utils eutils vcs-snapshot

DESCRIPTION="M.A.R.S. a ridiculous shooter"
HOMEPAGE="http://mars-games.sourceforge.net"
SRC_URI="https://github.com/thelaui/M.A.R.S./archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	dev-libs/fribidi
	media-libs/libsfml
	media-libs/taglib
	virtual/opengl
"
RDEPEND="${DEPEND}"

#S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}/${PN}-9999-glib.patch"
)

src_prepare() {
	sed -i -e "s:{CMAKE_INSTALL_PREFIX}/games:{CMAKE_INSTALL_PREFIX}/games/bin:g" -i src/CMakeLists.txt
	default
}
