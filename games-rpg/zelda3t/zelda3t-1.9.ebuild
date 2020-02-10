# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

MY_PN="Zelda3T_US-src-linux"

DESCRIPTION="The Legend of Zelda - Time to Triumph"
HOMEPAGE="http://www.zeldaroth.fr/us/z3t.php"
SRC_URI="http://www.zeldaroth.fr/us/files/3T/Linux/${MY_PN}.zip"

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
	sed -i -e "s:Zelda3T:"${PN}":g" -i Makefile
	sed -i -e "s:CFLAGS  =:#CFLAGS  =:g" -i Makefile
	for i in `find . -name "*.cpp"`; do
		sed -i "$i" -e "s:data/:/usr/share/"${PN}"/data/:g";
	done
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r data  || die "data install failed"
	newicon data/images/logos/ocarina.ico ${PN}.png
	make_desktop_entry ${PN}
}
