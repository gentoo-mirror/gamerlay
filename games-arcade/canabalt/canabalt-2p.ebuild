# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit games unpacker

DESCRIPTION="Retro-styled 2D platformer-autorunner"
HOMEPAGE="http://www.semisecretsoftware.com/"
SRC_URI="Canabalt2P_AIR-1331587946.air"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RESTRICT="fetch strip"
IUSE=""

DEPEND=""
RDEPEND="
	dev-util/adobe-air-sdk-bin
"

S="${WORKDIR}"

src_unpack() {
	unpack_zip "${A}"
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	insinto "${dir}"
	doins -r .
	doicon "${FILESDIR}/${PN}.png"

	games_make_wrapper "${PN}" "/opt/bin/adl -nodebug ${dir}/META-INF/AIR/application.xml ${dir} --"
	make_desktop_entry "${PN}" "${PN}" "${PN}"

	prepgamesdirs
}
