# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils multilib-minimal

DESCRIPTION="A mind-bending platforming adventure from Double Fine Productions."
HOMEPAGE="http://www.psychonauts.com/"
SRC_URI="${PN}-linux-$(ver_cut 2)$(ver_cut 3)$(ver_cut 1)-bin"

LICENSE="Psychonauts-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="virtual/opengl
	media-libs/openal[${MULTILIB_USEDEP}]
	media-libs/libsdl[${MULTILIB_USEDEP}]"

RESTRICT="fetch strip"

S="${WORKDIR}/data"

pkg_nofetch() {
	einfo "Please download ${A}"
	einfo "from your personal page in Humble Indie Bundle V site"
	einfo "(http://www.humblebundle.com)"
	einfo "and place it to ${DISTDIR}"
}

src_unpack() {
	# self unpacking zip archive; unzip warns about the exe stuff
	# (taken from lugaru ebuild)
	local a=${DISTDIR}/${A}
	echo ">>> Unpacking ${a} to ${PWD}"
	unzip -q "${a}"
	[ $? -gt 1 ] && die "unpacking failed"
}

src_install() {
	local dir="/opt/${PN}"
	dodoc "Psychonauts Manual Win.pdf"
	dodoc Documents/Readmes/*
	exeinto ${dir}
	doexe Psychonauts || die
	insinto ${dir}
	doins -r DisplaySettings.ini PsychonautsData2.pkg WorkResource || die
	doicon ${PN}.png
	make_wrapper ${PN} ./Psychonauts "${dir}" "${dir}"
	make_desktop_entry ${PN} Psychonauts ${PN}
}
