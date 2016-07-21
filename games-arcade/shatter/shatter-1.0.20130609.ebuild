# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
MULTILIB_COMPAT=( abi_x86_32 )

inherit eutils multilib-minimal unpacker-nixstaller

DESCRIPTION="Retro-inspired brick-breaking game"
HOMEPAGE="http://www.shattergame.com"
SRC_URI="Shatter-Release-2013-06-09.sh"

RESTRICT="fetch strip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	virtual/opengl
	media-gfx/nvidia-cg-toolkit[${MULTILIB_USEDEP}]
	media-libs/fontconfig[${MULTILIB_USEDEP}]
	media-libs/libsdl2[${MULTILIB_USEDEP}]
	media-libs/mesa[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXft[${MULTILIB_USEDEP}]
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
	local dir="/opt/${PN}"
	insinto "${dir}"
	doins -r data pkcmn.pak

	exeinto "${dir}"
	doexe SettingsEditor.bin.x86 Shatter.bin.x86

	# Broken dep
	insinto "${dir}/lib"
	doins lib/libfmod{event,eventnet,ex}-4.36.21.so
	doins lib/libsteam_api.so

	doicon "${MY_PN}.png"
	newicon "Settings.png" "${MY_PN}-Settings.png"

	make_desktop_entry "${PN}" "${MY_PN}" "${MY_PN}"
	make_desktop_entry "${PN}-settings" "${MY_PN} Settings" "${MY_PN}-Settings"

	make_wrapper "${PN}" "./${MY_PN}.bin.x86" "${dir}" "${dir}/lib"
	make_wrapper "${PN}-settings" "./SettingsEditor.bin.x86" "${dir}" "${dir}/lib"

	dodoc README.linux
}
