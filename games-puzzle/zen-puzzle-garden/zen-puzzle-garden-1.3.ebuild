# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games

DESCRIPTION="Try to solve seemingly impossible puzzles that take place in a relaxing zen garden."
HOMEPAGE="http://www.lexaloffle.com/zen.htm"
SRC_URI="${PN}_${PV}_i386.tar.gz"
RESTRICT="fetch"

LICENSE="Voxatron"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	x86? ( media-libs/libsdl
		x11-libs/libX11
		x11-libs/libxcb
	)
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-soundlibs
		app-emulation/emul-linux-x86-xlibs )"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

S="${WORKDIR}/${PN}"

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	insinto ${dir}
	doins zen.dat
	exeinto ${dir}
	doexe zen
	games_make_wrapper ${PN} ./zen ${dir} ${dir}
	newicon lexaloffle-zen.png ${PN}.png
	make_desktop_entry "${PN}" "Zen Puzzle Garden" "${PN}"
	dodoc ${PN}.txt
	prepgamesdirs
}
