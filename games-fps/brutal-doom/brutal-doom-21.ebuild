# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A mod that attempts to make Doom faster placed, harder, gorier and more violent."
HOMEPAGE="http://www.moddb.com/mods/brutal-doom/"
SRC_URI="https://www.moddb.com/downloads/mirror/95667/100/b8fb37ddb10c39462f9625533fab59d2 -> brutalv${PV}.rar"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO Add USEs for zdoom and skulltag
IUSE=""

RDEPEND=">=games-fps/zdoom-2.7.0"
DEPEND="app-arch/unrar"

S="${WORKDIR}"

src_install() {
	insinto "/usr/share/doom-data"
	doins brutalv${PV}.pk3
	dodoc "BRUTAL DOOM MANUAL.rtf" "bd21 changelog.txt"
}

pkg_postinst() {
	echo
	elog "In order to play this mod run gzdoom with -file option:"
	elog "    gzdoom -file /usr/share/doom-data/brutalv${PV}.pk3"
	echo
}
