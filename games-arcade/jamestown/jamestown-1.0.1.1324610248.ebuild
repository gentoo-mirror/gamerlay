# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games
inherit versionator
inherit toolchain-funcs

DESCRIPTION="A neo-classical top-down shooter for up to four players set on
17th-century British Colonial Mars."
HOMEPAGE="http://www.finalformgames.com/jamestown/"
MY_PN="jtownlinux"
MY_PV=$(replace_all_version_separators '_')
MY_INSTALLER_PN="JamestownInstaller"
MY_INSTALLER_PV=$(get_version_component_range 1-3 ${MY_PV})
SRC_URI="${MY_PN}_${MY_PV}.zip"
RESTRICT="fetch"

LICENSE="Jamestown"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	media-libs/libsdl[opengl]
	>=sys-devel/gcc-4.6"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

src_unpack() {
	default
	pwd
	unzip "${MY_INSTALLER_PN}_${MY_INSTALLER_PV}-bin"
}

S="${WORKDIR}/data"

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	insinto ${dir}
	doins -r Archives Distribution.txt
	exeinto ${dir}
	if use amd64; then
		EXESUFFIX="-amd64"
	else
		EXESUFFIX="-x86"
	fi
	EXENAME="Jamestown${EXESUFFIX}"
	doexe ${EXENAME}
	doicon ${PN}.png
	make_desktop_entry ${PN} Jamestown ${PN}
	games_make_wrapper ${PN} ./${EXENAME} ${dir} ${dir}
	dodoc Jamestown_EULA.txt LICENSES.TXT README-linux-generic.txt README-linux.txt
	prepgamesdirs
}

pkg_postinst() {
	version_is_at_least 4.6 $(gcc-version) ||
	ewarn "${PN} needs gcc version 4.6 or higher activated with gcc-config to
	work properly. Please make sure to use gcc-config to set this."
}
