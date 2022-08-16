# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop multilib-minimal wrapper

DESCRIPTION="2D physics puzzle / sandbox game."
HOMEPAGE="http://crayonphysics.com/"

SRC_URI="${PN//-/_}-linux-release${PV}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="multilib"
RESTRICT="strip fetch"

RDEPEND="
	app-arch/bzip2[${MULTILIB_USEDEP}]
	dev-libs/expat[${MULTILIB_USEDEP}]
	dev-libs/glib[${MULTILIB_USEDEP}]
	dev-libs/libffi[${MULTILIB_USEDEP}]
	media-libs/fontconfig[${MULTILIB_USEDEP}]
	media-libs/freetype:2[${MULTILIB_USEDEP}]
	virtual/glu[${MULTILIB_USEDEP}]
	media-libs/libogg[${MULTILIB_USEDEP}]
	media-libs/libpng[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	sys-apps/util-linux[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	x11-libs/libdrm[${MULTILIB_USEDEP}]
	x11-libs/libICE[${MULTILIB_USEDEP}]
	x11-libs/libSM[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXau[${MULTILIB_USEDEP}]
	x11-libs/libxcb[${MULTILIB_USEDEP}]
	x11-libs/libXdamage[${MULTILIB_USEDEP}]
	x11-libs/libXdmcp[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXinerama[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-libs/libXrender[${MULTILIB_USEDEP}]
	x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	media-libs/smpeg[${MULTILIB_USEDEP}]
	media-libs/libvorbis[${MULTILIB_USEDEP}]
	media-libs/libmikmod[${MULTILIB_USEDEP}]
	media-libs/sdl-mixer[${MULTILIB_USEDEP}]
	media-libs/sdl-image[${MULTILIB_USEDEP}]
"

MY_PN="CrayonPhysicsDeluxe"
S="${WORKDIR}/${MY_PN}"

src_install() {
	( use amd64 && use multilib ) && ABI=x86
	local dir="/opt/${MY_PN}"

	insinto "${dir}"
	exeinto "${dir}"

	# install icon
	newicon "icon.png" "${PN}.png" || die "install icon"

	# install docs
	dodoc readme.html

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
	make_wrapper "${PN}" "./crayon" "${dir}" || die "install shortcut"
	make_desktop_entry "${PN}" "Crayon Physics Deluxe" "${PN}"
}
