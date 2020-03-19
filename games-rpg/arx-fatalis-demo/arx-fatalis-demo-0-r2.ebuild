# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Arx Fatalis demo"
HOMEPAGE="https://store.steampowered.com/app/1700/Arx_Fatalis/"
SRC_URI="arx_demo_english.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="fetch"

RDEPEND="
	!games-rpg/arx-fatalis-data
	games-rpg/arx-libertatis"
DEPEND="
	app-arch/cabextract
	app-arch/unzip
"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please find and download ${SRC_URI} and put it into your distfiles directory."
	einfo "There is a list of possible download locations at"
	einfo "http://wiki.arx-libertatis.org/Getting_the_game_data#Demo"
}

src_unpack() {
	unpack ${A}
	cabextract Setup{1,2,3}.cab || die "cabextract failed"
}

src_install() {
	insinto /usr/share/arx/misc
	doins bin/Logo.bmp bin/Arx.ttf
	insinto /usr/share/arx
	newins bin/LOC.pak loc.pak
	newins SFX.pak sfx.pak
	newins SPEECH.pak speech.pak
	doins data.pak bin/data2.pak
}
