# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils unpacker

DESCRIPTION="Action RPG with open world"
HOMEPAGE="https://en.wikipedia.org/wiki/Two_Worlds_(video_game)"
SRC_URI="
	gog? (
		gog_two_worlds_epic_edition_${PV}.sh
	)
"

RESTRICT="fetch strip"
LICENSE="all-rights-reserved"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+gog"

DEPEND="app-arch/unzip"
RDEPEND="app-emulation/wine-vanilla
	app-emulation/winetricks
"

S="${WORKDIR}"

pkg_nofetch() {
	einfo ""
	einfo "Please open ${HOMEPAGE}, choose a place to buy it,"
	einfo "then download \"${SRC_URI}\", and move/link it to \"${DISTDIR}\""
	einfo ""
	einfo "P.S.: I've only gog version. So, if you have Humble Store version"
	einfo "and want this ebuild to also cover it — please contact me."
}

src_unpack() {
	for f in ${A[@]}; do
		unzip -qn "${DISTDIR}/${f}"
	done
}

src_install() {
exit
	local dir="/opt/${PN}" arch="x86" exe modexe;

#	use amd64 && arch="x86_64";
	exe="${PN^}.x86"; # fixme when gog'll release x86_64 version
	cfgexe="GamepadConfigTool.x86" #.${arch}";

	insinto "${dir}";
	exeinto "${dir}";

	cd data/noarch;

	doins -r game/*
	doexe "game/${exe}" "game/${cfgexe}" "support/gog-system-report.sh"

	touch "${D}/${dir}/controller.config"
	fperms 666 "${dir}/controller.config" # so, gamepad config tool will be able to save content to it, even if runs under unpriv. user

	make_wrapper "${PN}" "./${exe}" "${dir}"
	make_wrapper "${PN}-gog-system-report" "./gog-system-report.sh" "${dir}"
	make_wrapper "${PN}-gc" "./${cfgexe}" "${dir}"
	newicon "support/icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "${PN^}: Play" "${PN}"
	make_desktop_entry "${PN}-gc" "${PN^}: Gamepad Configuration tool" "${PN}"
}

pkg_postinst() {
	einfo 'If game badly detects your gamepad (i.e. some keys is not working),'
	einfo 'you can run `dex-gc` tool (Gamepad Configuration tool)'
	einfo 'It will calibrate your gamepad and save configuration so Dex game'
	einfo 'will be able to load it and work normally with your gamepad'
}
