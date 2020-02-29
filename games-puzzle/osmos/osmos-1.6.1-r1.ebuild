# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

MY_PN="Osmos"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Play as a single-celled organism absorbing others"
HOMEPAGE="http://www.hemispheregames.com/osmos/"
SRC_URI="${MY_P}.tar.gz"

LICENSE="OSMOS"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch strip"

RDEPEND="
	virtual/opengl
	virtual/glu
	x11-libs/libX11
	media-libs/freetype:2
	sys-libs/glibc
	media-libs/openal
	media-libs/libvorbis
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}"

pkg_nofetch() {
	einfo "Please download ${MY_P}.tar.gz and place it into ${DISTDIR}"
}

src_install() {
	local dir="/opt/${PN}"
	local exe

	if use amd64 ; then
		exe="${MY_PN}.bin64"
	fi
	if use x86 ; then
		exe="${MY_PN}.bin32"
	fi

	exeinto "${dir}"
	doexe "${exe}" || die "doexe"

	dodoc readme.html
	insinto "${dir}"
	doins -r Fonts/ Sounds/ Textures/ Osmos-* *.cfg || die "doins failed"

	newicon "Icons/256x256.png" "${PN}.png"

	make_wrapper "${PN}" "./${exe}" "${dir}"
	make_desktop_entry "${PN}" "Osmos"
}
