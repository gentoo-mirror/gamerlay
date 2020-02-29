# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils unpacker

TIMESTAMP="2015-04-01"

DESCRIPTION="An action role-playing game, made by the creators of Diablo"
HOMEPAGE="http://torchlight2game.com/"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch"

SRC_URI="Torchlight2-linux-${TIMESTAMP}.sh"

RDEPEND="
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"
MY_PN="${PN^}"

QA_PRESTRIPPED="
	opt/${MY_PN}/lib64/*
	opt/${MY_PN}/lib/*
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
	local dir="/opt/${MY_PN}"

	local arch=x86;
	use amd64 && arch="x86_64"

	insinto "${dir}"
	doins -r data/noarch/* "data/${arch}/$(get_libdir)"
	exeinto "${dir}"

	local exe modexe
	exe="${MY_PN}.bin.${arch}"
	modexe="ModLauncher.bin.${arch}"

	doexe "data/${arch}/${exe}" "data/${arch}/${modexe}"

	make_wrapper "${PN}" "./${exe}" "${dir}" "${dir}/$(get_libdir)"
	make_wrapper "${PN}-modlauncher" "./${modexe}" "${dir}" "${dir}/$(get_libdir)"
	newicon "data/noarch/Delvers.png" "${MY_PN}.png"
	make_desktop_entry "${PN}" "${MY_PN}: Play" "${MY_PN}"
	make_desktop_entry "${PN}-modlauncher" "${MY_PN}: Mods Launcher" "${MY_PN}"
}
