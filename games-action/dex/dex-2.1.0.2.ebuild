# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils unpacker

GOG_PATCH_PV="2.0.1.2"

DESCRIPTION="2D Action-RPG with a rich cyberpunk world"
HOMEPAGE="http://en.dreadlocks.cz/games/dex/"
SRC_URI="
	gog? (
		gog_${PN}_${PV}.sh
		patch_${PN}_${GOG_PATCH_PV}.sh
	)
"

RESTRICT="fetch strip"
LICENSE="all-rights-reserved"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gog"

DEPEND="
	app-arch/unzip
	dev-util/xdelta:3
"
RDEPEND="
	dev-libs/glib
	media-libs/mesa
	virtual/libc
	x11-libs/gdk-pixbuf
	x11-libs/gtk+
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXrandr
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

src_prepare() {
	rm -r meta scripts
	default
	while read Line # -- patch files
	do
		Line2=$(echo $Line | cut -d " " -f 2-)
		xdelta3 -v -d -s "${Line2}" patch/"${Line2}".delta patch/"${Line2}".tmp || die "ERROR (patching): File version mismatch, quitting"
	done < patch/files_to_patch.list

	while read Line # -- move patched files to the right place
	do
		Line2=$(echo $Line | cut -d " " -f 2-)
		chmod $(stat -c%a "${Line2}") patch/"${Line2}".tmp
		mv -vf patch/"${Line2}".tmp "${Line2}"
	done < patch/files_to_patch.list

	while read Line # -- remove patch files
	do
		Line2=$(echo $Line | cut -d " " -f 2-)
		rm -vfr "patch/${Line2}".delta
	done < patch/files_to_patch.list
}

src_install() {
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
