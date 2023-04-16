# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg-utils

DESCRIPTION="An unique puzzle game with the goal to reduce a 3D shape to a single square"
HOMEPAGE="http://phlipple.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl:0
	media-libs/sdl-image:0
	media-libs/sdl-mixer:0
	media-libs/sdl-ttf:0
	virtual/opengl
	virtual/glu
"

src_prepare() {
	default
	eapply "${FILESDIR}/${P}_check-math-lib.patch"
	# fix fails to link on new glibc
	eapply "${FILESDIR}/${P}_bug857397.patch"
	eautoreconf
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
