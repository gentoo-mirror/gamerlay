# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games versionator

MY_PV=$(version_format_string '${2}${3}${1}')

DESCRIPTION="A mind-bending platforming adventure from Double Fine Productions."
HOMEPAGE="http://www.psychonauts.com/"
SRC_URI="${PN}-linux-${MY_PV}-bin"

LICENSE="Psychonauts-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="virtual/opengl
	amd64? ( app-emulation/emul-linux-x86-sdl )
	x86? ( media-libs/openal media-libs/libsdl )"

RESTRICT="fetch strip"

S="${WORKDIR}/data"

pkg_nofetch() {
	einfo "Please download ${A}"
	einfo "from your personal page in Humble Indie Bundle V site"
	einfo "(http://www.humblebundle.com)"
	einfo "and place it to ${DISTDIR}"
}

src_unpack() {
	# self unpacking zip archive; unzip warns about the exe stuff
	# (taken from lugaru ebuild)
	local a=${DISTDIR}/${A}
	echo ">>> Unpacking ${a} to ${PWD}"
	unzip -q "${a}"
	[ $? -gt 1 ] && die "unpacking failed"
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	dodoc "Psychonauts Manual Win.pdf"
	dodoc Documents/Readmes/*
	exeinto ${dir}
	doexe Psychonauts || die
	insinto ${dir}
	doins -r DisplaySettings.ini PsychonautsData2.pkg WorkResource || die
	doicon ${PN}.png
	games_make_wrapper ${PN} ./Psychonauts "${dir}" "${dir}"
	make_desktop_entry ${PN} Psychonauts ${PN}

	prepgamesdirs
}
