# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-mud/tf/tf-50_beta8.ebuild,v 1.4 2009/12/30 00:26:03 mr_bones_ Exp $

EAPI=2

EGIT_BRANCH="widechar"
inherit games git-2

MY_P="tf-50b8"
MY_PN="tinyfugue"
DESCRIPTION="A small, flexible, screen-oriented MUD client (aka TinyFugue)"
HOMEPAGE="http://tinyfugue.sourceforge.net/"
EGIT_REPO_URI="git://github.com/kruton/tinyfugue.git"
SRC_URI="doc? ( mirror://sourceforge/tinyfugue/${MY_P}-help.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc ipv6 ssl unicode"

DEPEND="ssl? ( dev-libs/openssl )
	dev-libs/libpcre"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}

src_unpack() {
	use doc && unpack ${A}
	git-2_src_unpack
}

src_configure() {
	STRIP=: egamesconf \
		$(use_enable unicode widechar) \
		$(use_enable ssl) \
		$(use_enable debug core) \
		$(use_enable ipv6 inet6) \
		--enable-manpage || die
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dogamesbin src/tf || die "dogamesbin failed"
	newman src/tf.1.nroffman tf.1
	dodoc CHANGES CREDITS README

	insinto "${GAMES_DATADIR}"/${PN}-lib
	# the application looks for this file here if /changes is called.
	# see comments on bug #23274
	doins CHANGES || die "doins failed"
	insopts -m0755
	doins tf-lib/* || die "doins failed"
	if use doc ; then
		dohtml -r *.html commands topics
	fi
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	use ipv6 && {
		echo
		ewarn "You have merged TinyFugue with IPv6-support."
		ewarn "Support for IPv6 is still being experimental."
		ewarn "If you experience problems with connecting to hosts,"
		ewarn "try re-merging this package with USE="-ipv6""
		echo
	}
}
