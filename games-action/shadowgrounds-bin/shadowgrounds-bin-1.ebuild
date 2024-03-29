# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper multilib-minimal unpacker

DESCRIPTION="an epic action experience combining modern technology with addictive playability"
HOMEPAGE="http://shadowgroundsgame.com/"
SRC_URI="shadowgroundsUpdate${PV}.run"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="fetch strip"

DEPEND="app-arch/unzip"
RDEPEND="gnome-base/libglade[${MULTILIB_USEDEP}]"

S="${WORKDIR}"

d="/opt/${PN}"
QA_TEXTRELS_x86="`echo ${d#/}/lib32/lib{avcodec.so.51,avformat.so.52,avutil.so.49,FLAC.so.8}`"
QA_TEXTRELS_amd64="${QA_TEXTRELS_x86}"

pkg_nofetch() {
	einfo "Fetch ${SRC_URI} and put it into ${PORTAGE_ACTUAL_DISTDIR}/${A}"
	einfo "See http://www.humblebundle.com/ or LinuxGamePublishing for more info."
}

src_unpack() {
	# manually run unzip as the initial seek causes it to exit(1)
	unpack_zip ${A}
	rm lib*/lib{gcc_s,m,rt,selinux}.so.?
}

src_install() {
	local b bb

	doicon Shadowgrounds.xpm || die
	for b in bin launcher ; do
		bb="shadowgrounds-${b}"
		exeinto ${d}
		newexe ${bb} ${bb} || die
		make_wrapper ${bb} "./${bb}" "${d}" || die
		make_desktop_entry ${bb} "Shadowgrounds ${b}" Shadowgrounds
	done

	exeinto ${d}/lib32
	doexe lib32/* || die

	insinto ${d}
	doins -r Config data Profiles *.fbz *.glade *-logo.png || die
}
