# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils games subversion

DESCRIPTION="a free and opensource Remake of the famous Turrican"
HOMEPAGE="http://http://www.hurrican-game.de"
ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}/code/trunk/Hurrican/"
ESVN_PROJECT="${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND="media-libs/libmodplug
	>=media-libs/libsdl-1.2
	media-libs/sdl-image
	media-libs/sdl-mixer
	virtual/opengl"

DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-homedir.patch || die
	# Respect GAMES_DATADIR
	sed -i -e "s:hurricanlinux:hurrican:g" -i src/Makefile || die
	sed -i -e "s:data\/:${GAMES_DATADIR}/${PN}/data\/:g" -i src/Console.cpp || die
	sed -i -e "s:data\/:${GAMES_DATADIR}/${PN}/data\/:g" -i src/DX8Font.cpp || die
	sed -i -e "s:data\/:${GAMES_DATADIR}/${PN}/data\/:g" -i src/DX8Sound.cpp || die
	sed -i -e "s:data\/:${GAMES_DATADIR}/${PN}/data\/:g" -i src/DX8Sprite.cpp || die
	sed -i -e "s:data\/:${GAMES_DATADIR}/${PN}/data\/:g" -i src/lightmap.cpp || die
	sed -i -e "s:data\/:${GAMES_DATADIR}/${PN}/data\/:g" -i src/Texts.cpp || die
	sed -i -e "s:data\/:${GAMES_DATADIR}/${PN}/data\/:g" -i src/Tileengine.cpp || die
	sed -i -e "s:english.lng:${GAMES_DATADIR}/${PN}/english.lng:g" -i src/Gameplay.cpp || die

}

src_compile() {
	cd src
	emake || die "make failed"
}

src_install() {
	dogamesbin ${PN}
	local datadir="${GAMES_DATADIR}"/"${PN}"
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/"${PN}"
	doins -r data lang english.lng || die
	make_desktop_entry "${PN}" "${PN}"
	dodoc readme.txt
	prepgamesdirs
}
