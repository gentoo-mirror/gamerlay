# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

HB_VERSION="${PV//\.}"
GOG_VERSION="2.1.0.4"

DESCRIPTION="A combination of platformer and role playing game"
HOMEPAGE="http://www.unepicgame.com/"
SRC_URI="
	hb? ( ${PN}-${HB_VERSION}.run )
	gog? ( gog_${PN}_${GOG_VERSION}.sh )
"

RESTRICT="fetch strip"
LICENSE="all-rights-reserved"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="hb gog"
REQUIRED_USE="^^ ( hb gog )"

DEPEND="app-arch/unzip"
RDEPEND="
	media-libs/libsdl2
	media-libs/mesa
	media-libs/sdl2-mixer
	sys-libs/glibc
	sys-libs/zlib
"

pkg_setup() {
	ewarn "Just be noticed, that both variants (GOG and HumbleBundle)"
	ewarn "have game binaries linked with relative path in DT_RPATH."
	ewarn "That means that it is pretty easy to preload any badware"
	ewarn "library to it by just putting in in current working dir,"
	ewarn "where you run the game from"
	ewarn ""
	ewarn "Portage will trigger bold red warnings about that on install phase."
}

pkg_nofetch() {
	einfo ""
	einfo "Please buy and download \"${A}\" from corresponding shop (HumbleBundle or GOG)"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo "You can get more info on ${HOMEPAGE}"
	einfo ""
}

src_unpack() {
	einfo "\nUnpacking files. This can take several minutes.\n"

	mkdir "${WORKDIR}/tmp" || die "mkdir 'tmp' failed"
	cd "${WORKDIR}/tmp" || die "cd 'tmp' failed"

	unzip -q "${DISTDIR}/${A}"

	local gpath;
	use gog && gpath="data/noarch/game"
	use hb  && gpath="data"

	rm "${gpath}"/lib* -r
	mv "${gpath}" "${S}"

	cd "${S}" && rm -r "${WORKDIR}/tmp"
}

src_install() {
	local dir="/usr/share/${PF}"
	insinto "${dir}"
	exeinto "${dir}"

	doins -r .
	doexe "${PN}"{32,64}* ${PN}.sh || die "Failed to install executables"

	doicon "${PN}.png"
	make_wrapper "${PN}" "./${PN}.sh" "${dir}"
	make_desktop_entry "${PN}" "${PN^}" "${PN}" || die "make_desktop_entry failed"
}

pkg_postinst() {
	einfo "Just in case: neither of these DRM-free versions sees Steam's savegames."
	einfo "In case, if you played in Steam and moved to DRM-free version,"
	einfo "consider copying files from:"
	einfo "~/.local/share/Steam/userdata/[your_user_id]/233980/remote/save"
	einfo "to:"
	einfo "~/.local/share/Unepic/unepic/save"
	einfo "and vice versa if you want to import DRM-free saves to Steam."
	einfo "Although, it can cause sudden game freezes..."
}
