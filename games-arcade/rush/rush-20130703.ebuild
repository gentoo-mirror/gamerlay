# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper unpacker-nixstaller

MY_PN="${PN^^}"
TS="1372878397"
MY_P="${MY_PN}_${PV:0:4}-${PV:4:2}-${PV:6:2}_Linux_${TS}"

DESCRIPTION="A simple puzzler that'll have you mesmerized with a synchronized swarm of blocks"
HOMEPAGE="http://twotribes.com/message/rush/"
SRC_URI="${MY_P}.sh"
RESTRICT="fetch"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl2
	media-libs/openal
	sys-libs/zlib
"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${PORTAGE_ACTUAL_DISTDIR}"
	ewarn
}

S="${WORKDIR}"

DOCS=( "README.linux" )

src_unpack() {
	local arch=x86
	use amd64 && arch=x86_64
	nixstaller_unpack "instarchive_all" "instarchive_all_${arch}"
}

src_install() {
	local dir="/opt/${PN}"
	local arch
	use amd64 && arch=x86_64
	use x86 && arch=x86

	exeinto "${dir}"
	insinto "${dir}"

	make_desktop_entry "${PN}" "${MY_PN}" "${PN}"
	make_wrapper "${PN}" "./${PN}" "${dir}"

	newexe "${MY_PN}.bin.${arch}" "${PN}"
	newicon "${MY_PN}.png" "${PN}.png"

	doins -r \
		"namespace.txt" \
		"audio" \
		"config" \
		"default" \
		"effects" \
		"cursors" \
		"fx" \
		"fonts" \
		"gameworld" \
		"guide" \
		"loc" \
		"rubiks" \
		"shared"
	base_src_install_docs
}
