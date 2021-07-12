# Copyright 2014 Julian Ospald <hasufell@posteo.de>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="An open source, real time strategy game based on the Dungeon Keeper series"
HOMEPAGE="http://opendungeons.github.io/"
SRC_URI="https://github.com/OpenDungeons/OpenDungeons/releases/download/${PV}/${P}.tar.xz"
EGIT_BRANCH="development"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-games/cegui-0.8.0[ogre,opengl]
	>=dev-games/ogre-1.9.0
	dev-games/ois
	dev-libs/boost:=
	>=media-libs/libsfml-2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DOD_DATA_PATH=/usr/share/${PN}
		-DOD_BIN_PATH=/usr/bin/
		-DOD_SHARE_PATH=/usr/share
		)

	cmake-utils_src_configure
}
