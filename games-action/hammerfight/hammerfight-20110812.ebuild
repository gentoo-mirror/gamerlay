# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

DESCRIPTION="2D battles of flying machines equipped with various weaponry"
HOMEPAGE="http://www.koshutin.com/"
SRC_URI="hf-linux-${PV:4}${PV:0:4}-bin"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_ru"

DEPEND="app-arch/unzip"
RDEPEND="media-libs/libsdl[joystick,sound,video]
	media-libs/openal"

RESTRICT="fetch"

S="${WORKDIR}/data"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

src_unpack() {
	unzip -q "${DISTDIR}"/${A}
	[ $? -gt 1 ] && die "unpacking failed"
}

src_install() {
	local dir="/opt/${PN}"
	local exe

	if use l10n_ru ; then
		einfo "Russian is chosen for primary language"
		mv Data/Dialogs/{russian,english}.seria
	fi

	insinto "${dir}"
	doins -r Data Media Objects Saves media.script strings.txt Config.ini \
		|| die "doins failed"

	if use amd64 ; then
		exe=Hammerfight-amd64
	fi
	if use x86 ; then
		exe=Hammerfight-x86
	fi
	exeinto "${dir}"
	doexe ${exe} || die "doexe failed"

	make_wrapper ${PN} ./${exe} "${dir}" "${dir}"
	doicon ${PN}.png
	make_desktop_entry ${PN} "Hammerfight" ${PN}
}
