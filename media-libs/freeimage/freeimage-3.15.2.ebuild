# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils flag-o-matic toolchain-funcs multilib

MY_PN=FreeImage
MY_PV=${PV//.}
DESCRIPTION="Image library supporting many formats"
HOMEPAGE="http://freeimage.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}${MY_PV}.zip
	doc? ( mirror://sourceforge/${PN}/${MY_PN}${MY_PV}.pdf )
	http://ftp.gentoo.ru/people/winterheart/distfiles/${MY_PN}-${PV}-patches.tar.bz2"

LICENSE="|| ( GPL-2 GPL-3 FIPL-1.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cxx doc"

RDEPEND="
	virtual/jpeg
	>=media-libs/libpng-1.5.4
	>=media-libs/tiff-4
	sys-libs/zlib
	media-libs/openjpeg
	media-libs/openexr"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	append-cflags -std=c99 -D_POSIX_SOURCE # silence warnings from gcc
	EPATCH_SOURCE="${WORKDIR}/${MY_PN}-${PV}-patches" EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" epatch
}

src_compile() {
	emake -f Makefile.gnu || die "emake failed"
	if use cxx ; then
		emake -f Makefile.fip || die "emake fip failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" INSTALLDIR="${D}/usr/$(get_libdir)" \
		-f Makefile.gnu install || die
	if use cxx ; then
		emake DESTDIR="${D}" INSTALLDIR="${D}/usr/$(get_libdir)" \
			-f Makefile.fip install
	fi
	dodoc README.linux Whatsnew.txt
	use doc && dodoc "${DISTDIR}"/${MY_P}.pdf

	ebegin "Installing pkg-config file"
	dodir /usr/$(get_libdir)/pkgconfig
	sed \
		-e "s:@LIBDIR@:$(get_libdir):" \
		-e "s:@PACKAGENAME@:${MY_PN}:" \
		-e "s:@DESCRIPTION@:${DESCRIPTION}:" \
		-e "s:@REQUIRES@:OpenEXR libpng:" \
		-e "s:@VERSION@:${PV}:" \
		-e "s:@LIBS@:-lfreeimage:" \
		-e "s:@EXTLIBS@:-ljpeg -ltiff -lopenjpeg -lz:" \
		"${FILESDIR}/${PN}.pc.in" > "${D}/usr/$(get_libdir)/pkgconfig/${PN}.pc"	|| die
	PKG_CONFIG_PATH="${D}/usr/$(get_libdir)/pkgconfig/" pkg-config --exists ${PN} \
	        || die ".pc file failed to validate."
	if use cxx ; then
	sed \
		-e "s:@LIBDIR@:$(get_libdir):" \
		-e "s:@PACKAGENAME@:${MY_PN}:" \
		-e "s:@DESCRIPTION@:${DESCRIPTION}:" \
		-e "s:@REQUIRES@:OpenEXR libpng:" \
		-e "s:@VERSION@:${PV}:" \
		-e "s:@LIBS@:-lfreeimageplus:" \
		-e "s:@EXTLIBS@:-ljpeg -ltiff -lopenjpeg -lz:" \
		"${FILESDIR}/${PN}.pc.in" > "${D}/usr/$(get_libdir)/pkgconfig/${PN}plus.pc"	|| die
	fi
	PKG_CONFIG_PATH="${D}/usr/$(get_libdir)/pkgconfig/" pkg-config --exists	${PN}plus \
	        || die ".pc file failed to validate."
	eend $?
}
