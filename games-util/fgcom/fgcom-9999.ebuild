# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="A VoIP client for FlightGear"
HOMEPAGE="http://fgcom.sourceforge.net/"
EGIT_REPO_URI="git://gitorious.org/fg/fgcom.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-games/simgear
	media-libs/openal
	media-libs/plib"
RDEPEND="${DEPEND}"
