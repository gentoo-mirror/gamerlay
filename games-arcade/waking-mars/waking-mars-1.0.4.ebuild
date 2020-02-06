# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

DESCRIPTION="Waking Mars - Bring A Sleeping Planet Back To Life"
HOMEPAGE="http://www.tigerstylegames.com/wakingmars/"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch"
IUSE="multilib"

SRC_URI="WakingMars-${PV}-Linux.tar.gz"

RDEPEND="app-arch/bzip2[${MULTILIB_USEDEP}]
	dev-libs/json-c[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	media-libs/flac[${MULTILIB_USEDEP}]
	media-libs/freetype:2[${MULTILIB_USEDEP}]
	media-libs/libogg[${MULTILIB_USEDEP}]
	media-libs/libsdl[${MULTILIB_USEDEP}]
	media-libs/libsndfile[${MULTILIB_USEDEP}]
	media-libs/libvorbis[${MULTILIB_USEDEP}]
	virtual/opengl
	media-sound/pulseaudio[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	x11-libs/libdrm[${MULTILIB_USEDEP}]
	x11-libs/libICE[${MULTILIB_USEDEP}]
	x11-libs/libSM[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXau[${MULTILIB_USEDEP}]
	x11-libs/libxcb[${MULTILIB_USEDEP}]
	x11-libs/libXdamage[${MULTILIB_USEDEP}]
	x11-libs/libXdmcp[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXi[${MULTILIB_USEDEP}]
	x11-libs/libXtst[${MULTILIB_USEDEP}]
	x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

MY_PN="${PN//-}"
S="${WORKDIR}/WakingMars-${PV}-Linux/${MY_PN}"

REQUIRED_USE="amd64? ( multilib )"
pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	exeinto "${dir}"
	doexe "${MY_PN}"
	doicon "${MY_PN}.png"
	rm "${MY_PN}" "${MY_PN}.png"
	doins -r GameData lib

	make_wrapper "${PN}" "./${MY_PN}" "${dir}" "${dir}/lib"
	make_desktop_entry "${PN}" "Waking Mars" "Waking Mars"

	dodoc "../README.txt"
}
