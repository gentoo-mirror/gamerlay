# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit games multilib unpacker-nixstaller

DESCRIPTION="3d action-adventure game. Spiritual successor to Lugaru."
HOMEPAGE="http://www.wolfire.com/overgrowth/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch strip"
IUSE="video_cards_intel video_cards_nouveau video_cards_radeon video_cards_nvidia"

QA_PRESTRIPPED="${GAMES_PREFIX_OPT}/${PN}/lib.*"
SRC_URI="${PN}-a194-linux.sh"

RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	media-libs/freeimage
	media-libs/freetype:2
	media-libs/ilmbase
	virtual/jpeg
	media-libs/lcms
	media-libs/libogg
	media-libs/libpng
	media-libs/libraw
	media-libs/libvorbis
	virtual/opengl
	media-libs/openal
	media-libs/openexr
	media-libs/openjpeg
	media-libs/tiff
	sys-libs/zlib
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXxf86vm
	video_cards_intel? ( media-libs/libtxc_dxtn )
	video_cards_nouveau? ( media-libs/libtxc_dxtn )
	video_cards_radeon? ( media-libs/libtxc_dxtn )
	video_cards_nvidia? ( x11-drivers/nvidia-drivers )
"
#=media-libs/libsdl-9999 (untill 2.0 will be added to the tree).
DEPEND="${RDEPEND}"

S="${WORKDIR}"
#MY_PN=""

pkg_nofetch() {
        ewarn
        ewarn "Place ${A} to ${DISTDIR}"
        ewarn
}

src_unpack() {
	# FIXME !!!!
	die "Package is disabled, while waiting new fixed distfile from upstream"
	local arch;
	use amd64 && arch=x86_64 || arch=x86
	nixstaller_unpack "subarch" \
		"instarchive_all" \
		"instarchive_linux_${arch}" #\
#		"deps/SDL2/SDL2_files_linux_${arch}"
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	local arch;
	use amd64 && arch=x86_64 || arch=x86

	insinto "${dir}"
	doins \
		"${PN}.dat" \
		"${PN}.png"

	exeinto "${dir}"
	doexe \
		"${MY_PN}.bin.${arch}"

	exeinto "${dir}/$(get_libdir)"
	doexe \
		"$(get_libdir)/libSDL2-2.0.so.0"

	games_make_wrapper "${PN}" "./${MY_PN}.bin.${arch}" "${dir}" "${dir}/$(get_libdir)"
	doicon "${PN}.png" || die
	make_desktop_entry "${PN}" "${MY_PN}"

	dodoc README.linux
	prepgamesdirs
}
