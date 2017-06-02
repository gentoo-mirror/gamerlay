# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="A VoIP client for FlightGear"
HOMEPAGE="http://fgcom.sourceforge.net/"
EGIT_REPO_URI="https://gitlab.com/flightgear-fs/Voice-Comm/fgcom.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-games/simgear
	media-libs/openal
	media-libs/plib"
RDEPEND="${DEPEND}"
