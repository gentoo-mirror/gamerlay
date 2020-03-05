# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="A voxelicious action adventure"
HOMEPAGE="http://www.lexaloffle.com/voxatron.php"
SRC_URI="${PN}_${PV}_i386.tar.gz"
RESTRICT="fetch"

LICENSE="Voxatron"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[${MULTILIB_USEDEP},opengl]
"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

S="${WORKDIR}/${PN}"

src_install() {
	local dir="/opt/${PN}"
	insinto ${dir}
	doins vox.dat
	exeinto ${dir}
	doexe vox
	newicon lexaloffle-vox.png ${PN}.png
	make_desktop_entry ${PN} Voxatron ${PN}
	make_wrapper ${PN} ./vox ${dir} ${dir}
	dodoc ${PN}.txt
}
