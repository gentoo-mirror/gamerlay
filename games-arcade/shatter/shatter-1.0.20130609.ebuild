# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit games unpacker-nixstaller

DESCRIPTION="Retro-inspired brick-breaking game"
HOMEPAGE="http://www.shattergame.com"
SRC_URI="Shatter-Release-2013-06-09.sh"

RESTRICT="fetch strip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	x86? (
		virtual/opengl
		dev-libs/expat
		media-gfx/nvidia-cg-toolkit
		media-libs/fontconfig
		media-libs/freetype:2
		media-libs/libsdl
		net-dns/libidn
		sys-libs/zlib
		x11-libs/libdrm
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libxcb
	)
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-xlibs
	)
"

S="${WORKDIR}"
MY_PN=Shatter

# TODO: make fmod multilib

QA_TEXTRELS="
	opt/shatter/lib/libfmodex-4.36.21.so
	opt/shatter/lib/libfmodeventnet-4.36.21.so
	opt/shatter/lib/libfmodevent-4.36.21.so
"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

src_unpack() {
	nixstaller_unpack \
		instarchive_all \
		instarchive_linux_all
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	insinto "${dir}"
	doins -r data pkcmn.pak

	exeinto "${dir}"
	doexe SettingsEditor.bin.x86 Shatter.bin.x86

	# Broken dep
	insinto "${dir}/lib"
	doins lib/libfmod{event,eventnet,ex}-4.36.21.so
	# Only for AMD64
	use amd64 && doins lib/libCg{,GL}.so

	doicon "${MY_PN}.png"
	newicon "Settings.png" "${MY_PN}-Settings.png"
	make_desktop_entry "${PN}" "${MY_PN}" "${MY_PN}"
	make_desktop_entry "${PN}-settings" "${MY_PN} Settings" "${MY_PN}-Settings"
	games_make_wrapper "${PN}" "./${MY_PN}.bin.x86" "${dir}" "${dir}/lib"
	games_make_wrapper "${PN}-settings" "./SettingsEditor.bin.x86" "${dir}" "${dir}/lib"

	dodoc README.linux
	prepgamesdirs
}
