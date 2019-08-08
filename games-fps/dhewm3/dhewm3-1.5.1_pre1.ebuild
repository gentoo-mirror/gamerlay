# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_PV=${PV/_pre/_PRE}

DESCRIPTION="A Doom 3 GPL source modification."
HOMEPAGE="https://github.com/dhewm/dhewm3"
SRC_URI="https://github.com/dhewm/dhewm3/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

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

S="${WORKDIR}/${PN}-${MY_PV}"
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
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	keepdir "${DATADIR}"
	cmake-utils_src_install

	newicon "${CMAKE_USE_DIR}"/sys/linux/setup/image/doom3.png "${PN}".png
	make_desktop_entry "${PN}" "Doom 3 - dhewm"
}

pkg_postinst() {
	elog "You need to copy *.pk4 from either your installation media or your hard drive to"
	elog "${DATADIR}/base before running the game,"
	elog "or 'emerge games-fps/doom3-data' to install from CD."
	echo
}
