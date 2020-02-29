# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils multilib-minimal unpacker

DESCRIPTION="Keeping the airport safe from hammers, scissors, and other illegal goods."
HOMEPAGE="http://www.11bitstudios.com/games/9/funky-smugglers"
# Is it non-HiB distfile?
SRC_URI="FunkySmugglers-lin_1371139237-Installer"
RESTRICT="fetch strip"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="multilib"

DEPEND="app-arch/unzip"
RDEPEND="
	media-libs/openal[${MULTILIB_USEDEP}]
	x11-libs/libdrm[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXau[${MULTILIB_USEDEP}]
	x11-libs/libxcb[${MULTILIB_USEDEP}]
	x11-libs/libXdamage[${MULTILIB_USEDEP}]
	x11-libs/libXdmcp[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	virtual/opengl
"

S="${WORKDIR}/data"

src_unpack() {
	unpack_zip ${A}
}

pkg_nofetch() {
	ewarn
	ewarn "Put ${A} (downloaded from Humble Store) to ${DISTDIR}, please"
	ewarn
}

src_install() {
	local dir="/opt/${PN}"

	newicon "icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "FunkySmugglers" "${PN}"
	make_wrapper "${PN}" "./FunkySmugglers" "${dir}"
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
}
