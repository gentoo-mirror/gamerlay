# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

DESCRIPTION="A vibrant, side-scrolling strategy game."
HOMEPAGE="http://www.swordsandsoldiers.com/"
SRC_URI="
		x86? ( ${P}-i386.tar.gz )
		amd64? ( ${P}-amd64.tar.gz )
"
RESTRICT="fetch strip"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	app-arch/bzip2
	dev-libs/expat
	dev-libs/json-c
	media-libs/aalib
	media-libs/alsa-lib
	media-libs/flac
	media-libs/fontconfig
	media-libs/freetype
	media-libs/glu
	media-libs/libogg
	media-libs/libsdl
	media-libs/libsndfile
	media-libs/libvorbis
	virtual/opengl
	media-libs/openal
	media-sound/pulseaudio
	net-libs/libasyncns
	sys-apps/attr
	sys-apps/dbus
	sys-apps/tcp-wrappers
	sys-apps/util-linux
	sys-devel/gcc
	sys-libs/gdbm
	sys-libs/glibc
	sys-libs/gpm
	sys-libs/libcap
	sys-libs/ncurses
	sys-libs/zlib
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
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXxf86vm
"

S="${WORKDIR}/${PN}"

DOCS=( "README.linux" )

pkg_nofetch() {
	ewarn
	ewarn "Put ${A} (downloaded from Humble Store) to ${DISTDIR}, please"
	ewarn
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	newicon "SwordsAndSoldiers.png" "${PN}.png"
	newicon "SwordsAndSoldiersSetup.png" "${PN}-setup.png"
	make_desktop_entry "${PN}" "Swords & Soldiers" "${PN}"
	make_desktop_entry "${PN}-setup" "Swords & Soldiers (setup)" "${PN}-setup"
	make_wrapper "${PN}" "./SwordsAndSoldiers.bin" "${dir}"
	make_wrapper "${PN}-setup" "./SwordsAndSoldiersSetup.bin" "${dir}"
	exeinto "${dir}"
	insinto "${dir}"
	doins -r "Data"
	doins "SwordsAndSoldiers.png"
	doins "SwordsAndSoldiersSetup.png"
	doexe "./SwordsAndSoldiers.bin"
	doexe "./SwordsAndSoldiersSetup.bin"
}
