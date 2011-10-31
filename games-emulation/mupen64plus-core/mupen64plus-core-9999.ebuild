# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils games mercurial

DESCRIPTION="plugin-based Nintendo 64 emulator, core library"
HOMEPAGE="http://code.google.com/p/mupen64plus/"
EHG_REPO_URI="https://bitbucket.org/richard42/${PN}"
#SRC_URI="https://bitbucket.org/richard42/${PN}/downloads/${PN}-src-${PV}-norom.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug lirc pic profile"

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/freetype:2
	media-libs/libpng
	media-libs/libsdl
	|| ( <sys-libs/zlib-1.2.5.1-r1 >=sys-libs/zlib-1.2.5.1-r2[minizip] )
	lirc? ( app-misc/lirc )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

OPTS="V=1 PREFIX=${GAMES_PREFIX} LIBDIR=$(games_get_libdir) BINDIR=${GAMES_BINDIR} APIDIR=/usr/include/mupen64plus/ INCDIR=/usr/include/mupen64plus/ SHAREDIR=${GAMES_DATADIR} DESTDIR=${D} COREDIR=$(games_get_libdir)/ PLUGINDIR=$(games_get_libdir)/mupen64plus/ MANDIR=/usr/share/man V=1 OPTFLAGS= INSTALL_STRIP_FLAG="

src_compile() {
	use debug && OPTS+=" DEBUG=1 DEBUGGER=1 PLUGINDBG=1"
	use lirc && OPTS+=" LIRC=1"
	use pic && OPTS+=" PIC=1 PIE=1"
	use profile && OPTS+=" PROFILE=1"

	emake -C "projects/unix" all $OPTS || die "make failed"
}

src_install() {
	emake -C "projects/unix" install $OPTS || die "install failed"
	[ -f "RELEASE" ] && newdoc "RELEASE" "RELEASE"
	[ -f "README" ] && newdoc "README" "README"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if use lirc; then
		echo
		elog "For lirc configuration see:"
		elog "http://code.google.com/p/mupen64plus/wiki/LIRC"
	fi
}