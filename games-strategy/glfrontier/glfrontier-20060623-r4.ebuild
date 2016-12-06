# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils

MY_PN=glfrontier
MY_P=${MY_PN}-${PV}
DESCRIPTION="Frontier: Elite 2 with OpenGL support"
HOMEPAGE="http://tom.noflag.org.uk/glfrontier.html"

SRC_URI="http://tom.noflag.org.uk/glfrontier/frontvm3-20060623.tar.bz2
         http://tom.noflag.org.uk/misc/frontvm-audio-20060222.tar.bz2"


LICENSE="GPL"
KEYWORDS="~x86 ~amd64"
IUSE=""

SLOT="0"

RDEPEND=">=media-libs/freeglut-2.6
         media-libs/libsdl
         media-libs/libogg"
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}/${MY_P}"-fix_missing_math_lib.patch
	eapply_user
}

src_compile() {
	cd ${S}/frontvm3-20060623
	make -f Makefile-C || die "make install failed"
}

src_install() {
	mv ${S}/frontvm3-20060623/frontier ${S}/frontvm3-20060623/${MY_PN}

	dobin ${S}/frontvm3-20060623/${MY_PN}
	insinto /usr/share/${MY_PN}
	doins ${S}/frontvm3-20060623/fe2.s.bin
	doins -r ${S}/frontvm-audio-20060222/*

	make_desktop_entry /usr/share/${MY_PN}/${MY_PN} GLFrontier ${MY_PN} Game Path=/usr/share/${MY_PN}
}
