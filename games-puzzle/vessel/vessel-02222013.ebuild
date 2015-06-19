# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit unpacker games

DESCRIPTION="Platform game where you manipulate liquids."
HOMEPAGE="http://strangeloopgames.com"
SRC_URI="${P}-bin"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="video_cards_intel"
RESTRICT="strip fetch"

DEPEND="app-arch/unzip"
RDEPEND="
	video_cards_intel? ( media-libs/libtxc_dxtn )
"

S=${WORKDIR}/data

pkg_nofetch() {
	echo
	elog "Download ${SRC_URI} from ${HOMEPAGE} and place it in ${DISTDIR}"
	echo
}

src_unpack() {
	unpack_zip "${A}"
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

	games_make_wrapper "${PN}" "./x86/${PN}.x86" "${dir}" "${dir}/x86"
	make_desktop_entry "${PN}" "Vessel" "${PN}"

	prepgamesdirs
}
