# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A modder-friendly OpenGL source port based on the DOOM engine"
HOMEPAGE="https://zdoom.org/"
SRC_URI="https://zdoom.org/files/gzdoom/src/${PN}-g${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk kde openal"

RDEPEND="
	app-arch/bzip2
	kde? ( kde-apps/kdialog )
	media-libs/game-music-emu
	openal? (
		media-libs/libsndfile
		media-libs/openal
		media-sound/mpg123
	)
	>=media-libs/libsdl2-2.0.2[opengl]
	media-sound/fluidsynth
	sys-libs/zlib
	virtual/jpeg:0
	virtual/opengl
	gtk? ( x11-libs/gtk+:* )
"
DEPEND="${RDEPEND}
	app-arch/unzip
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-g${PV}"

src_prepare() {
	default
	sed -i -e "s:\(\/usr\/share\/doom\):\1-data:g" \
		src/gameconfigfile.cpp || die
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DNO_GTK=$(usex !gtk)
		-DNO_OPENAL=$(usex !openal)
	)
	cmake-utils_src_configure
}
