# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/grfcodec/grfcodec-0_pre2306.ebuild,v 1.6 2010/05/28 18:14:22 josejx Exp $

EAPI=2
inherit toolchain-funcs flag-o-matic

MY_PV=${PV/_rc/-RC}
DESCRIPTION="A suite of programs to modify openttd/Transport Tycoon Deluxe's GRF files"
HOMEPAGE="http://binaries.openttd.org/extra/grfcodec/"
SRC_URI="http://binaries.openttd.org/extra/${PN}/${MY_PV}/${PN}-${MY_PV}-source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}-${MY_PV}-source

DEPEND="dev-lang/perl
	dev-libs/boost"
RDEPEND=""

src_prepare() {
# workaround upstream workflow by setting CC to the C++ compiler and CFLAGS to ${CXXFLAGS}
# This is actually what they do in Makefile now, we set CC = $(tc-getCC) previously.
cat > Makefile.local <<-__EOF__
		CC = $(tc-getCXX)
		CXX = $(tc-getCXX)
		CFLAGS = ${CXXFLAGS}
		CXXFLAGS = ${CXXFLAGS}
		LDOPT = ${LDFLAGS}
		STRIP = :
		UPX =
		V = 1
	__EOF__
}

src_install() {
	dobin ${PN} grf{diff,id,merge} || die
	doman docs/grf{codec,diff,id,merge}.1 || die
	dodoc changelog.txt docs/*.txt || die
}
