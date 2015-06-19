# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils games

DESCRIPTION="laser game entry for ludum dare 10"
HOMEPAGE="http://xout.blackened-interactive.com/OldGames.html"
SRC_URI="http://xout.blackened-interactive.com/dump/new/LD10.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl
	media-libs/devil
	=media-libs/fmod-3*"
DEPEND="${RDEPEND}"

S=${WORKDIR}/LD10/Src

src_prepare(){
	edos2unix *.{cpp,h}
	epatch ${FILESDIR}/"${P}-makefile.patch"
	epatch ${FILESDIR}/"${P}-includes.patch"
	epatch ${FILESDIR}/"${P}-misc.patch"
	epatch ${FILESDIR}/"${P}-sound.patch"
	sed -i -e "s:Data/:"${GAMES_DATADIR}"/"${PN}"/:g" -i Game.cpp

}

src_install() {
	dogamesbin ../LaserReaction/${PN} || die "dogamesbin ${PN} failed"

	local datadir="${GAMES_DATADIR}"/"${PN}"
	dodir ${datadir}
	insinto "${datadir}"
	doins -r ../LaserReaction/Data/* || die "doins resources failed"
	make_desktop_entry "${PN}" "${PN}"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
