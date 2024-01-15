# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper multilib-minimal unpacker

DESCRIPTION="An extraordinary mixture of action and strategy."
HOMEPAGE="http://www.anomalythegame.com/"
# Is it non-HiB distfile?
SRC_URI="AnomalyWarzoneEarth-Installer_Humble_Linux_1364850491.zip"
RESTRICT="fetch strip"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/openal[${MULTILIB_USEDEP}]
	x11-libs/libdrm[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXau[${MULTILIB_USEDEP}]
	x11-libs/libxcb[${MULTILIB_USEDEP}]
	x11-libs/libXdamage[${MULTILIB_USEDEP}]
	x11-libs/libXdmcp[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	virtual/opengl
	app-arch/unzip
"

S="${WORKDIR}"

src_unpack() {
	#double-zipped files, lol
	unpack ${A}
	# self unpacking zip archive; unzip warns about the exe stuff
	local a="${S}/AnomalyWarzoneEarth-Installer"
	unpack_zip "${a}"
	rm "${a}" # save space
}

pkg_nofetch() {
	ewarn
	ewarn "Put ${A} (downloaded from Humble Store) to ${PORTAGE_ACTUAL_DISTDIR}, please"
	ewarn
}

src_install() {
	cd "${S}/data"
	local dir="/opt/${PN}"

	newicon "icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "Anomaly: Warzone Earth" "${PN}"
	make_wrapper "${PN}" "./AnomalyWarzoneEarth" "${dir}"
	dodoc README
	exeinto "${dir}"
	doexe "AnomalyWarzoneEarth"
	rm	"libgcc_s.so.1" \
		"libopenal.so.1" \
		"libstdc++.so.6" \
		"icon.png" \
		"README" \
		"AnomalywarzoneEarth" \
		"AnomalyWarzoneEarth" \
		"AnomalyWarzoneEarth-old" \
		"Copyright license Lua" \
		"Copyright license OggVorbis" \
		"Copyright license Theora" \
		"Copyright license Xpm"
	insinto "${dir}"
	doins -r .
}
