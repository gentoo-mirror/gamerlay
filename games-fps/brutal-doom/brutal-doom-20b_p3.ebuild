# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV=${PV/p/R}

DESCRIPTION="A mod that attempts to make Doom faster placed, harder, gorier and more violent."
HOMEPAGE="http://www.moddb.com/mods/brutal-doom/"
SRC_URI="http://www.moddb.com/downloads/mirror/122563/102/d740616df58ec6ef1495c9b094f06b13 -> BrutalDoomv${MY_PV}.zip"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO Add USEs for zdoom and skulltag
IUSE=""

RDEPEND="|| (
	>=games-fps/zdoom-2.7.0
	>=games-fps/gzdoom-3.0.0 )
	"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto "/usr/share/doom-data"
	doins brutalv20b_R.pk3
}

pkg_postinst() {
	echo
	elog "In order to play this mod run zdoom with -file option:"
	elog "    [g]zdoom -file /usr/share/doom-data/brutalv20b_R.pk3"
	echo
}
