# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-arcade/mytoy-se-1.0.0,v 0.5 2008/06/13 18:00:00 frostwork Exp $

inherit eutils games

DESCRIPTION="Goldberg's EyeToy clone with several sub-games"
HOMEPAGE="http://www.happypenguin.org/show?MyToy"
SRC_URI="http://frostworx.de/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/opencv
	media-libs/mesa
	media-libs/sdl-image
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-homeandvideo.patch
	epatch "${FILESDIR}"/${P}-best.patch
	sed -i \
	-e 's:"\(data/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i ${P}/ccore.cpp \
	-e 's:"\(data/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i ${P}/cmeteorfly.cpp \
	-e 's:"\(data/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i ${P}/ccrazy.cpp \
	-e 's:"\(data/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i ${P}/cdogcatcher.cpp \
	-e 's:"\(data/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i ${P}/cwindow.cpp \
	-e 's:"\(data/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i ${P}/cmenu.cpp \
	-e 's:"\(data/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i ${P}/cintro.cpp \
		|| die "sed failed"
}

src_compile() {
	emake MORE_CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dogamesbin ${PN}
	dodir "${GAMES_DATADIR}/${PN}" "${GAMES_STATEDIR}/${PN}"
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data || die
	dodoc configuration || die
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	ewarn "For the first run you need to extract /usr/share/doc/mytoy-se-1.0.0/configuration.bz2"
	ewarn "into ~/.mytoy-se/"
	elog "The author Goldberg no longer has time to maintain this game"
	elog "Would be great to see further new development on this"
}
