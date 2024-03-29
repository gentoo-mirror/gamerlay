# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="2D action-adventure game with semil-linear storyline"
HOMEPAGE="https://www.nicalis.com/games/cavestory+"

SLOT="0"
LICENSE="HPND"
KEYWORDS="~amd64 ~x86"
RESTRICT="fetch strip"

SRC_URI="
	${PN}-linux-r${PV}.tar.bz2
"

RDEPEND="
	dev-libs/json-c
	media-libs/flac
	virtual/glu
	media-libs/libogg
	media-libs/libsdl:0
	media-libs/libsndfile
	media-libs/libvorbis
	virtual/opengl
	sys-apps/util-linux
	sys-libs/gdbm
	x11-libs/libdrm
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXtst
	x11-libs/libXxf86vm
	x86? ( x11-libs/libXi )
	amd64? (
		media-libs/aalib
		net-libs/libasyncns
		sys-apps/attr
		sys-apps/dbus
		sys-apps/tcp-wrappers
		sys-libs/gpm
		sys-libs/libcap
		sys-libs/ncurses:0
	)
"
DEPEND="${RDEPEND}"

MY_PN="CaveStory+"
S="${WORKDIR}/${MY_PN/+/Plus}"

pkg_nofetch() {
	ewarn
	ewarn "Please, fetch the package from HB and place it to ${PORTAGE_ACTUAL_DISTDIR}/${A}"
	ewarn
}

src_install() {
	local dir="/opt/${PN}"
	local exe;

	use amd64 && exe="${MY_PN}_64"
	use x86 && exe="${MY_PN}"

	insinto "${dir}"
	doins -r "data"

	exeinto "${dir}"
	doexe "${exe}"

	doicon "${FILESDIR}/${PN}.png"

	make_wrapper "${PN}" "./${exe}" "${dir}"
	doicon "${FILESDIR}/${PN}.png" || die
	make_desktop_entry "${PN}" "${MY_PN}"
}
