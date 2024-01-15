# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="A calm and meditative game of wrapping rope around wooden sculptures."
HOMEPAGE="http://zenbound.com/"
SRC_URI="
	x86? ( ${P}-i386.tar.gz )
	amd64? ( ${P}-amd64.tar.gz )
"

LICENSE="all-rights-reserved"
SLOT="0"
RESTRICT="fetch"
KEYWORDS="~amd64 ~x86"

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
	media-libs/libsdl:0
	media-libs/libsndfile
	media-libs/libvorbis
	virtual/opengl
	media-libs/openal
	media-sound/pulseaudio
	net-libs/libasyncns
	sys-apps/attr
	sys-apps/dbus
	sys-libs/gdbm
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
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXxf86vm
"

S="${WORKDIR}/${PN}"
DOCS=( README.linux )
MY_PN="ZenBound2"

src_install() {
	local lib="$(get_libdir)"
	local dir="/opt/${PN}"

	# Unbundling
	rm "./${lib}/libopenal.so.1"
	rm "./${lib}/libSDL-1.2.so.0"
	rm "./${lib}/libvorbis.so.0"
	rm "./${lib}/libvorbisfile.so.3"
	rm "./${lib}/libogg.so.0"

	newicon "${MY_PN}.png" "${PN}.png"
	exeinto "${dir}"
	insinto "${dir}"
	doins -r "data_common"
	doins -r "data_desktop"
	doexe "${MY_PN}.bin"

	# install shortcuts
	make_wrapper "${PN}" "./${MY_PN}.bin" "${dir}" "${dir}/${lib}" || die "install shortcut"
	make_desktop_entry "${PN}" "${MY_PN}" "${PN}"
}
