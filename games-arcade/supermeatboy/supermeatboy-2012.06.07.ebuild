# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games versionator

MY_PN=SuperMeatBoy
MY_PV=$(version_format_string '${2}${3}${1}')

DESCRIPTION="A platformer where you play as an animated cube of meat"
HOMEPAGE="http://www.supermeatboy.com/"
SRC_URI="${PN}-linux-${MY_PV}-bin"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RESTRICT="fetch"

DEPEND="app-arch/zip"
RDEPEND="${DEPEND}
	media-libs/openal
	media-libs/libsdl"

S="${WORKDIR}/data"
GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

pkg_nofetch() {
	einfo "Please download ${A}"
	einfo "from your personal page in Humble Indie Bundle site"
	einfo "(http://www.humblebundle.com)"
	einfo "and place it to ${DESTDIR}"
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
	insinto ${GAMEDIR}
	doins -r resources Levels UserData buttonmap.cfg \
		gameaudio.dat gamedata.dat locdb.txt
	exeinto ${GAMEDIR}
	newexe ${ARCH}/${MY_PN}-${ARCH} ${MY_PN}
	games_make_wrapper ${PN} ./${MY_PN} ${GAMEDIR}
	doicon ${PN}.png
	make_desktop_entry ${PN} ${MY_PN} ${PN}
	dodoc README-linux.txt

	prepgamesdirs
}
