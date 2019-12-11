# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit games multilib unpacker-nixstaller

TIMESTAMP="2013-05-21"

DESCRIPTION="An action role-playing game, made by the creators of Diablo"
HOMEPAGE="http://torchlightgame.com/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch"

SRC_URI="Torchlight-${TIMESTAMP}.sh"

RDEPEND="app-arch/bzip2
	app-arch/xz-utils
	dev-libs/expat
	dev-libs/zziplib
	media-libs/fontconfig
	media-libs/freeimage
	media-libs/freetype
	media-libs/ilmbase
	media-libs/lcms
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/libraw
	media-libs/openexr
	media-libs/openjpeg
	media-libs/tiff
	sys-apps/util-linux
	sys-libs/zlib
	x11-libs/libdrm
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXaw
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}"

S="${WORKDIR}"
MY_PN="Torchlight"

QA_PRESTRIPPED="
opt/torchlight/lib64/*
opt/torchlight/lib/*
"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

src_unpack() {
	local arch;
	use x86 && arch="x86"
	use amd64 && arch="x86_64"

	nixstaller_unpack "subarch" \
			"instarchive_all" \
			"instarchive_linux_${arch}" \
			"deps/Ogre/Ogre_files_linux_${arch}" \
			"deps/fmod/fmod_files_linux_${arch}" \
			"deps/pcre/pcre_files_linux_${arch}" \
			"deps/SDL2/SDL2_files_linux_${arch}" \
			"deps/CEGUI/CEGUI_files_linux_${arch}" \
			"deps/GLUT/GLUT_files_linux_${arch}"
	# We just installed some crap to avoid broken depends
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	doins -r icons music logo.bmp pak.zip resources.cfg "$(get_libdir)"
	exeinto "${dir}"

	local exe
	if use amd64 ; then
		exe="${MY_PN}".bin.x86_64
	fi
	if use x86 ; then
		exe="${MY_PN}".bin.x86
	fi

	doexe "${exe}"

	games_make_wrapper "${PN}" "./${exe}" "${dir}" "${dir}/$(get_libdir)"
	doicon "${MY_PN}.png" || die
	make_desktop_entry "${PN}" "${MY_PN}" "${MY_PN}"

	dodoc README.linux
	prepgamesdirs
}
