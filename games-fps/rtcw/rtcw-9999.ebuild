# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games git-2

DESCRIPTION="Return to Castle Wolfenstein - IORTCW Project"
HOMEPAGE="http://games.activision.com/games/wolfenstein/"
EGIT_REPO_URI="https://github.com/iortcw/iortcw.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl"

UIDEPEND="
	(
		media-libs/libsdl2
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXext
		virtual/opengl
	)"
RDEPEND="sys-libs/glibc
	opengl? ( ${UIDEPEND} )"

dir=${GAMES_PREFIX_OPT}/${PN}
ARCHITECTURE=$(uname -m)

src_prepare(){
	epatch "${FILESDIR}/${PN}-zlib.patch"
	cp "${FILESDIR}/Makefile.local" "${S}/SP/"
}

src_compile() {
	cd "${S}/SP/"
	ARCH="${ARCHITECTURE}" emake
}

src_install() {
	cd "${S}/SP/"
	ARCH="${ARCHITECTURE}" \
	COPYDIR=${D}/${GAMES_PREFIX_OPT}/${PN} \
	emake copyfiles

	#games_make_wrapper rtcwmp ./wolf.x86 "${dir}" "${dir}"
	games_make_wrapper rtcwsp ./iowolfsp."${ARCHITECTURE}" "${dir}" "${dir}"

	#if use dedicated; then
	#	games_make_wrapper wolf-ded ./wolfded.x86 "${dir}" "${dir}"
	#	newinitd "${FILESDIR}"/wolf-ded.rc wolf-ded
	#	sed -i \
	#		-e "s:GENTOO_DIR:${dir}:" \
	#		"${D}"/etc/init.d/wolf-ded \
	#		|| die
	#fi

	doicon -s scalable misc/iortcw.svg
	make_desktop_entry rtcwsp "Return to Castle Wolfenstein (SP)" iortcw
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "You need to copy pak0.pk3, mp_pak0.pk3, mp_pak1.pk3, mp_pak2.pk3,"
	elog "sp_pak1.pk3 and sp_pak2.pk3 from a Window installation into ${dir}/main/"
	elog
	elog "To play the game run:"
	elog " rtcwsp (single-player)"
	#elog " rtcwmp (multi-player)"
	elog
#	if use dedicated
#	then
#		elog "To start a dedicated server run:"
#		elog " /etc/init.d/wolf-ded start"
#		elog
#		elog "To run the dedicated server at boot, type:"
#		elog " rc-update add wolf-ded default"
#		elog
#		elog "The dedicated server is started under the ${GAMES_USER_DED} user account"
#		echo
#	fi
}
