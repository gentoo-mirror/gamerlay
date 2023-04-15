# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A mod that attempts to make Doom faster placed, harder, gorier and more violent."
HOMEPAGE="https://www.moddb.com/mods/brutal-doom/"
SRC_URI="https://www.moddb.com/downloads/mirror/95667/130/0a5526fb58bc1f38fee7e14f586ddd7b -> brutalv${PV}.rar"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO Add USEs for gzdoom and skulltag
IUSE=""

RDEPEND="games-fps/gzdoom"
BDEPEND="app-arch/unrar"

S="${WORKDIR}"

src_install() {
	insinto "/usr/share/doom"
	doins brutalv${PV}.pk3
	dodoc "BRUTAL DOOM MANUAL.rtf" "bd21 changelog.txt"
}

pkg_postinst() {
	echo
	elog "In order to play this mod run gzdoom with -file option:"
	elog "    gzdoom -file /usr/share/doom/brutalv${PV}.pk3"
	echo
}
