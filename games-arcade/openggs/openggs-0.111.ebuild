# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games

MY_PN=OpenGGS

DESCRIPTION="reimplementation of The Great Giana Sisters as an easily portable Free Software/Open Source project."
HOMEPAGE="http://openggs.romanhoegg.ch/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}_${PV}_incl_Sources.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="editor"

RDEPEND="media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_PN}_${PV}"

src_prepare(){
	sed -i -e "s:classic.lvl:"${GAMES_DATADIR}"/"${PN}"/classic.lvl:g" -i sources/load_stage.cpp
	for i in `find sources -name *.cpp`; do sed -i "$i" -e "s:base:"${GAMES_DATADIR}"/"${PN}/base":g"; done
	if use editor; then
	sed -i -e "s:classic.lvl:"${GAMES_DATADIR}"/"${PN}"/classic.lvl:g" -i sources_editor/saveStageBinary.cpp
	sed -i -e "s:classic.lvl:"${GAMES_DATADIR}"/"${PN}"/classic.lvl:g" -i sources_editor/loadStageBinary.cpp
	sed -i -e "s:base/:"${GAMES_DATADIR}"/"${PN}/base/":g" -i sources_editor/SDL_surfaces.cpp
	sed -i -e "s:materials/:"${GAMES_DATADIR}"/"${PN}/materials/":g" -i sources_editor/SDL_surfaces.cpp
	sed -i -e "s:materials/:"${GAMES_DATADIR}"/"${PN}/materials/":g" -i sources_editor/maps.cpp
	fi
}

src_compile() {
	cd "${S}"/sources
	emake || die
	if use editor; then
	cd "${S}"/sources_editor
	emake || die
	fi
}
src_install() {
	dogamesbin ${PN}
	if use editor; then
	dogamesbin ${PN}-editor
	fi
	local datadir="${GAMES_DATADIR}"/"${PN}"
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/"${PN}"
	doins -r base *.lvl || die
	if use editor; then
	doins -r materials || die
	fi
	make_desktop_entry "${PN}" "${PN}"
	dodoc README.html
	prepgamesdirs
}

pkg_postinst() {
	if use editor; then
	elog "the path to the leveldatafile is currently hardcoded to ${GAMES_DATADIR}/${PN}/classic.lvl"
	elog "- means only editable with enough write priviledges. make sure to backup the datafile before!"
	fi
	games_pkg_postinst
}
