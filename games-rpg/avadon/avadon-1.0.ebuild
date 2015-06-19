# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games

TS="1331768904"
MY_PN="Avadon"

DESCRIPTION="Epic fantasy role-playing adventure in an enormous and unique world."
HOMEPAGE="http://www.spidweb.com/avadon/"
SRC_URI="${PN}-linux-${TS}-bin"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RESTRICT="strip fetch"

DEPEND="app-arch/unzip"
RDEPEND="
	amd64? (
		media-libs/libsdl
		media-libs/openal
		media-libs/alsa-lib
		media-sound/pulseaudio
		media-libs/aalib
		dev-libs/json-c
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libXtst
		media-libs/libsndfile
		media-libs/flac
		media-libs/libvorbis
		media-libs/libogg
		net-libs/libasyncns
		sys-apps/dbus
		sys-libs/gdbm
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXext
	)
	x86? (
		media-libs/libsdl
		media-libs/openal
		media-libs/alsa-lib
		media-sound/pulseaudio
		dev-libs/json-c
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libXtst
		media-libs/libsndfile
		media-libs/flac
		media-libs/libvorbis
		media-libs/libogg
		sys-libs/gdbm
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXi
	)
"

S="${WORKDIR}/data"

pkg_nofetch() {
	echo
	elog "Download ${SRC_URI} from ${HOMEPAGE} and place it in ${DISTDIR}"
	echo
}

src_unpack() {
	# self unpacking zip archive; unzip warns about the exe stuff
	local a="${DISTDIR}/${SRC_URI}"
	echo ">>> Unpacking ${a} to ${PWD}"
	unzip -q "${a}"
	[ $? -gt 1 ] && die "unpacking failed"

}

src_install() {
	local GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"
	local exe="${MY_PN}-${ARCH}"

	insinto "${GAMEDIR}"
	exeinto "${GAMEDIR}"

	doicon "${MY_PN}.png"
	dodoc "README-linux.txt"

	doins -r "avadon files" "icon.bmp"
	doexe "${exe}"

	games_make_wrapper "${PN}" "./${exe}" "${GAMEDIR}"
	make_desktop_entry "${PN}" "${MY_PN}: The Black Fortress" "${PN}"

	prepgamesdirs
}
