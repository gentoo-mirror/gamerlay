# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit unpacker games versionator

MY_PV="$(get_version_component_range 3)"

DESCRIPTION="Platform game where you manipulate flow of time"
HOMEPAGE="http://braid-game.com"
SRC_URI="${PN}-linux-build${MY_PV}.run.bin
	linguas_ru? ( ${PN}-rus.tar.bz2 )"

LICENSE="Arphic MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="linguas_ru"
RESTRICT="strip fetch"

DEPEND="app-arch/unzip"
RDEPEND="media-libs/libsdl[joystick,sound,video]
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdmcp
	x11-libs/libXext
	virtual/opengl
	media-gfx/nvidia-cg-toolkit"

S=${WORKDIR}/data

pkg_nofetch() {
	echo
	elog "Download ${SRC_URI} from ${HOMEPAGE} and place it in ${DISTDIR}"
	echo
}

src_unpack() {
	local a="${DISTDIR}/${PN}-linux-build${MY_PV}.run.bin"
	unpack_zip "${a}"

	if use linguas_ru; then
		unpack "${PN}-rus.tar.bz2"
		mv "${S}/package0.zip" "${S}/gamedata/data"
		mv "${S}/strings/english.mo" "${S}/gamedata/data/strings"
	fi
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	exeinto "${dir}"

	doins -r gamedata/data
	use x86 && doexe x86/"${PN}"
	use amd64 && doexe amd64/"${PN}"

	doicon gamedata/"${PN}.png"
	dodoc gamedata/README-linux.txt

	games_make_wrapper "${PN}" "./${PN}" "${dir}"
	make_desktop_entry "${PN}" "Braid" "${PN}"

	prepgamesdirs
}
