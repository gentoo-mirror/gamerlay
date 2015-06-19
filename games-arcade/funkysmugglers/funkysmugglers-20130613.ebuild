# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit unpacker games

DESCRIPTION="Enjoy a funky 70s-style soundtrack while keeping the airport safe from hammers, scissors, and other illegal goods."
HOMEPAGE="http://www.11bitstudios.com/games/9/funky-smugglers"
# Is it non-HiB distfile?
SRC_URI="FunkySmugglers-lin_1371139237-Installer"
RESTRICT="fetch strip"
LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="multilib"

DEPEND=""
RDEPEND="
	x86? (
		media-libs/openal
		x11-libs/libdrm
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libxcb
		x11-libs/libXdamage
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXxf86vm
	)
	amd64? (
		app-emulation/emul-linux-x86-xlibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-sdl
	)
	virtual/opengl
	app-arch/unzip
"

REQUIRED_USE="amd64? ( multilib )"

S="${WORKDIR}"

src_unpack() {
	unpack_zip "${A}"
}

pkg_nofetch() {
	ewarn
	ewarn "Put ${A} (downloaded from Humble Store) to ${DISTDIR}, please"
	ewarn
}

src_install() {
	cd "${S}/data"
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	newicon "icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "FunkySmugglers" "${PN}"
	games_make_wrapper "${PN}" "./FunkySmugglers" "${dir}"
	dodoc README
	exeinto "${dir}"
	doexe "FunkySmugglers"
	rm	"libopenal.so.1" \
		"icon.png" \
		"README" \
		"FunkySmugglers" \
		"Copyright license Lua" \
		"Copyright license OggVorbis" \
		"Copyright license Theora" \
		"Copyright license Xpm"
	insinto "${dir}"
	doins -r .

	prepgamesdirs
}
