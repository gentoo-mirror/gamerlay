# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A Doom 3 GPL source modification."
HOMEPAGE="https://github.com/dhewm/dhewm3"
SRC_URI="https://github.com/dhewm/dhewm3/releases/download/${PV}/${P}-src.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dedicated"

DEPEND="
	virtual/jpeg:0
	media-libs/libogg
	media-libs/libsdl2
	media-libs/libvorbis
	media-libs/openal
	net-misc/curl
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}/neo"

DATADIR=/usr/share/dhewm3
DOCS="README.md"

# TODO: patch for common games-dir with roe and doom3-data

src_configure() {
	mycmakeargs=(
		-DDEDICATED=ON
		-DSDL2=ON
		-DCORE=$(usex dedicated OFF ON)
		-DBASE=$(usex dedicated OFF ON)
		-DD3XP=$(usex dedicated OFF ON)
	)
	cmake_src_configure
}

pkg_postinst() {
	elog "You need to copy *.pk4 from either your installation media or your hard drive to"
	elog "/usr/share/dhewm3/base before running the game,"
	elog "or 'emerge games-fps/doom3-data' to install from CD."
	echo
}
