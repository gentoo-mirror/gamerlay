# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games

MY_PV=${PV/_p/-hotfix}

DESCRIPTION="A game/runtime interpreter for the Adventure Game Studio engine"
HOMEPAGE="http://www.adventuregamestudio.co.uk/"
SRC_URI="https://github.com/adventuregamestudio/ags/archive/v.${MY_PV}.tar.gz -> ${PN}-v.${MY_PV}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=media-libs/aldumb-0.9.3
	media-libs/allegro:0
	>=media-libs/dumb-0.9.3
	media-libs/freetype:2
	media-libs/libogg
	media-libs/libtheora
	media-libs/libvorbis"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-v.${MY_PV}"

src_prepare() {
	sed -i -e "s:-O2 -g -fsigned-char::" Engine/Makefile-defs.linux \
		|| die
}

src_compile() {
	emake --directory=Engine
}

src_install() {
	dogamesbin Engine/ags
	dodoc README.md
}

pkg_postinst() {
	ewarn "In order to play AGS games run command:"
	ewarn "    ${PN} /path/to/gamedir"
	ewarn "or"
	ewarn "    ${PN} /path/to/game.exe"
	games_pkg_postinst
}
