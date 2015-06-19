# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games qt4-r2 subversion

DESCRIPTION="KBang is an open source implementation of the popular card game Bang!"
HOMEPAGE="http://code.google.com/p/kbang/"
SRC_URI=""
ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="server"

DEPEND=">dev-qt/qtgui-4.4"
RDEPEND="${DEPEND}"

src_prepare() {
	esvn_clean
}
	
src_compile() {
	eqmake4

	emake || die "emake failed"
}

src_install() {
	exeinto "${GAMES_DATADIR}/${PN}"

	doexe "${PN}-client" || die "doexe failed"
	dosym "${GAMES_DATADIR}/${PN}/${PN}-client" "${GAMES_BINDIR}/${PN}"

	if use server; then
		doexe "${PN}-server" || die "doexe failed"
		dosym "${GAMES_DATADIR}/${PN}/${PN}-server" "${GAMES_BINDIR}/${PN}-server"
	fi

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data || die "doins failed"
}
