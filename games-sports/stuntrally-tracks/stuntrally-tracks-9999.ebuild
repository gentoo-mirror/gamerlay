# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit games cmake-utils git-2

DESCRIPTION="A set of tracks for ${CATEGORY}/${P//-tracks}"
HOMEPAGE="http://code.google.com/p/vdrift-ogre/"

SLOT="0"
LICENSE="GPL-3"
IUSE=""

SRC_URI=""
KEYWORDS=""
EGIT_REPO_URI="https://github.com/stuntrally/tracks"
EGIT_PROJECT="${PN}"
# Shallowing, since we don't want to fetch few GB of history
#EGIT_OPTIONS="--depth 1"

RDEPEND="~${CATEGORY}/${P//-tracks}"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs+=(
		-DSHARE_INSTALL="/usr/share/games/stuntrally"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
