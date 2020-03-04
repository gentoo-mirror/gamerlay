# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

MY_P="${PN}_${PV}-1"

DESCRIPTION="Crack into virtual computer systems"
HOMEPAGE="http://www.uplink.co.uk"
SRC_URI="amd64? ( ${MY_P}_amd64.tar.gz )
	x86? ( ${MY_P}_i386.tar.gz )"
RESTRICT="fetch"

# Bundled libs :(
QA_PRESTRIPPED="/opt/${PN}/lib.*"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	media-libs/libsdl[opengl]
	media-libs/sdl-mixer[mikmod]
	media-libs/freetype:2"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

src_unpack() {
	local root

	unpack ${A}

	if use amd64; then
		root=uplink-x64
	elif use x86; then
		root=uplink-x86
	else
		die "unsupported architecture"
	fi

	mv "$root" uplink || die "failed to move unpacked data"
}

S="${WORKDIR}/${PN}"

src_install() {
	local dir="/opt/${PN}"
	local exe lib

	insinto "${dir}"
	doins *.dat

	if use amd64; then
		lib=lib64
		exe=uplink.bin.x86_64
	elif use x86; then
		lib=lib
		exe=uplink.bin.x86
	else
		die "unsupported architecture"
	fi

	# The system SDL libs should work fine, but install the other bundled
	# libraries which use older SONAMEs than the versions in Gentoo.
	insinto "${dir}/${lib}"
	doins "${lib}"/libjpeg.so.62*
	doins "${lib}"/libtiff.so.3*
	doins "${lib}"/libmikmod.so.2*

	exeinto "${dir}"
	doexe "${exe}"

	doicon uplink.png
	make_desktop_entry "${PN}" Uplink uplink
	make_wrapper "${PN}" "${dir}/$exe"

	dodoc changes.txt mods.txt readme.txt
}
