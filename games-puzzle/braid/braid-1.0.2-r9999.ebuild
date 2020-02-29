# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker

DESCRIPTION="Platform game where you manipulate flow of time"
HOMEPAGE="http://braid-game.com"
SRC_URI="${PN}-linux-build$(ver_cut 3).run.bin
	l10n_ru? ( ${PN}-rus.tar.bz2 )"

LICENSE="Arphic MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="l10n_ru"
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

S="${WORKDIR}/data"

pkg_nofetch() {
	echo
	elog "Download ${SRC_URI} from ${HOMEPAGE} and place it in ${DISTDIR}"
	echo
}

src_unpack() {
	local a="${DISTDIR}/${PN}-linux-build${MY_PV}.run.bin"
	unpack_zip "${a}"

	if use l10n_ru; then
		unpack "${PN}-rus.tar.bz2"
		mv "${S}/package0.zip" "${S}/gamedata/data"
		mv "${S}/strings/english.mo" "${S}/gamedata/data/strings"
	fi
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	exeinto "${dir}"

	doins -r gamedata/data
	use x86 && doexe x86/"${PN}"
	use amd64 && doexe amd64/"${PN}"

	doicon gamedata/"${PN}.png"
	dodoc gamedata/README-linux.txt

	make_wrapper "${PN}" "./${PN}" "${dir}"
	make_desktop_entry "${PN}" "Braid" "${PN}"
}
