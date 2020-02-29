# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

MY_PN=SuperMeatBoy

DESCRIPTION="A platformer where you play as an animated cube of meat"
HOMEPAGE="http://www.supermeatboy.com/"
SRC_URI="${PN}-linux-$(ver_cut 2)$(ver_cut 3)$(ver_cut 1)-bin"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RESTRICT="fetch"

DEPEND="app-arch/zip"
RDEPEND="
	media-libs/openal
	media-libs/libsdl2
"

S="${WORKDIR}/data"

pkg_nofetch() {
	einfo "Please download ${A}"
	einfo "from your personal page in Humble Indie Bundle site"
	einfo "(http://www.humblebundle.com)"
	einfo "and place it to ${DESTDIR}"
}

src_unpack() {
	# self unpacking zip archive; unzip warns about the exe stuff
	# (taken from lugaru ebuild)
	local a=${DISTDIR}/${A}
	echo ">>> Unpacking ${A} to ${PWD}"
	unzip -q "${a}"
	[ $? -gt 1 ] && die "unpacking failed"
}

src_install() {
	local dest="/opt/${PN}"
	insinto ${dest}
	doins -r resources Levels buttonmap.cfg \
		gameaudio.dat gamedata.dat locdb.txt \
		steam_appid.txt

	insinto "${dest}/${ARCH}"
	doins "${ARCH}"/libsteam_api.so
	doins "${ARCH}"/libmariadb.so.1

	exeinto "${dest}/${ARCH}"
	doexe "${ARCH}/${MY_PN}"

	make_wrapper "${PN}" "./${ARCH}/${MY_PN}" "${dest}" "./${ARCH}"

	doicon "${PN}".png
	make_desktop_entry "${PN}" "${MY_PN}" "${PN}"

	dodoc README-linux.txt
}
