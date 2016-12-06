# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils cmake-utils git-r3

EGIT_REPO_URI="https://gitlab.com/osslugaru/lugaru.git"
DESCRIPTION="3D arcade with unique fighting system and anthropomorphic characters"
HOMEPAGE="https://osslugaru.gitlab.io"
SRC_URI=""

LICENSE="GPL-2+ free-noncomm CC-BY-SA-3.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	virtual/glu
	virtual/opengl
	media-libs/libsdl[opengl,video]
	media-libs/openal
	media-libs/libvorbis
	virtual/jpeg:0
	media-libs/libpng:0
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}/${P}-dir.patch"
	sed -i \
		-e "s:@GENTOO_DIR@:${EROOT}/usr/share/${P}:" \
		Source/OpenGL_Windows.cpp || die
	default
}

src_configure() {
	mycmakeargs=(
		"-DCMAKE_VERBOSE_MAKEFILE=TRUE"
		"-DLUGARU_FORCE_INTERNAL_OPENGL=False"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	dobin "${WORKDIR}/${P}_build/lugaru"
	insinto "${EROOT}/usr/share/${P}"
	doins -r Data/
	newicon Source/win-res/Lugaru.png ${PN}.png
	make_desktop_entry ${PN} Lugaru ${PN}
}
