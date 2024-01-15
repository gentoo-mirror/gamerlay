# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper unpacker

DESCRIPTION="Platform game where you manipulate liquids."
HOMEPAGE="http://strangeloopgames.com"
SRC_URI="${PN}-$(ver_cut 2)$(ver_cut 3)$(ver_cut 1)-bin"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip fetch"

DEPEND="app-arch/unzip"

S=${WORKDIR}/data

pkg_nofetch() {
	echo
	elog "Download ${SRC_URI} from ${HOMEPAGE} and place it in ${PORTAGE_ACTUAL_DISTDIR}"
	echo
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	exeinto "${dir}"/x86

	newicon "${FILESDIR}/${PN}.png" "${PN}.png"
	dodoc "Linux.README"

	rm "Vessel.bmp" "Linux.README"

	doins -r Data
	doexe x86/*

	make_wrapper "${PN}" "./x86/${PN}.x86" "${dir}" "${dir}/x86"
	make_desktop_entry "${PN}" "Vessel" "${PN}"
}
