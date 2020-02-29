# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker-nixstaller

TIMESTAMP="2012-12-28"
MY_PN="${PN/c/C}"

DESCRIPTION="Play as a strange demon who explores the stories of three human characters."
HOMEPAGE="http://closuregame.com/"
SRC_URI="${MY_PN}-Linux-${PV}-${TIMESTAMP}.sh"

RESTRICT="fetch strip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/json-c
	media-gfx/nvidia-cg-toolkit
	media-libs/aalib
	media-libs/alsa-lib
	media-libs/flac
	media-libs/freealut
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
"

S="${WORKDIR}"

#QA_TEXTRELS=""

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

src_unpack() {
	local arch=x86
	use amd64 && arch=x86_64
	nixstaller_unpack \
		instarchive_all \
		instarchive_linux_${arch}
}

src_install() {
	local arch=x86
	use amd64 && arch=x86_64

	local dir="/opt/${PN}"
	insinto "${dir}"
	doins -r resources

	exeinto "${dir}"
	doexe "${MY_PN}.bin.${arch}"

	doicon "${MY_PN}.png"
	make_desktop_entry "${PN}" "${MY_PN}" "${MY_PN}"
	make_wrapper "${PN}" "./${MY_PN}.bin.${arch}" "${dir}"
}
