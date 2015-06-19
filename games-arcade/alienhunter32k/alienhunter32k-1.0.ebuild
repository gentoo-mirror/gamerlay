# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-arcade/alienhunter32k/alienhunter32k-1.0.ebuild v 1.0 2011/06/30 09:03:13 frostwork $

inherit eutils games

DESCRIPTION="Transplant remake (Amiga-PD) - multiscrolling arcade shootergame"
HOMEPAGE="http://www.happypenguin.org/show?AlienHunter32k"
SRC_URI="http://www.marion-hurghada.com/tristar/${PN}.rar"

LICENSE="Freeware"
SLOT="0"
KEYWORDS="x86"
RESTRICT="strip"
IUSE=""

DEPEND=""
RDEPEND="virtual/opengl
	media-libs/libsdl"

S=${WORKDIR}


src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}
	dodir "${dir}" "${GAMES_BINDIR}"

	tar -zxf ${S}/alienhunter.tar.gz -C "${D}/${dir}" || die "extracting alienhunter.tar.gz"

	exeinto "${dir}"
	doexe "${dir}"/alienhunter
	doexe "${dir}"/alienhunterFS
	dosym "${dir}"/alienhunter "${GAMES_BINDIR}"/alienhunter
	dosym "${dir}"/alienhunterFS "${GAMES_BINDIR}"/alienhunterFS

	dodoc "${dir}"/readme

	prepgamesdirs
}
