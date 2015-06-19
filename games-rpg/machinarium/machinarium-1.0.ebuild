# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit games multilib

DESCRIPTION="Point-and-click adventure about robot in steam-punk world"
HOMEPAGE="http://machinarium.net/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch mirror"
IUSE="multilib"

MY_PN="${PN/ma/Ma}"
SRC_URI="${MY_PN}_full_en.tar.gz"

RDEPEND="
	app-arch/bzip2
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/libffi
	dev-libs/nspr
	dev-libs/nss
	media-libs/fontconfig
	media-libs/freetype:2
	=media-libs/libpng-1.5*
	virtual/opengl
	sys-apps/util-linux
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+
	x11-libs/libdrm
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXxf86vm
	x11-libs/pango
	x11-libs/pixman
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-gtklibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-xlibs
	)
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}"

REQUIRED_USE="amd64? ( multilib )"
pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	exeinto "${dir}"
	doexe "${MY_PN}"
	rm "${MY_PN}"
	doins -r *

	games_make_wrapper "${PN}" "./${MY_PN}" "${dir}"
	doicon "${FILESDIR}/${MY_PN}.png"
	make_desktop_entry "${PN}" "${MY_PN}" "${MY_PN}"

	prepgamesdirs
}
