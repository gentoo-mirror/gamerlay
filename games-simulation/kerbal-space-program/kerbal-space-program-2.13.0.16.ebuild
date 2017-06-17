# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="A combination of platformer and role playing game"
HOMEPAGE="http://www.unepicgame.com/"
SRC_URI="gog_${P//-/_}.sh"

RESTRICT="fetch strip"
LICENSE="EULA"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="
	dev-libs/glib:2
	media-libs/mesa
	sys-libs/glibc:2.2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXrandr
"
QA_DIR="usr/share/${PF}"
QA_PREBUILT="${QA_DIR}/Launcher.x86 ${QA_DIR}/KSP.x86 ${QA_DIR}/Launcher_Data/Mono/x86/libmono.so ${QA_DIR}/KSP_Data/Mono/x86/libmono.so"

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

	local gpath="data/noarch/game"

	mv "${gpath}" "${S}"

	cd "${S}" && rm -r "${WORKDIR}/tmp"
}

src_install() {
	local arch="${ARCH//amd/x86_}"
	local dir="/usr/share/${PF}"
	insinto "${dir}"
	exeinto "${dir}"

	doins -r .
	doexe {KSP,Launcher}.x86{,_64} || die "Failed to install executables"

	newicon "Launcher_Data/Resources/UnityPlayer.png" "${PN}.png"
	make_wrapper "${PN}" "./KSP.${arch}" "${dir}"
	make_wrapper "${PN}-launcher" "./Launcher.${arch}" "${dir}"
	make_desktop_entry "${PN}" "Kerbal Space Program" "${PN}" || die "make_desktop_entry failed"
	make_desktop_entry "${PN}-launcher" "Kerbal Space Program: Launcher" "${PN}" || die "make_desktop_entry failed"
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
