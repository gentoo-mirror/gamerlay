# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN="Spirits"

inherit desktop eutils

DESCRIPTION="Save the spirits of leaf litters"
HOMEPAGE="http://www.spacesofplay.com/spirits/"
SRC_URI="${PN}-linux-${PV}_120903-1348705231.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/openal
"
#	media-libs/libsdl:2 #somewhy doesn't work with all latest versions of SDL2 in overlay
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_install() {
	local libdir binary
	local dir="/opt/${MY_PN}"

	use amd64 && {
		# TODO: unbundling SDL2
		libdir=x86_64
		binary=Spirits-64
	}

	use x86 && {
		# TODO: unbundling SDL2
		libdir=i686
		binary=Spirits-32
	}

	dodoc README.TXT

	rm "./${libdir}/libopenal.so.1"

	exeinto "${dir}"
	insinto "${dir}"
	doins -r data
	# TODO: unbundling SDL2
	doins -r "${libdir}"
	doexe "${binary}"

	# install shortcuts
	make_wrapper "${PN}" "./${binary}" "${dir}" "${dir}/${libdir}" || die "install shortcut"
	make_desktop_entry "${PN}" "${MY_PN}" "${PN}"
}

pkg_postinstall() {
	einfo "If pre-start dialog looks ugly for you, try to remove ~/.themes"
	einfo "At least, it helped me in such situation."
}
