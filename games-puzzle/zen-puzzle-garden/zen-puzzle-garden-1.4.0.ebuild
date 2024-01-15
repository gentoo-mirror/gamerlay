# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="Try to solve puzzles that take place in a relaxing zen garden."
HOMEPAGE="http://www.lexaloffle.com/zen.htm"
SRC_URI="amd64? ( ${PN}_${PV}_amd64.zip )
	x86? ( ${PN}_${PV}_i386.zip )"
RESTRICT="fetch"

LICENSE="Voxatron"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
RDEPEND="media-libs/libsdl
	x11-libs/libX11
	x11-libs/libxcb"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${PORTAGE_ACTUAL_DISTDIR}"
	ewarn
}

S="${WORKDIR}/${PN}"

src_install() {
	local dir="/opt/${PN}"
	insinto ${dir}
	doins zen.dat
	exeinto ${dir}
	doexe zen
	make_wrapper ${PN} ./zen ${dir} ${dir}
	newicon lexaloffle-zen.png ${PN}.png
	make_desktop_entry "${PN}" "Zen Puzzle Garden" "${PN}"
	dodoc zen.txt
}
