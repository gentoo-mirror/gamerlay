# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper multilib-minimal

TS=1371673270
MY_PN=StealthBastardDeluxe

DESCRIPTION="The fast-paced, nail-biting antidote to tippy-toed sneaking simulators."
HOMEPAGE="http://www.stealthbastard.com/"
SRC_URI="${MY_PN}_${PV}_Linux_${TS}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="fetch strip"

RDEPEND="
	dev-libs/openssl[${MULTILIB_USEDEP}]
	media-libs/openal[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
"

S="${WORKDIR}/${MY_PN}"

pkg_nofetch() {
	einfo "Please download ${A}"
	einfo "from your personal page in Humble Indie Bundle site"
	einfo "(http://www.humblebundle.com)"
	einfo "and place it to ${PORTAGE_ACTUAL_DESTDIR}"
}

src_install() {
	local dir="/opt/${PN}"
	insinto ${dir}
	doins -r assets
	exeinto ${dir}
	doexe "${MY_PN}"
	make_wrapper "${PN}" "./${MY_PN}" "${dir}"
	newicon "assets/icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "${MY_PN}" "${PN}"
}
