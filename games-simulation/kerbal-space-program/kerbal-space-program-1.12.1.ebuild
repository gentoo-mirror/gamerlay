# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="A space flight simulation"
HOMEPAGE="http://kerbalspaceprogram.com/"

GOG_MAGIC="03142_48164"

SRC_PH="${PN//-/_}@PH@_${PV//./_}_${GOG_MAGIC}.sh"
SRC_URI="
	l10n_en? ( ${SRC_PH//@PH@/} )
"

RESTRICT="fetch strip"
LICENSE="all-rights-reserved"

SLOT="0"
KEYWORDS="-* ~amd64"

L10NS="l10n_en" #l10n_es l10n_fr l10n_it l10n_ja l10n_pt-BR l10n_ru l10n_zh-CN"
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

	#use l10n_de && unzip -oq ksp-lang-de-de.zip && rm ksp-lang-de-de.zip
	#use l10n_es && unzip -oq ksp-lang-es-es.zip && rm ksp-lang-es-es.zip
	#use l10n_fr && unzip -oq ksp-lang-fr-fr.zip && rm ksp-lang-fr-fr.zip
	#use l10n_it && unzip -oq ksp-lang-it-it.zip && rm ksp-lang-it-it.zip
	#use l10n_ja && unzip -oq ksp-lang-ja.zip && rm ksp-lang-ja.zip
	#use l10n_pt-BR && unzip -oq ksp-lang-pt-br.zip && rm ksp-lang-pt-br.zip
	#use l10n_ru && unzip -oq ksp-lang-ru.zip && rm ksp-lang-ru.zip
	#use l10n_zh-CN && unzip -oq ksp-lang-zh-cn.zip && rm ksp-lang-zh-cn.zip

	rm -r "${WORKDIR}/tmp"

	find . -name .DS_Store -delete
}

src_prepare() {
	default
	sed -e "s@__PV__@${PV}@" -e "s@__PN__@${PN}@" "${FILESDIR}/ksp-wrapper" > "${T}"/ksp-wrapper
}

src_install() {
	local dir="/usr/share/${PN}"
	insinto "${dir}"
	exeinto "${dir}"

	doins -r .
	doexe {KSP,KSPLauncher}.x86_64 || die "Failed to install executables"

	newbin "${T}/ksp-wrapper" "${PN}"
	newicon "KSPLauncher_Data/Resources/UnityPlayer.png" "${PN}.png"
	make_desktop_entry "${PN}" "Kerbal Space Program" "${PN}" || die "make_desktop_entry failed"
}
