# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=1

inherit games

DESCRIPTION="Text-based pacman clone with many variants, sizes and other features"
HOMEPAGE="http://myman.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+iconv +internal libcaca ncurses slang +unicode"

RDEPEND="ncurses? ( sys-libs/ncurses )
	slang? ( sys-libs/slang )
	iconv? ( virtual/libiconv )
	libcaca? ( media-libs/libcaca )
	"
DEPEND="${RDEPEND}"

pkg_setup() {
	einfo "You should choose only one backend. Availible are:"
	einfo "1) internal (default on): internal game backend, nicest in X"
	einfo "2) ncurses: use ncurses backend"
	einfo "3) slang: use slang backend"
	einfo "If you add more than one backend they are overriden"
	einfo "in this order: slang->ncurses->raw."
	games_pkg_setup
}

src_compile() {
	local MYOPTS
	if use unicode; then
		use slang && MYOPTS="--with-slang-utf8"
		use ncurses && MYOPTS="--with-ncursesw"
		use internal && MYOPTS="--with-raw"
	else
		use slang && MYOPTS="--with-slang"
		use ncurses && MYOPTS="--with-ncurses"
		use internal && MYOPTS="--with-raw-cp437"
	fi
	egamesconf \
		--docdir=${GAMES_DATADIR_BASE}/doc/ \
		$MYOPTS \
		$(use_with iconv) \
		$(use_with libcaca) \
		--without-xcurses \

	emake || die "Make failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	prepgamesdirs
}
