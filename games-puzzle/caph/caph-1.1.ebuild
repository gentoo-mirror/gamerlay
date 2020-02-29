# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="sandbox physics game"
HOMEPAGE="http://caphgame.sourceforge.net/"
SRC_URI="https://download.sourceforge.net/caphgame/${PN}/caphgame-${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libpng:=
	media-libs/libsdl"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	cp "${FILESDIR}/Makefile" .
}

src_install() {
	dobin ${PN} || die "dobin failed"
	insinto "/usr/share/"
	doins -r "share/${PN}" || die "doins failed"
	dodoc "doc/${PN}/README" || die "dodoc failed"
}
