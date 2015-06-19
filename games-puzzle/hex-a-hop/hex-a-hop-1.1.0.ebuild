# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-puzzle/hex-a-hop-1.1.0.ebuild,v 1.0 2010/01/20 09:41:34 by frostwork Exp $

EAPI="2"

MY_PN=hexahop
inherit games

DESCRIPTION="a hexagonal tile-based puzzle game"
HOMEPAGE="http://hexahop.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-pango
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}"
