# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

DESCRIPTION="super hero shoot em up"
HOMEPAGE="http://www.super-tirititran.com"
SRC_URI="mirror://sourceforge/${PN}/${PN}-09-linux-sources.tar.gz"
LICENSE="CPL-1.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	dev-libs/expat"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}/${P}_lm.patch" )

src_install() {
	dobin supertirititran
	dodoc README
	insinto "/usr/share/${PN}"
	doins -r data || die
	doicon "${FILESDIR}/${PN}.png"
	make_desktop_entry ${PN} ${PN}
}
