# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

MY_PN=LoneSurvivor
MY_PV=${PV/_p/-}

DESCRIPTION="2D sidescrolling psychological survival adventure game"
HOMEPAGE="http://www.lonesurvivor.co.uk/"
SRC_URI="amd64? ( ${PN}-${MY_PV}-amd64.tar.gz )
	x86? ( ${PN}-${MY_PV}-i386.tar.gz )"

LICENSE="HPND"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="app-arch/bzip2
	media-libs/freetype:2
	media-libs/libpng:0
	sys-libs/zlib
	x11-libs/gtk+:2
	virtual/opengl"

S="${WORKDIR}/${PN}"

RESTRICT="fetch strip"

pkg_nofetch() {
	ewarn "Please place ${A} to ${DISTDIR}"
}

src_install() {
	local dir="/opt/${MY_PN}"
	dodoc README
	exeinto ${dir}
	doexe ${MY_PN}
	doicon ${MY_PN}.png
	make_wrapper ${PN} ./${MY_PN} "${dir}" "${dir}"
	make_desktop_entry ${PN} ${MY_PN} ${MY_PN}

}
