# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker

TS=1324610248

DESCRIPTION="A neo-classical top-down shooter for up to four players."
HOMEPAGE="http://www.finalformgames.com/jamestown/"
MY_INSTALLER_PN="JamestownInstaller"
SRC_URI="jtownlinux_$(ver_rs 1-2 _)_${TS}.zip"
RESTRICT="fetch"

LICENSE="Jamestown"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="media-libs/libsdl[opengl]"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

src_unpack() {
	default
	unpack_zip "${WORKDIR}/JamestownInstaller_$(ver_rs 1-2 _)-bin"
}

S="${WORKDIR}/data"

src_install() {
	local dir="/opt/${PN}"
	local exe
	insinto ${dir}
	doins -r Archives Distribution.txt
	exeinto ${dir}
	use amd64 && exe="Jamestown-amd64"
	use x86 && exe="Jamestown-x86"
	doexe ${exe}
	doicon ${PN}.png
	make_desktop_entry ${PN} Jamestown ${PN}
	make_wrapper ${PN} ./${exe} ${dir} ${dir}
	dodoc README-linux-generic.txt README-linux.txt
}
