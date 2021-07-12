# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Alex the Allegator 4 - Plenty of classic platforming in four nice colors!"
HOMEPAGE="http://allegator.sourceforge.net"
SRC_URI="https://github.com/carstene1ns/alex4/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/dumb[allegro]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}_gcc10.patch" )

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" PREFIX="/usr"
}

src_install() {
	emake install PREFIX="/usr" DESTDIR="${D}"
	dodoc readme.txt
}
