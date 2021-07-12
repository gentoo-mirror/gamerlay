# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A game/runtime interpreter for the Adventure Game Studio engine"
HOMEPAGE="http://www.adventuregamestudio.co.uk/"
SRC_URI="https://github.com/adventuregamestudio/ags/archive/refs/tags/v.${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/dumb[allegro]
	media-libs/freetype:2
	media-libs/libogg
	media-libs/libtheora
	media-libs/libvorbis"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-v.${PV}"

src_prepare() {
	default
	sed -i -e "s:-O2 -g -fsigned-char::" Engine/Makefile-defs.linux \
		|| die
}

src_compile() {
	emake --directory=Engine
}

src_install() {
	dobin Engine/ags
	dodoc README.md
}

pkg_postinst() {
	ewarn "In order to play AGS games run command:"
	ewarn "    ${PN} /path/to/gamedir"
	ewarn "or"
	ewarn "    ${PN} /path/to/game.exe"
}
