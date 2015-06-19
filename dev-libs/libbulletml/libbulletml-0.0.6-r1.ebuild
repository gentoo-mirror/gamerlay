# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libbulletml/libbulletml-0.0.6-r1.ebuild,v 1.6 2009/08/27 15:47:32 frostwork Exp $

EAPI="2"

inherit eutils

DESCRIPTION="A Library of Bullet Markup Language"
HOMEPAGE="http://user.ecc.u-tokyo.ac.jp/~s31552/wp/libbulletml/index_en.html"
SRC_URI="mirror://debian/pool/main/b/${PN#lib}/${PN#lib}_${PV}.orig.tar.gz
	mirror://debian/pool/main/b/${PN#lib}/${PN#lib}_${PV}-4.diff.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

S="${WORKDIR}/${PN#lib}-${PV}/src"

src_unpack() {
	unpack ${A}
}
src_prepare(){
	epatch "${WORKDIR}"/${PN#lib}_${PV}-4.diff
	mv "${WORKDIR}"/${PN#lib}/* "${WORKDIR}"/${PN#lib}-${PV}
	sed -i -e "s:\MAJOR=0d2:\MAJOR=0:g" -i "${WORKDIR}"/${PN#lib}-${PV}/debian/patches/makefile.patch
	epatch "${WORKDIR}"/${PN#lib}-${PV}/debian/patches/fixes.patch
	epatch "${WORKDIR}"/${PN#lib}-${PV}/debian/patches/bulletml_d.patch
	epatch "${WORKDIR}"/${PN#lib}-${PV}/debian/patches/d_cpp.patch
	epatch "${WORKDIR}"/${PN#lib}-${PV}/debian/patches/warnings.patch
	epatch "${WORKDIR}"/${PN#lib}-${PV}/debian/patches/makefile.patch
	epatch "${WORKDIR}"/${PN#lib}-${PV}/debian/patches/includes.patch
	cd "${S}"
	epatch "${WORKDIR}"/${PN#lib}-${PV}/debian/patches/get-rid-of-boost.patch
	epatch "${FILESDIR}"/${P}-gcc43.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	dolib.a libbulletml.a || die "dolib.a failed"
	dolib libbulletml.so.0.0 libbulletml.so libbulletml.so.0 || die "dolib failed"

	insinto /usr/include/bulletml
	doins *.h || die "doins .h failed"

	insinto /usr/include/bulletml/tinyxml
	doins tinyxml/tinyxml.h || die "doins tinyxml.h failed"

	insinto /usr/include/bulletml/ygg
	doins ygg/ygg.h || die "doins ygg.h failed"

	dodoc ../README*
}
