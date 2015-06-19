# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit unpacker games

DESCRIPTION="An extraordinary mixture of action and strategy in a reversed tower defense formula."
HOMEPAGE="http://www.anomalythegame.com/"
# Is it non-HiB distfile?
SRC_URI="AnomalyWarzoneEarth-Installer_Humble_Linux_1364850491.zip"
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
	#double-zipped files, lol
	unpack ${A}
        # self unpacking zip archive; unzip warns about the exe stuff
        local a="${S}/AnomalyWarzoneEarth-Installer"
        unpack_zip "${a}"
	rm "${a}" # save space
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
	make_desktop_entry "${PN}" "Anomaly: Warzone Earth" "${PN}"
	games_make_wrapper "${PN}" "./AnomalyWarzoneEarth" "${dir}"
	dodoc README
	exeinto "${dir}"
	doexe "AnomalyWarzoneEarth"
	rm	"libgcc_s.so.1" \
		"libopenal.so.1" \
		"libstdc++.so.6" \
		"icon.png" \
		"README" \
		"AnomalywarzoneEarth" \
		"AnomalyWarzoneEarth" \
		"AnomalyWarzoneEarth-old" \
		"Copyright license Lua" \
		"Copyright license OggVorbis" \
		"Copyright license Theora" \
		"Copyright license Xpm"
	insinto "${dir}"
	doins -r .

	prepgamesdirs
}
