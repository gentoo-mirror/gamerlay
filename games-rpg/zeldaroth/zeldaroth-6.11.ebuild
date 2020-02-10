# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="ZeldaROTH_US-src-linux"

inherit desktop eutils

DESCRIPTION="The Legend of Zelda - Return of the Hylian"
HOMEPAGE="http://www.zeldaroth.fr/us/zroth.php"
SRC_URI="http://www.zeldaroth.fr/us/files/ROTH/Linux/${MY_PN}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl
	media-libs/sdl-gfx
	media-libs/sdl-image
	media-libs/sdl-mixer[midi]
"

S="${WORKDIR}/${MY_PN}/src"
PATCHES=( "${FILESDIR}/${PN}-homedir.patch" )

src_prepare() {
	default
	sed -i -e "s:ZeldaROTH_US:"${PN}":g" -i Makefile || die
	sed -i -e "s:CFLAGS  =:#CFLAGS  =:g" -i Makefile || die
	for i in `find . -name "*.cpp"`; do
		sed -i "$i" -e "s:data/:/usr/share/"${PN}"/data/:g" || die;
	done
}

src_install() {
	dobin ${PN}
	insinto "/usr/share/${PN}"
	doins -r data  || die "data install failed"
	newicon data/images/logos/triforce.ico ${PN}.png
	make_desktop_entry ${PN}
}
