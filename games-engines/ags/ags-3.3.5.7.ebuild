# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A game/runtime interpreter for the Adventure Game Studio engine"
HOMEPAGE="http://www.adventuregamestudio.co.uk/ http://www.adventuregamestudio.co.uk/"
SRC_URI="https://github.com/adventuregamestudio/ags/releases/download/v.${PV}/${PN}_linux_v.${PV}.tar.xz"

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

S="${WORKDIR}/${PN}_linux_v.${PV}"

src_prepare() {
	eapply_user
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
