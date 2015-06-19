# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils git-2

DESCRIPTION="A crossplatform despair simulator data"
HOMEPAGE="https://github.com/Dark-Confidant/MassacreData"
EGIT_REPO_URI="git://github.com/Dark-Confidant/MassacreData.git"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/Massacre

DEPEND="games-engines/massacre"

RDEPEND="${DEPEND}"
