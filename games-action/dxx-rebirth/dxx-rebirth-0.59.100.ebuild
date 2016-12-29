# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils scons-utils

MY_P=${PN}_v${PV}-src
DESCRIPTION="Descent Rebirth - enhanced Descent 1 & 2 engine"
HOMEPAGE="http://www.dxx-rebirth.com/"
SRC_URI="http://www.dxx-rebirth.com/download/dxx/${MY_P}.tar.gz
	opl3-musicpack? ( 
		descent1? ( http://www.dxx-rebirth.com/download/dxx/res/d1xr-opl3-music.dxa )
		descent2? ( http://www.dxx-rebirth.com/download/dxx/res/d2xr-opl3-music.dxa ) )
	sc55-musicpack? (
		descent1? ( http://www.dxx-rebirth.com/download/dxx/res/d1xr-sc55-music.dxa )
		descent2? ( http://www.dxx-rebirth.com/download/dxx/res/d2xr-sc55-music.dxa ) )
	l10n_de? (
		descent1? ( http://www.dxx-rebirth.com/download/dxx/res/d1xr-briefings-ger.dxa )
		descent2? ( http://www.dxx-rebirth.com/download/dxx/res/d2xr-briefings-ger.dxa ) )
	textures? ( http://www.dxx-rebirth.com/download/dxx/res/d1xr-hires.dxa )"

RESTRICT=mirror

LICENSE="D1X GPL-2 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+data debug +descent1 +descent2 doc ipv6 l10n_de +music +opengl opl3-musicpack sc55-musicpack +textures"

REQUIRED_USE="|| ( descent1 descent2 )
	?? ( opl3-musicpack sc55-musicpack )
	opl3-musicpack? ( music )
	sc55-musicpack? ( music )
	textures ( descent1 )"

DEPEND="dev-games/physfs[hog,mvl,zip]
	media-libs/libsdl:0[X,sound,joystick,opengl?,video]
	music? (
		media-libs/sdl-mixer:0[midi,timidity,vorbis]
	)
	opengl? (
		virtual/opengl
		virtual/glu
	)"
RDEPEND="data? (
	descent1? ( || ( games-action/descent1-data games-action/descent1-demodata ) )
	descent2? ( || ( games-action/descent2-data games-action/descent2-demodata ) ) )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${MY_P}.tar.gz
}

src_prepare() {
	# * flags patch -- remove hardcoded '-g -O2'
	# * sharepath patch -- change location of games' data from
	#   /usr/share/games/{d1x,d2x}-rebirth to /usr/share/games/{d1x,d2x}
	PATCHES=("${FILESDIR}"/${P}-{flags,sharepath}.patch)
	default
}

src_compile() {
	escons \
		verbosebuild=1 \
		prefix='/usr' \
		debug=$(usex debug 1 0) \
		ipv6=$(usex ipv6 1 0) \
		sdlmixer=$(usex music 1 0) \
		opengl=$(usex opengl 1 0)
}

src_install() {
	if use doc; then
		docs=({CHANGELOG,INSTALL,README,RELEASE-NOTES}.txt)
		dodoc COPYING.txt
	fi

	for DV in 1 2; do
		if ! use descent${DV}; then
			continue
		fi

		PROGRAM=d${DV}x-rebirth

		if use doc; then
			docinto $PROGRAM
			for d in ${docs[@]}; do
				edos2unix $PROGRAM/${d}
				dodoc $PROGRAM/${d}
			done
		fi

		insinto "/usr/share/games/d${DV}x"
		use opl3-musicpack && doins "${DISTDIR}"/d${DV}xr-opl3-music.dxa
		use sc55-musicpack && doins "${DISTDIR}"/d${DV}xr-sc55-music.dxa
		use l10n_de && doins "${DISTDIR}"/d${DV}xr-briefings-ger.dxa

		dobin $PROGRAM/$PROGRAM
		make_desktop_entry $PROGRAM "Descent ${DV} Rebirth" $PROGRAM
		doicon $PROGRAM/$PROGRAM.xpm
	done

	insinto "/usr/share/games/d1x"
	use textures && doins "${DISTDIR}"/d1xr-hires.dxa
}

pkg_postinst() {
	if ! use data; then
		elog
		elog "To play the game enable USE=\"data\" or manually "
		elog "copy the files to /usr/share/{d1x,d2x}."
		elog "See /usr/share/doc/${PF}/INSTALL.txt.bz2 for details."
		elog
	fi
	if use music; then
		elog
		elog "You need to enable one of alsa/oss/pulseaudio USE flags for"
		elog "media-libs/libsdl package according to your sound system choice,"
		elog "if this USE flag isn't set globally."
		elog
		elog "For example:"
		elog "echo 'media-libs/libsdl alsa' >> /etc/portage/package.use/alsa"
		elog
	fi
}
