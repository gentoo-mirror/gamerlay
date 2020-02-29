# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils unpacker

DESCRIPTION="Divinity: Original Sin - Enhanced Edition (GOG edition)"
HOMEPAGE="http://www.divinityoriginalsin-enhanced.com/"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="-* ~amd64"
RESTRICT="fetch"

SRC_URI="divinity_original_sin_enhanced_edition_${PV}_gog.sh"

RDEPEND="
	media-libs/libpng:0/16
	media-libs/libsdl2
	media-libs/mesa
	media-libs/openal
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

QA_PRESTRIPPED="
opt/Divinity_OS_EE/game/*
"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

src_unpack() {
	unpack_mojosetup
}

src_install() {
	local dir="/opt/Divinity_OS_EE"

	insinto "${dir}"
	doins -r data/noarch/.

	exeinto "${dir}"
	doexe "data/noarch/start.sh"
	exeinto "${dir}/game"
	doexe "data/noarch/game/runner.sh"

	fowners :users game/Data/Localization/language.lsx
	fperms 664 game/Data/Localization/language.lsx

	make_wrapper "${PN}" "./start.sh" "${dir}"
	newicon "data/noarch/support/icon.png" "${PN}.png" || die
	make_desktop_entry "${PN}" "${MY_PN}" "${MY_PN}"
}

pkg_postinst() {
	ewarn "Since EAPI6 forbids using 'games' group anymore,"
	ewarn "please consider adding your user to 'users' group."
	ewarn "That is needed because upstream's game wrapper uses sed internally"
	ewarn "to patch some game files on each run."
}
