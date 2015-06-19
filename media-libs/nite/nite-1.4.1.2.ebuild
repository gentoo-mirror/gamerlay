# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/nite/nite-1.4.1.2.ebuild,v 1.2 2011/10/31 09:16:53 frostwork Exp $

EAPI=4

inherit eutils multilib

PRIMESENSEKEY="0KOIk2JeIBYClPWVnMoRKn5cdY4="
MY_PN="nite-bin"
DESCRIPTION="primesense nite kinect drivers"
HOMEPAGE="http://www.openni.org/"
SRC_URI="http://www.openni.org/downloads/${MY_PN}-linux32-v${PV}.tar.bz2"

LICENSE="primesense"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/openni-sensor"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_prepare() {
	sed -i -e "s:insert key here:${PRIMESENSEKEY}:g" -i Data/Sample-Scene.xml
	sed -i -e "s:insert key here:${PRIMESENSEKEY}:g" -i Data/Sample-Tracking.xml
	sed -i -e "s:insert key here:${PRIMESENSEKEY}:g" -i Data/Sample-User.xml
}


src_install() {
	libdir=$(get_libdir)
	dodir /usr/${libdir}
	insinto /usr/${libdir}
	doins Bin/lib* || die
	
	insinto /usr/include/nite
	doins -r Include/* || die

	etcdir_1_3_0=/etc/primesense/Features_1_3_0/
	dodir ${etcdir_1_3_0}
	insinto ${etcdir_1_3_0}
	doins Features_1_3_0/Data/* || die
	
	etcdir_1_3_1=/etc/primesense/Features_1_3_1/
	dodir ${etcdir_1_3_1}
	insinto ${etcdir_1_3_1}
	doins Features_1_3_1/Data/* || die
	
	etcdir_1_4_1=/etc/primesense/Features_1_4_1/
	dodir ${etcdir_1_4_1}
	insinto ${etcdir_1_4_1}
	doins Features_1_4_1/Data/* || die

	etcdir_1_3_0=/etc/primesense/Hands_1_3_0/
	dodir ${etcdir_1_3_0}
	insinto ${etcdir_1_3_0}
	doins Hands_1_3_0/Data/* || die
	
	etcdir_1_3_1=/etc/primesense/Hands_1_3_1/
	dodir ${etcdir_1_3_1}
	insinto ${etcdir_1_3_1}
	doins Hands_1_3_1/Data/* || die
	
	etcdir_1_4_1=/etc/primesense/Hands_1_4_1/
	dodir ${etcdir_1_4_1}
	insinto ${etcdir_1_4_1}
	doins Hands_1_4_1/Data/* || die

	libdir=$(get_libdir)
	dodir /usr/${libdir}
	insinto /usr/${libdir}
	doins Features_1_3_0/Bin/*.so || die
	doins Features_1_3_1/Bin/*.so || die
	doins Features_1_4_1/Bin/*.so || die
	doins Hands_1_3_0/Bin/*.so || die
	doins Hands_1_3_1/Bin/*.so || die
	doins Hands_1_4_1/Bin/*.so || die
		
# todo mono and java?
}

pkg_postinst() {
	VERSIONS="1_3_0 1_3_1 1_4_1"
	LIB1="libXnVFeatures"
	LIB2="libXnVHandGenerator"
	for version in $VERSIONS; do
		printf "registering $LIB1 $version'..."
		/usr/bin/niReg -r /usr/lib/"$LIB1"_"$version".so /etc/primesense/Features_"$version"
		printf "registering $LIB2 $version'..."
		/usr/bin/niReg -r /usr/lib/"$LIB2"_"$version".so /etc/primesense/Hands_"$version"
		printf "OK\n"
	done
	/usr/bin/niLicense PrimeSense ${PRIMESENSEKEY}
}
