# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games qt4-r2 git-2

DESCRIPTION="Launcher for FlightGear Flight Simulator, based on Qt"
HOMEPAGE="http://code.google.com/p/fgx/"
EGIT_REPO_URI="git://gitorious.org/fgx/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4
	dev-qt/qtxmlpatterns:4"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake4 "${S}"/src/fgx.pro
}

src_install() {
	dogamesbin ${PN} || die "dogamesbin failed"
	newicon src/resources/artwork/${PN}-logo.png ${PN}.png || die "newicon failed"
	make_desktop_entry ${PN}
	prepgamesdirs
}
