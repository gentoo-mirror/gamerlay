# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib unpacker-nixstaller

TIMESTAMP="2014-12-22"

DESCRIPTION="An acrobatic janitor 2d platformer"
HOMEPAGE="http://dustforce.com"
SRC_URI="Dustforce-Linux-${TIMESTAMP}.sh"

RESTRICT="fetch"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	virtual/opengl
	app-arch/bzip2
	dev-libs/expat
	media-libs/fontconfig
	media-libs/freealut
	media-libs/freetype:2
	media-libs/libsdl
	media-libs/libogg
	media-libs/openal
	media-libs/libvorbis
	net-dns/libidn
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libxcb
"

S="${WORKDIR}"
MY_PN=Dustforce

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

src_unpack() {
	unzip -q "${DISTDIR}/${A}"
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	local exe arch;

	insinto "${dir}"
	doins -r "data/noarch/content"
	exeinto "${dir}"

	use x86   && arch="x86"
	use amd64 && arch="x86_64"

	exe="${MY_PN}.bin.${arch}"
	doexe "data/${arch}/${exe}"

	# Broken dep
	insinto "${dir}/$(get_libdir)"
	doins -r "data/${arch}/$(get_libdir)"/*
	doicon "data/noarch/${MY_PN}.png"
	make_desktop_entry "${PN}" "${MY_PN}" "${MY_PN}"
	make_wrapper "${PN}" "./${exe}" "${dir}" "${dir}/$(get_libdir)"

	dodoc data/noarch/README.linux
}
