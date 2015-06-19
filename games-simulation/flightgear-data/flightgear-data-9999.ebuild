# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGIT_BRANCH="master"
EGIT_PROJECT="flightgear.git"

inherit games git-r3 check-reqs

DESCRIPTION="FlightGear data files"
HOMEPAGE="http://www.flightgear.org/"
EGIT_REPO_URI="git://gitorious.org/fg/fgdata.git
		git://mapserver.flightgear.org/fgdata"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

S=${WORKDIR}
GAMES_SHOW_WARNING=NO

pkg_pretend() {
	# Ensure we have enough disk space to compile
	CHECKREQS_DISK_BUILD="12G"
	check-reqs_pkg_setup
}

pkg_setup() {
	# Ensure we have enough disk space to compile
        CHECKREQS_DISK_BUILD="12G"
        check-reqs_pkg_setup
}

src_install() {
	insinto "${GAMES_DATADIR}"/flightgear-live
	doins -r ./*
	prepgamesdirs
}
