# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-puzzle/kinetris/kinetris-1.0.0b_pre5.ebuild frostwork Exp $

EAPI="5"
MY_PN="Spirits"

inherit games

DESCRIPTION="Save the spirits of leaf litters"
HOMEPAGE="http://www.spacesofplay.com/spirits/"
SRC_URI="${PN}-linux-${PV}_120903-1348705231.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/openal
"
#	media-libs/libsdl:2 #somewhy doesn't work with all latest versions of SDL2 in overlay
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_install() {
	local libdir binary
	GAMEDIR="${GAMES_PREFIX_OPT}/${MY_PN}"

	use amd64 && {
# TODO: unbundling SDL2
		libdir=x86_64
		binary=Spirits-64
	}

	use x86 && {
# TODO: unbundling SDL2
		libdir=i686
		binary=Spirits-32
	}

	dodoc README.TXT

	rm "./${libdir}/libopenal.so.1"

	exeinto "${GAMEDIR}"
	insinto "${GAMEDIR}"
	doins -r data
# TODO: unbundling SDL2
	doins -r "${libdir}"
	doexe "${binary}"

        # install shortcuts
        games_make_wrapper "${PN}" "./${binary}" "${GAMEDIR}" "${GAMEDIR}/${libdir}" || die "install shortcut"
        make_desktop_entry "${PN}" "${MY_PN}" "${PN}"

        prepgamesdirs
}

pkg_postinstall() {
	einfo "If pre-start dialog looks ugly for you, try to remove ~/.themes"
	einfo "At least, it helped me in such situation."
}