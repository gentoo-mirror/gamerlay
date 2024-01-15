# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit wrapper desktop unpacker-nixstaller

MY_PN="${PN^^}"
TS="1372878397"
MY_P="${MY_PN}_${PV:0:4}-${PV:4:2}-${PV:6:2}_Linux_${TS}"

DESCRIPTION="Develop your telekinetic strength by pushing a Cube within a geometric universe."
HOMEPAGE="http://mobigame.net/"
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
	local arch
	use amd64 && arch=x86_64
	use x86 && arch=x86
	nixstaller_unpack "instarchive_all" "instarchive_all_${arch}"
}

src_install() {
	local dir="/opt/${PN}"
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
		"cos.bin" \
		"font.bin" \
		"audio" \
		"config" \
		"default" \
		"effects" \
		"images" \
		"levels" \
		"localization" \
		"models" \
		"music" \
		"sprites" \
		"textures"
	base_src_install_docs
}
