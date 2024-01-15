# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper unpacker

DESCRIPTION="Famous 2D shooting game"
HOMEPAGE="http://www.snkplaymore.co.jp/us/games/steam/metalslug3/"
SRC_URI="MetalSlug3-Linux-$(ver_rs 1-2 -).sh"

RESTRICT="fetch strip"
LICENSE="all-rights-reserved"

SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
RDEPEND="
	media-libs/libsdl2
	media-libs/sdl2-mixer
	sys-libs/zlib
"

S="${WORKDIR}/data"

pkg_nofetch() {
	einfo ""
	einfo "Please buy and download \"${SRC_URI}\" from"
	einfo "HumbleIndieBundle or ${HOMEPAGE}"
	einfo "and move/link it to \"${PORTAGE_ACTUAL_DISTDIR}\""
	einfo ""
}

src_install() {
	local arch;

	use amd64 && arch="x86_64";
	use x86 && arch="x86";

	# Install documentation
	dodoc noarch/README.linux noarch/LICENSES.txt noarch/ARPHICPL.TXT
	rm noarch/README.linux noarch/LICENSES.txt noarch/ARPHICPL.TXT

	# Install data
	insinto "/opt/${PN}"
	doins -r noarch/*
	exeinto "/opt/${PN}"
	doexe "${arch}/MetalSlug3.bin.${arch}"

	# Install icon and desktop file
	newicon "noarch/icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "Metal Slug 3" "${PN}"
	make_wrapper "${PN}" "./MetalSlug3.bin.${arch}" "/opt/${PN}"
}
