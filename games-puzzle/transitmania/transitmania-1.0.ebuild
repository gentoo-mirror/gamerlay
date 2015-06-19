# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games

DESCRIPTION="a puzzle game that slihtly resembles the old Pipemania classic game"
HOMEPAGE="http://transit-mania.sourceforge.net"
# temporary SRC_URI - contacted the autthor, if he wants to host the file on his sf page
SRC_URI="http://frostworx.de/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/allegro"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "s:data1.dat:"${GAMES_DATADIR}"/"${PN}"/data1.dat:g" -i main.c
	sed -i -e "s:data2.dat:"${GAMES_DATADIR}"/"${PN}"/data2.dat:g" -i main.c
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	local datadir="${GAMES_DATADIR}"/${PN}
	insinto "${datadir}"
	doins *.dat || die "data install failed"
	exeinto "${GAMES_DATADIR}"/${PN}
	dogamesbin ${PN}
	make_desktop_entry "${PN}" "${PN}"
	dodoc readme.txt
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
