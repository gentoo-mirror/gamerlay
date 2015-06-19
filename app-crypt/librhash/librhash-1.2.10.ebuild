# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: app-crypt/librhash-1.2.10.ebuild,v 1.0 2013/04/28 10:15:41 by frostwork Exp $

EAPI="4"

inherit eutils

MY_PN="rhash"

DESCRIPTION="a professional, portable, thread-safe library for computing hash sums"
HOMEPAGE="http://sourceforge.net/projects/${MY_PN}"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}-${PV}-src.tar.gz"

LICENSE="RHash"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/jsoncpp
		net-libs/liboauth
		net-misc/curl
		dev-libs/boost
		dev-libs/tinyxml"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	sed -i -e "s:/usr/local:/usr:" ${PN}/Makefile || die
}

src_compile() {
	cd ${PN}
	emake lib-shared || die "emake failed"
}

src_install() {
	cd ${PN}
	newlib.so ${PN}.so.0 ${PN}.so.0
	newlib.so ${PN}.so ${PN}.so
	insinto /usr/include
	doins rhash.h
}
