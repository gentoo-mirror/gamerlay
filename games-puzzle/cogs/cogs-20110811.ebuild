# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils games

DESCRIPTION="Immersed in a steampunk world with stunning visual design. Build an incredible variety of machines from sliding tiles."
HOMEPAGE="http://www.cogsgame.com/"

SRC_URI="${P/-/_}_all.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* amd64 ~x86"
IUSE=""
RESTRICT="strip fetch"

RDEPEND="
	x86? (
		dev-libs/json-c
		media-libs/alsa-lib
		media-libs/flac
		media-libs/libogg
		=media-libs/libsdl-1.2*
		media-libs/libsndfile
		media-libs/libvorbis
		media-libs/openal
		media-sound/pulseaudio
		sys-apps/util-linux
		sys-libs/gdbm
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libxcb
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXtst
		virtual/opengl
	)
	amd64? (
		app-arch/bzip2
		dev-libs/json-c
		media-libs/aalib
		media-libs/alsa-lib
		media-libs/flac
		media-libs/freeglut
		media-libs/freetype:2
		media-libs/ftgl
		media-libs/glu
		media-libs/libcaca
		media-libs/libogg
		=media-libs/libsdl-1.2*
		media-libs/libsndfile
		media-libs/libvorbis
		media-libs/openal
		virtual/opengl
		media-sound/pulseaudio
		net-libs/libasyncns
		sys-apps/attr
		sys-apps/dbus
		sys-apps/tcp-wrappers
		sys-libs/gpm
		sys-libs/libcap
		sys-libs/ncurses
		sys-libs/zlib
		x11-libs/libdrm
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libxcb
		x11-libs/libXdamage
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXtst
		x11-libs/libXxf86vm
	)
"

S="${WORKDIR}/${PN}"


src_install() {
	local exe;
	GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

	use amd64 && exe="Cogs-amd64"
	use x86 && exe="Cogs-x86"

	insinto "${GAMEDIR}"
	exeinto "${GAMEDIR}"

	# install icon
	doicon "${PN}.png" \
		|| die "install icon"

	# install docs
	dodoc "README-linux.txt"

	# install game files
	doexe "${exe}"
	doins -r data || die "doins game data"

	# install shortcuts
	games_make_wrapper "${PN}" "./${exe}" "${GAMEDIR}" || die "install shortcut"
	make_desktop_entry "${PN}" "Cogs" "${PN}"

	prepgamesdirs
}
