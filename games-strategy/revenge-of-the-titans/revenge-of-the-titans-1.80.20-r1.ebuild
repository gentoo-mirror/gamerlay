# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper java-pkg-2

MY_PN=RevengeOfTheTitans
# Divide second subversion by 10, i.e. 1.80.10 => 1810
#MY_PV=$(version_format_string '${1}$((${2} / 10))${3}')
MY_PV=$(ver_rs 1-2 "")

DESCRIPTION="Defeat the returning Titan horde in a series of epic ground battles."
HOMEPAGE="http://www.puppygames.net/revenge-of-the-titans/"
SRC_URI="
	amd64? ( ${MY_PN}-HIB-${MY_PV}-amd64.tar.gz )
	x86? ( ${MY_PN}-HIB-${MY_PV}-i386.tar.gz ) )
"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/jre-1.6
	virtual/opengl
"

RESTRICT="fetch mirror strip"

dir="/opt/${MY_PN}"
S="${WORKDIR}/revengeofthetitans"

pkg_nofetch() {
	local TARBALL
	if use amd64 ; then
		TARBALL="${MY_PN}-HIB-${MY_PV}-amd64.tar.gz"
	fi
	if use x86 ; then
		TARBALL="${MY_PN}-HIB-${MY_PV}-i386.tar.gz"
	fi
	einfo "Please download ${TARBALL}"
	einfo "from your personal page in Humble Indie Bundle site"
	einfo "(http://www.humblebundle.com) and place it in ${DISTDIR}"
}

# nothing to do ... stubs for eclasses
src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto "${dir}"
	doins *.jar || die "doins jar"

	exeinto "${dir}"
	doexe *.so revenge.sh || die "doexe"

	make_wrapper ${PN} ./revenge.sh "${dir}" "${dir}"
	doicon revenge.png
	make_desktop_entry ${PN} "Revenge of the Titans" revenge
}
