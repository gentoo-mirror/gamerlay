# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-puzzle/puzzlemoppet-1.0.ebuild frostwork Exp $

EAPI="3"

MY_PN="PuzzleMoppet"

inherit games cmake-utils

DESCRIPTION="a serenely peaceful yet devilishly challenging 3D puzzle game"
HOMEPAGE="http://http://garnetgames.com/${PN}"
SRC_URI="http://garnetgames.com/${MY_PN}Full.tar.gz
		http://garnetgames.com/${MY_PN}Source.tar.gz
		http://nothings.org/stb_vorbis/stb_vorbis.c"

LICENSE="WTFPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-games/ode
		dev-games/irrlicht"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/"${MY_PN}Source/Litha Engine"
DAT="${WORKDIR}"/"${MY_PN}FullVersion"

src_prepare(){
	cp "${DISTDIR}"/stb_vorbis.c "${S}"/source/SoundSystems/OpenALSoundSystem
	epatch "${FILESDIR}"/${PN}-irrpatch.patch
	epatch "${FILESDIR}"/${PN}-irrhack.patch
	epatch "${FILESDIR}"/${PN}-cmake.patch
	epatch "${FILESDIR}"/${PN}-64bit.patch
	for i in `find projects/Puzzle -name *.cpp`; do sed -i "$i" -e "s:../projects:"${GAMES_DATADIR}"/"${PN}"/projects:g"; done
	for i in `find projects/ConfigApp -name *.cpp`; do sed -i "$i" -e "s:../projects:"${GAMES_DATADIR}"/"${PN}"/projects:g"; done
	sed -i -e "s:config:"${PN}-config":g" -i projects/ConfigApp/CMakeLists.txt
}

src_install() {

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r "${DAT}"/projects

	dogamesbin bin/${PN} || die "dogamesbin failed"
	dogamesbin bin/${PN}-config || die "dogamesbin failed"

	newicon "${DAT}"/icons/main.png ${PN}.png

	make_desktop_entry ${PN} ${MY_PN} ${PN}
	prepgamesdirs
}
