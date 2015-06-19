# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit scons-utils toolchain-funcs games git-2

DESCRIPTION="3rd installment of the classic iD 3D first-person shooter"
HOMEPAGE="https://github.com/TTimo/doom3.gpl"
EGIT_REPO_URI="git://github.com/TTimo/doom3.gpl.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug dedicated opengl"

RDEPEND="
	opengl? (
		virtual/opengl
		alsa? ( media-libs/alsa-lib )
		amd64? ( app-emulation/emul-linux-x86-xlibs[opengl] )
	)
"
DEPEND="${RDEPEND}
	sys-devel/m4
"

dir=$(games_get_libdir)/${PN}

src_configure() {
	S+="/neo"

	myesconsargs=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
	)
		# FIXME build fails with JOBS=3
		#JOBS="$(echo -j1 ${MAKEOPTS} | sed -r "s/.*(-j\s*|--jobs=)([0-9]+).*/\2/")"

	if use debug; then
		myesconsargs+=( BUILD="debug-all" )
	else
		myesconsargs+=( BUILD="release" )
	fi

	if use dedicated; then
		if use opengl; then
			myesconsargs+=( DEDICATED="2" )
		else
			myesconsargs+=( DEDICATED="1" )
		fi
	else
		# TODO use EAPI4
		use !opengl && die "Nothing to build"
		myesconsargs+=( DEDICATED="0" )
	fi

	# FIXME needs 32-bit libz.a
	myesconsargs+=( NOCURL="1" )
}

src_compile() {
	escons
}

src_install() {
	exeinto "${dir}"
	doexe gamex86-base.so || die
	doexe gamex86-d3xp.so || die

	if use dedicated; then
		doexe doomded.x86 || die
	fi

	if use opengl; then
		doexe doom.x86 || die
		doexe sys/linux/setup/image/openurl.sh || die
		games_make_wrapper ${PN} ./doom.x86 "${dir}" "${dir}"
		newicon sys/linux/setup/image/doom3.png ${PN}.png || die
		make_desktop_entry ${PN} "Doom III GPL"
	fi

	prepgamesdirs

	dodoc sys/linux/setup/image/README || die
}

pkg_postinst() {
	games_pkg_postinst

	elog "You need to copy 'base' directory"
	elog "from either your installation media or your hard drive to"
	elog "${dir}/ before running the game."
	echo
	elog "To play the game, run:"
	elog " ${PN}"
	echo
}
