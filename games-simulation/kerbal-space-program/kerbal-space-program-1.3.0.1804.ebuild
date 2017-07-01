# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="A combination of platformer and role playing game"
HOMEPAGE="http://www.unepicgame.com/"

GOG_MAGIC="2.13.0.16"

SRC_PH="gog_${PN//-/_}@PH@_${GOG_MAGIC}.sh"
SRC_URI="
	l10n_en? ( ${SRC_PH//@PH@} )
	l10n_es? ( ${SRC_PH//@PH@/_spanish} )
	l10n_ja? ( ${SRC_PH//@PH@/_japanese} )
	l10n_ru? ( ${SRC_PH//@PH@/_russian} )
	l10n_zh-CN? ( ${SRC_PH//@PH@/_chinese} )
"

RESTRICT="fetch strip"
LICENSE="EULA"

SLOT="0"
KEYWORDS="amd64 x86"

L10NS="l10n_en l10n_es l10n_ja l10n_ru l10n_zh-CN"
IUSE="${L10NS}"
REQUIRED_USE="^^ ( ${L10NS} )"

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
	local tmp="${WORKDIR}/tmp"
	einfo "\nUnpacking files. This can take several minutes.\n"

	mkdir "${tmp}" || die "mkdir 'tmp' failed"
	cd "${tmp}" || die "cd 'tmp' failed"

	unzip -q "${DISTDIR}/${A}"
	local gpath="data/noarch/game"

	mv "${gpath}" "${S}"

	cd "${S}"

	use l10n_es && unzip -oq KSP-LANG-ES-ES.zip && rm KSP-LANG-ES-ES.zip
	use l10n_ja && unzip -oq KSP-LANG-JA.zip && rm KSP-LANG-JA.zip
	use l10n_ru && unzip -oq KSP-LANG-RU.zip && rm KSP-LANG-RU.zip
	use l10n_zh-CN && unzip -oq KSP-LANG-ZH-CN.zip && rm KSP-LANG-ZH-CN.zip

	rm -r "${WORKDIR}/tmp"

	find . -name .DS_Store -delete

	sed -e "s@__PV__@${PV}@" "${FILESDIR}/ksp-wrapper" > "${T}"/ksp-wrapper
}

src_install() {
	local arch="${ARCH//amd/x86_}"
	local dir="/usr/share/${PF}"
	insinto "${dir}"
	exeinto "${dir}"

	doins -r .
	doexe {KSP,Launcher}.x86{,_64} || die "Failed to install executables"

	newbin "${T}/ksp-wrapper" "${PN}"
	newicon "Launcher_Data/Resources/UnityPlayer.png" "${PN}.png"
	make_desktop_entry "${PN}" "Kerbal Space Program" "${PN}" || die "make_desktop_entry failed"
}
