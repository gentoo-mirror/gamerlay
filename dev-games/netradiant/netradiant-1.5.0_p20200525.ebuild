# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

GIT_TAG="acd4026b70958a6371bf09c8f1618f98db625234"

DESCRIPTION="NetRadiant is a fork of map editor for Q3 based games, GtkRadiant 1.5"
HOMEPAGE="https://netradiant.gitlab.io/"
BASE_ZIP_URI="http://ingar.intranifty.net/files/netradiant/gamepacks/"
SRC_URI="https://gitlab.com/xonotic/netradiant/-/archive/${GIT_TAG}/netradiant-${GIT_TAG}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+gui tools"
REQUIRED_USE="|| ( gui tools )"

RDEPEND="
	gui? (
		dev-games/netradiant-gamepacks
		x11-libs/gtk+:2
		x11-libs/gtkglext
		x11-libs/pango
	)
	dev-libs/glib
	dev-libs/libxml2
	media-libs/libpng:=
	media-libs/libwebp:=
	sys-libs/zlib:=[minizip]
	virtual/jpeg
	virtual/opengl
"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	"

S="${WORKDIR}/${PN}-${GIT_TAG}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_RADIANT=$(usex gui)
		-DBUILD_TOOLS=$(usex tools)
		-DBUILD_DAEMONMAP=OFF
		-DBUILD_CRUNCH=OFF
		-DBUNDLE_LIBRARIES=OFF
		-DDOWNLOAD_GAMEPACKS=OFF
		-DFHS_INSTALL=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
