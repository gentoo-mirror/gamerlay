# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-puzzle/phlipple/phlipple-0.8.1.ebuild frostwork Exp $

EAPI=5

inherit autotools eutils games flag-o-matic

DESCRIPTION="An unique puzzle game with the goal to reduce a 3D shape to a single square"
HOMEPAGE="http://phlipple.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl:0
	media-libs/sdl-image:0
	media-libs/sdl-mixer:0
	media-libs/sdl-ttf:0
	virtual/opengl
	virtual/glu"

src_prepare() {
	# fix fails to link on new glibc
	epatch "${FILESDIR}/${P}_check-math-lib.patch"
	eautoreconf
}
