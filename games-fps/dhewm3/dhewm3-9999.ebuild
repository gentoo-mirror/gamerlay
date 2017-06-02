# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="A Doom 3 GPL source modification."
HOMEPAGE="https://github.com/dhewm/dhewm3"
EGIT_REPO_URI="https://github.com/dhewm/dhewm3.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="cdinstall dedicated roe"

DEPEND="
	virtual/jpeg
	media-libs/libogg
	media-libs/libsdl2
	media-libs/libvorbis
	media-libs/openal
	net-misc/curl
	sys-libs/zlib
"
RDEPEND="${DEPEND}
	cdinstall? (
		>=games-fps/doom3-data-1.1.1282-r1
		roe? ( games-fps/doom3-roe )
	)"

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

	# TODO: roe desktop file
}

pkg_postinst() {
	if ! use cdinstall; then
		elog "You need to copy *.pk4 from either your installation media or your hard drive to"
		elog "${DATADIR}/base before running the game,"
		elog "or 'emerge games-fps/doom3-data' to install from CD."
		echo
		if use roe ; then
			elog "To use the Resurrection of Evil expansion pack, you also need	to copy *.pk4"
			elog "to ${DATADIR}/d3xp from the RoE CD before running the game,"
			elog "or 'emerge doom3-roe' to install from CD."
		fi
	fi

	echo
	elog "To play the game, run:"
	elog " ${PN}"
	echo
}
