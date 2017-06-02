# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils git-r3

DESCRIPTION="M.A.R.S. a ridiculous shooter"
HOMEPAGE="http://mars-game.sourceforge.net"
EGIT_REPO_URI="https://github.com/thelaui/M.A.R.S..git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="
	dev-libs/fribidi
	media-libs/libsfml
	media-libs/taglib
	virtual/opengl
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}"-glib.patch
)

src_prepare(){
	sed -i -e "s:{CMAKE_INSTALL_PREFIX}/games:{CMAKE_INSTALL_PREFIX}/games/bin:g" -i src/CMakeLists.txt
	default
}
