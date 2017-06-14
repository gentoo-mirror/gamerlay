# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="An isometric Action-RPG with a massive selection of items, powers and so on"
HOMEPAGE="https://www.victorvran.com/"
SRC_URI="
	gog_${PN}_${PV}.sh
"

RESTRICT="fetch strip"
LICENSE="EULA"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="
	app-crypt/mit-krb5
	app-crypt/p11-kit
	dev-db/sqlite
	dev-libs/libgcrypt:11/11
	dev-libs/libgpg-error
	media-libs/libsdl2
	media-libs/openal
	net-dns/libidn
	net-nds/openldap
	sys-apps/keyutils
	sys-apps/util-linux
	sys-libs/e2fsprogs-libs
	sys-libs/glibc:2.2
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb:0/1.12
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXt
"


pkg_nofetch() {
	einfo ""
	einfo "Please buy and download \"${A}\" from corresponding shop (HumbleBundle or GOG)"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo "You can get more info on ${HOMEPAGE}"
	einfo ""
	ewarn "Actually, I was unable to make this game to normally work on my machine,"
	ewarn "so if you succeeded to run it, consider to report it to me, please."
}

src_unpack() {
	einfo "\nUnpacking files. This can take several minutes.\n"

	mkdir "${WORKDIR}/tmp" || die "mkdir 'tmp' failed"
	cd "${WORKDIR}/tmp" || die "cd 'tmp' failed"

	unzip -q "${DISTDIR}/${A}"
	local gpath="data/noarch/game"

	#cp -L "${gpath}"/i386/usr/lib/i386-linux-gnu/{libcurl-gnutls.so.4,libgnutls.so.26,librtmp.so.0,libtasn1.so.3,liblber-2.4.so.2,libldap_r-2.4.so.2,libsasl2.so.2} "${gpath}"

	mv "${gpath/game/support}/icon.png" "${gpath}/${PN}.png"

	#rm "${gpath}"/i386 -r
	mv "${gpath}" "${S}"

	cd "${S}" && rm -r "${WORKDIR}/tmp"
}

src_install() {
	local bin="VictorVranGOG"
	local dir="/usr/share/${PF}"
	insinto "${dir}"
	exeinto "${dir}"

	doins -r .
	doexe "${bin}" || die "Failed to install executables"

	doicon "${PN}.png"
	make_wrapper "${PN}" "./${bin}" "${dir}" "."
	make_desktop_entry "${PN}" "${PN}" "${PN}" || die "make_desktop_entry failed"
}
