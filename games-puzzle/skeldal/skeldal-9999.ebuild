# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

ESVN_REPO_URI="https://skeldal.svn.sourceforge.net/svnroot/skeldal/branches/next_ghost/"
inherit subversion autotools games

DESCRIPTION="Adventure game The Gates of Skeldal"
HOMEPAGE="http://sourceforge.net/projects/skeldal/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/libsdl[X]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	eautoreconf
}

src_configure() {
	egamesconf
}

src_install() {
	base_src_install
	prepgamesdirs
}
