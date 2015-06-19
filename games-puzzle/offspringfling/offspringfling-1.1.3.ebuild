# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-puzzle/kinetris/kinetris-1.0.0b_pre5.ebuild frostwork Exp $

EAPI="5"

inherit games multilib

DESCRIPTION="A game about a poor forest creature that has misplaced all of her children."
HOMEPAGE="http://offspringfling.com/"
SRC_URI="
	${PN/fl/_fl}-linux-${PV}.tar.gz
"

LICENSE="as-is"
SLOT="0"
RESTRICT="fetch"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	www-client/firefox
	www-client/firefox-bin
	www-client/chromium
	www-client/google-chrome
	www-client/rekonq
	www-client/midori
	www-client/opera
	www-client/opera-next
	www-client/luajit
	kde-base/konqueror
	www-client/seamonkey
	www-client/qupzilla
	app-leechcraft/lc-poshuku
"

GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"
S="${WORKDIR}/Offspring Fling Linux"
DOCS=( "Linux Fullscreen.txt" )

src_install() {
	insinto "${GAMEDIR}"
	doins "data/OffspringFling.swf"
	games_make_wrapper "${PN}" '${BROWSER} ./OffspringFling.swf' "${GAMEDIR}"
	doicon "${FILESDIR}/${PN}.png"
	make_desktop_entry "${PN}" "${PN}" "${PN}"

	prepgamesdirs
}
