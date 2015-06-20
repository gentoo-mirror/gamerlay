# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils eutils games git-2

DESCRIPTION="ZDoom is an enhanced port of the official DOOM source code"
HOMEPAGE="http://www.zdoom.org"
EGIT_REPO_URI="https://github.com/rheit/zdoom"
#SRC_URI="http://www.zdoom.org/files/${PN}/2.5/${P}-src.7z"

LICENSE="BSD BUILD DOOM"
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_mmx gtk"

RDEPEND="app-arch/bzip2
	media-libs/fmod:1
	media-sound/fluidsynth
	sys-libs/zlib
	virtual/jpeg:0
	x11-libs/libXcursor
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	cpu_flags_x86_mmx? ( || ( dev-lang/nasm dev-lang/yasm ) )"

S="${WORKDIR}"

src_prepare() {
	# Add new versions of FMOD
	sed -i \
		-e "s:\(set( MAJOR_VERSIONS\):\1 \"40\" \"38\":" \
		src/CMakeLists.txt || die
	# Use default game data path
#	sed -i \
#		-e "s:/usr/local/share/:${GAMES_DATADIR}/doom-data/:" \
#		src/sdl/i_system.h || die "sed i_system.h failed"
}

src_configure() {
	mycmakeargs=(
		"-DFMOD_LOCAL_LIB_DIRS=/opt/fmodex/api/lib"
		"-DFMOD_INCLUDE_DIR=/opt/fmodex/api/inc"
#		"-DSHARE_DIR=\"${GAMES_DATADIR}/doom-data\""
		$(cmake-utils_use_no gtk GTK)
		$(cmake-utils_use_no cpu_flags_x86_mmx ASM)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	dogamesbin "${CMAKE_BUILD_DIR}/${PN}" || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/doom-data"
	doins "${CMAKE_BUILD_DIR}/${PN}.pk3" || die "doins failed"
	dodoc docs/commands.txt
	dohtml docs/console.{css,html}
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "Copy or link wad files into ${GAMES_DATADIR}/doom-data/"
	elog "(the files must be readable by the 'games' group)."
	elog
	elog "To play, simply run:"
	elog
	elog "   zdoom"
	echo
}
