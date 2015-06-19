# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

[[ ${PV} = 9999* ]] && GIT="git-2"

inherit games cmake-utils ${GIT}

DESCRIPTION="Rally game focused on closed rally tracks with possible stunt elements (jumps, loops, pipes)."
HOMEPAGE="http://code.google.com/p/vdrift-ogre/"

SLOT="0"
LICENSE="GPL-3"
IUSE="dedicated +game editor"

if [[ ${PV} = 9999* ]]; then
        SRC_URI=""
        KEYWORDS=""
	EGIT_REPO_URI="https://github.com/stuntrally/stuntrally"
	LIVE_PDEPEND="=${CATEGORY}/${PN}-tracks-${PV}"
else
	MY_P="StuntRally-${PV}-sources"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.xz"
	S="${WORKDIR}/${MY_P}"
fi

RDEPEND="
	game? (
		dev-games/ogre[cg,boost,ois,freeimage,opengl,zip]
		dev-games/mygui
		media-libs/libsdl:0
		media-libs/libvorbis
		media-libs/libogg
	)
	dev-libs/boost
	net-libs/enet:1.3
	virtual/libstdc++
	sys-devel/gcc
"
DEPEND="${RDEPEND}"
PDEPEND="${LIVE_PDEPEND}"

REQUIRED_USE="editor? ( game )"

DOCS=( Readme.txt )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build dedicated MASTER_SERVER)
		$(cmake-utils_use_build game GAME)
		$(cmake-utils_use_build editor EDITOR)
	)
	cmake-utils_src_configure
}


src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
