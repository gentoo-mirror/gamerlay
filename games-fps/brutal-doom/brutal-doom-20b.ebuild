# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

DESCRIPTION="A mod that attempts to make Doom faster placed, harder, gorier and more violent."
HOMEPAGE="http://www.moddb.com/mods/brutal-doom/"
SRC_URI="http://www.moddb.com/downloads/mirror/95667/102/0a5526fb58bc1f38fee7e14f586ddd7b -> brutal${PV}.zip"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO Add USEs for zdoom and skulltag
IUSE=""

RDEPEND=">=games-fps/zdoom-2.7.0"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto "/usr/share/doom-data"
	doins brutalv${PV}.pk3
	dodoc *.rtf
}

pkg_postinst() {
	echo
	elog "In order to play this mod run zdoom with -file option:"
	elog "    zdoom -file /usr/share/doom-data/brutalv${PV}.pk3"
	echo
}
