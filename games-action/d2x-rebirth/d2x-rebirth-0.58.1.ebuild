# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils games scons-utils

DV=2
MY_P=${PN}_v${PV}-src
DESCRIPTION="Descent Rebirth - enhanced Descent ${DV} engine"
HOMEPAGE="http://www.dxx-rebirth.com/"
SRC_URI="http://www.dxx-rebirth.com/download/dxx/${MY_P}.tar.gz
	opl3-musicpack? ( http://www.dxx-rebirth.com/download/dxx/res/d${DV}xr-opl3-music.dxa )
	sc55-musicpack? ( http://www.dxx-rebirth.com/download/dxx/res/d${DV}xr-sc55-music.dxa )
	linguas_de? ( http://www.dxx-rebirth.com/download/dxx/res/d${DV}xr-briefings-ger.dxa )"

LICENSE="D1X GPL-2 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+data debug ipv6 linguas_de +music +opengl opl3-musicpack sc55-musicpack"

REQUIRED_USE="?? ( opl3-musicpack sc55-musicpack )
	opl3-musicpack? ( music )
	sc55-musicpack? ( music )"

RDEPEND="dev-games/physfs[hog,mvl,zip]
	media-libs/libsdl:0[X,sound,joystick,opengl?,video]
	music? (
		media-libs/sdl-mixer:0[timidity,vorbis]
	)
	opengl? (
		virtual/opengl
		virtual/glu
	)"
DEPEND="${RDEPEND}"
PDEPEND="data? ( || (
	games-action/descent2-data
	games-action/descent2-demodata
) )"

S=${WORKDIR}/${MY_P}

RESTRICT=mirror

src_unpack() {
	unpack ${MY_P}.tar.gz
}

src_prepare() {
	DOCS=({CHANGELOG,COPYING,INSTALL,README,RELEASE-NOTES}.txt)
	edos2unix ${DOCS[@]}
	epatch "${FILESDIR}"/${P}-flags.patch
}

src_compile() {
	escons \
		verbosebuild=1 \
		sharepath="${GAMES_DATADIR}/d${DV}x" \
		$(use_scons debug) \
		$(use_scons ipv6) \
		$(use_scons music sdlmixer) \
		$(use_scons opengl) \
		|| die
}

src_install() {
	dodoc ${DOCS[@]}

	insinto "${GAMES_DATADIR}/d${DV}x"

	use opl3-musicpack && doins "${DISTDIR}"/d${DV}xr-opl3-music.dxa
	use sc55-musicpack && doins "${DISTDIR}"/d${DV}xr-sc55-music.dxa
	use linguas_de && doins "${DISTDIR}"/d${DV}xr-briefings-ger.dxa

	doicon "${S}/${PN}.xpm"

	dogamesbin d${DV}x-rebirth
	make_desktop_entry d${DV}x-rebirth "Descent ${DV} Rebirth"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if ! use data ; then
		echo
		elog "To play the game enable USE=\"data\" or manually "
		elog "copy the files to ${GAMES_DATADIR}/d${DV}x."
		elog "See /usr/share/doc/${PF}/INSTALL.txt.bz2 for details."
		echo
	fi
}
