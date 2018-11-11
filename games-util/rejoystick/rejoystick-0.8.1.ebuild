# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="Tool which translates gamepad/joystick input into key strokes/mouse actions in X"
HOMEPAGE="http://rejoystick.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/gtk+:2
	x11-libs/gdk-pixbuf:2
	x11-libs/libXtst
	x11-libs/libX11
	media-libs/libsdl[joystick]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# dirty hack
	sed -r \
		-e '/version.mk/s@\.\ version.mk@eval $(cat version.mk)@' \
		-e '/^\t\tCFLAGS.*-s"$/s@-s@@' \
		-e "/-O2/s@-O2@${CFLAGS}@g" \
		-e '/INSTALL_STRIP_PROGRAM/s@-s@@' \
		-i configure

	sed -r \
		-e '/^LIBS/s@$@ -lX11@' \
		-i {,src/}Makefile.in
	# /dirty hack

	default
}

src_configure() {
	append-cflags "-Wno-implicit-function-declaration"
	econf --disable-dependency-tracking --with-x --with-pic
}
