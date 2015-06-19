# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/mars-game/mars-game-9999.ebuild,v 1.2 2011/09/09 07:52:53 frostwork Exp $

EAPI=4

inherit cmake-utils eutils git-2

DESCRIPTION="M.A.R.S. a ridiculous shooter"
HOMEPAGE="http://mars-game.sourceforge.net"
EGIT_REPO_URI="https://github.com/thelaui/M.A.R.S..git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="dev-libs/fribidi
	>=media-libs/libsfml-2.0_rc20120731
	media-libs/taglib
	virtual/opengl"
RDEPEND="${DEPEND}"

src_prepare(){
	epatch "${FILESDIR}"/${P}-glib.patch
	sed -i -e "s:{CMAKE_INSTALL_PREFIX}/games:{CMAKE_INSTALL_PREFIX}/games/bin:g" -i src/CMakeLists.txt
}
