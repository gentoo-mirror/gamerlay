# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils

DESCRIPTION="A Library of Bullet Markup Language"
HOMEPAGE="http://user.ecc.u-tokyo.ac.jp/~s31552/wp/libbulletml/index_en.html"
SRC_URI="
	mirror://debian/pool/main/b/${PN#lib}/${PN#lib}_${PV}.orig.tar.gz
	mirror://debian/pool/main/b/${PN#lib}/${PN#lib}_${PV}-6.1.debian.tar.bz2
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

S="${WORKDIR}/${PN#lib}"

PATCHES=(
	"${WORKDIR}/debian/patches"
	"${FILESDIR}/${P}-gcc43.patch"
)

src_prepare(){
	sed -i -e "s:\MAJOR=0d2:\MAJOR=0:g" -i "${WORKDIR}"/debian/patches/makefile.patch
	default
}

src_compile() {
	emake -C src CFLAGS="${CFLAGS} -fPIC" CXXFLAGS="${CXXFLAGS} -fPIC" LDFLAGS="${LDFLAGS} -fPIC" || die "emake failed"
}

src_install() {
	cd "${S}/src"

	dolib.a libbulletml.a
	dolib libbulletml.so*

	insinto /usr/include/bulletml
	doins *.h

	insinto /usr/include/bulletml/tinyxml
	doins tinyxml/tinyxml.h

	insinto /usr/include/bulletml/ygg
	doins ygg/ygg.h

	dodoc ../README*
}
