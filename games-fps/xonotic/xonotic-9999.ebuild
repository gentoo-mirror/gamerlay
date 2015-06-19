# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils toolchain-funcs flag-o-matic git-2 games

DESCRIPTION="Fork of Nexuiz, Deathmatch FPS based on DarkPlaces, an advanced Quake 1 engine"
HOMEPAGE="http://www.xonotic.org/"
BASE_URI="git://git.xonotic.org/${PN}/"
EGIT_REPO_URI="${BASE_URI}${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="cdda custom-cflags dedicated experimental +maps +ode opengl +s3tc +sdl sdl2 +server videocapture"
REQUIRED_USE="
	|| ( opengl sdl server )
	dedicated? ( server !opengl !sdl )
	sdl2? ( sdl )
"

UIRDEPEND="
	media-libs/libogg
	videocapture? ( media-libs/libtheora[encode] )
	media-libs/libvorbis
	x11-libs/libX11
	virtual/opengl
	media-libs/freetype:2
	~games-fps/xonotic-data-9999[client]
	s3tc? ( media-libs/libtxc_dxtn )
"
RDEPEND="
	sys-libs/zlib
	virtual/jpeg
	media-libs/libpng:0=
	net-misc/curl
	~dev-libs/d0_blind_id-${PV}
	~games-fps/xonotic-data-9999
	maps? ( ~games-fps/xonotic-maps-9999 )
	ode? ( dev-games/ode[double-precision] )
	opengl? (
		${UIRDEPEND}
		x11-libs/libXext
		x11-libs/libXpm
		x11-libs/libXxf86vm
		media-libs/alsa-lib
	)
	sdl? (
		${UIRDEPEND}
		!sdl2? ( media-libs/libsdl[X,joystick,opengl,sound,video] )
		sdl2? ( media-libs/libsdl2[X,opengl,video] )
	)
"
DEPEND="${RDEPEND}
	opengl? (
		x11-proto/xextproto
		x11-proto/xf86vidmodeproto
		x11-proto/xproto
		cdda? ( virtual/os-headers )
	)
"

src_unpack() {
	git-2_src_unpack

	if use !experimental; then
		EGIT_BRANCH="div0-stable"
		EGIT_COMMIT=${EGIT_BRANCH}
	fi
	EGIT_REPO_URI="${BASE_URI}darkplaces.git" \
	EGIT_SOURCEDIR="${S}/darkplaces" \
	git-2_src_unpack
}

src_prepare() {
	sed -e 's,Version=2.5,Version=1.0,' -i misc/logos/xonotic-*.desktop || die

	cd darkplaces || die
	epatch_user

	# let upstream pick the optimization level by default
	use custom-cflags || filter-flags -O?

	sed -i \
		-e "/^EXE_/s:darkplaces:${PN}:" \
		-e "/^OPTIM_RELEASE=/s:$: ${CFLAGS}:" \
		-e "/^LDFLAGS_RELEASE=/s:$: -DNO_BUILD_TIMESTAMPS ${LDFLAGS}:" \
		makefile.inc || die
}

src_compile() {
	cd darkplaces || die
	emake \
		STRIP=true \
		CC="$(tc-getCC)" \
		DP_FS_BASEDIR="${GAMES_DATADIR}/${PN}" \
		DP_SOUND_API="ALSA" \
		DP_LINK_ODE="shared" \
		DP_LINK_CRYPTO="shared" \
		$(usex cdda "" "DP_CDDA=") \
		$(usex ode "" "LIB_ODE=") \
		$(usex ode "" "CFLAGS_ODE=") \
		$(usex sdl2 "SDL_CONFIG=sdl2-config" "SDL_CONFIG=sdl-config") \
		$(usex videocapture "" "DP_VIDEO_CAPTURE=") \
		$(usex opengl cl-release "") \
		$(usex sdl sdl-release "") \
		$(usex server sv-release "")
}

src_install() {
	if use opengl; then
		dogamesbin darkplaces/${PN}-glx
		domenu misc/logos/xonotic-glx.desktop
	fi
	if use sdl; then
		dogamesbin darkplaces/${PN}-sdl
		domenu misc/logos/xonotic-sdl.desktop
	fi
	if use opengl || use sdl; then
		newicon misc/logos/icons_png/${PN}_512.png ${PN}.png
	fi
	use server && dogamesbin darkplaces/${PN}-dedicated

	dodoc Docs/*.txt
	dohtml -r Docs

	insinto "${GAMES_DATADIR}/${PN}"

	# public key for d0_blind_id
	doins key_0.d0pk

	use server && doins -r server

	prepgamesdirs
}
