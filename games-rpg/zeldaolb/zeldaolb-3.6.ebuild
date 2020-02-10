# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="ZeldaOLB_US-src-linux"

inherit desktop eutils

DESCRIPTION="The Legend of Zelda - Onilink Begins"
HOMEPAGE="http://www.zeldaroth.fr/us/zolb.php"
SRC_URI="http://www.zeldaroth.fr/us/files/OLB/Linux/${MY_PN}.zip"

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
	sed -i -e "s:ZeldaOLB:"${PN}":g" -i Makefile
	sed -i -e "s:CFLAGS  =:#CFLAGS  =:g" -i Makefile
	for i in `find . -name "*.cpp"`; do
		sed -i "$i" -e "s:data/:/usr/share/"${PN}"/data/:g";
	done
}

src_install() {
	dobin ${PN}
	insinto "/usr/share/${PN}"
	doins -r data  || die "data install failed"
	newicon data/images/logos/graal.ico ${PN}.png
	make_desktop_entry ${PN}
}
