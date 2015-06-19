# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Files extractor and reimporter, archives and file formats parser"
HOMEPAGE="http://aluigi.altervista.org/quickbms.htm"
SRC_URI="http://aluigi.altervista.org/papers/${PN}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/bzip2
	dev-libs/openssl
	sys-libs/zlib"
RDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
	sed -i "/^CFLAGS/d" src/Makefile || die "sed failed"
}

src_compile() {
	cd src
	emake || die "emake failed"
}

src_install() {
	dobin src/${PN}
	dodoc quickbms.txt
}
