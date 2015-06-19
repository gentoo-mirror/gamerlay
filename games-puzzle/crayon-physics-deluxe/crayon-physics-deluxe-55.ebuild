# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils multilib games

DESCRIPTION="2D physics puzzle / sandbox game, where your drawings would be magically transformed into real physical objects."
HOMEPAGE="http://crayonphysics.com/"

SRC_URI="${PN//-/_}-linux-release${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="multilib"
RESTRICT="strip fetch"

RDEPEND="
	sys-devel/gcc
	x86? (
		app-arch/bzip2
		dev-libs/expat
		dev-libs/glib
		dev-libs/libffi
		media-libs/fontconfig
		media-libs/freetype:2
		virtual/glu
		media-libs/libogg
		media-libs/libpng
		virtual/opengl
		sys-apps/util-linux
		sys-libs/zlib
		x11-libs/libdrm
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libxcb
		x11-libs/libXdamage
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXxf86vm
		dev-qt/qtcore
		dev-qt/qtgui
		media-libs/smpeg
		media-libs/libvorbis
		media-libs/libmikmod
		media-libs/sdl-mixer
		media-libs/sdl-image
	)
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-qtlibs
		app-emulation/emul-linux-x86-soundlibs
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-xlibs
	)
"

REQUIRED_USE="amd64? ( multilib )"

MY_PN="CrayonPhysicsDeluxe"
S="${WORKDIR}/${MY_PN}"

src_install() {
	( use amd64 && use multilib ) && ABI=x86
	GAMEDIR="${GAMES_PREFIX_OPT}/${MY_PN}"

	insinto "${GAMEDIR}"
	exeinto "${GAMEDIR}"

	# install icon
	newicon "icon.png" "${PN}.png" \
		|| die "install icon"

	# install docs
	dohtml readme.html

	# cleanup unneeded files
	rm -rf "./$(get_libdir)"
	rm \
		"icon.png" \
		"install_shortcuts.sh" \
		"launchcrayon.sh" \
		"launcher" \
		"LGPL.txt" \
		"LICENSE.txt" \
		"log.txt" \
		"README-CC.txt" \
		"README-GLEW.txt" \
		"readme.html" \
		"README-QT.txt" \
		"README-SDL.txt" \
		"uninstall_shortcuts.sh" \
		"update"

	# install game files
	doins -r * || die "doins opt"
	doexe crayon || die "doexe failed"

	# install shortcuts
	games_make_wrapper "${PN}" "./crayon" "${GAMEDIR}" || die "install shortcut"
	make_desktop_entry "${PN}" "Crayon Physics Deluxe" "${PN}"

	prepgamesdirs
}
