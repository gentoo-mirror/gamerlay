# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games

DESCRIPTION="A mod that attempts to make Doom faster placed, harder, gorier and more violent."
HOMEPAGE="http://www.moddb.com/mods/brutal-doom/"
SRC_URI="http://www.moddb.com/downloads/mirror/61237/73/11c6b91e5d60fdfd4a16333eac63e390 -> brutal${PV}.zip"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO Add USEs for zdoom and skulltag
IUSE=""

RDEPEND=">=games-fps/zdoom-2.7.0"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto "${GAMES_DATADIR}/doom-data"
	doins brutal${PV}.pk3
	dodoc *.txt
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "In order to play this mod run zdoom with -file option:"
	elog "    zdoom -file ${GAMES_DATADIR}/doom-data/brutal${PV}.pk3"
	echo
}
