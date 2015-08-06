# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils games git-2

DESCRIPTION="An open-source reimplementation of the popular UFO: Enemy Unknown"
HOMEPAGE="http://openxcom.org/"
# For translation files
SRC_URI="http://openxcom.org/git_builds/openxcom_git_master_2015_08_06_1651.zip"
EGIT_REPO_URI="https://github.com/SupSuper/OpenXcom.git"
EGIT_COMMIT=9a8641a7993c53e5f81f6748f08af3d7a4b72d8f

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND="app-arch/unzip
	>=dev-cpp/yaml-cpp-0.5.1
	media-libs/libsdl
	media-libs/sdl-gfx
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-sound/timidity++"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/OpenXcom"

DOCS=( README.md )

src_configure() {
	mycmakeargs=(
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-DDATADIR=${GAMES_DATADIR}/${PN}"
	)
	cmake-utils_src_configure
}

src_compile() {
	use doc && cmake-utils_src_compile doxygen
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	use doc && dohtml -r "${CMAKE_BUILD_DIR}"/docs/html/*

	for i in "common" "standard/xcom1" "standard/xcom2" ; do
		insinto "${GAMES_DATADIR}/${PN}/${i}/"
		doins -r "../openxcom/${i}/Language/"
	done
#	insinto "${GAMES_DATADIR}/${PN}/standard/xcom1/Language/"
#	doins -r "../openxcom/standard/xcom1/Language/"
#	insinto "${GAMES_DATADIR}/${PN}/standard/xcom2/Language/"
#	doins -r "../openxcom/standard/xcom2/Language/"

	doicon res/linux/icons/openxcom.svg
	domenu res/linux/openxcom.desktop

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "In order to play you need copy GEODATA, GEOGRAPH, MAPS, ROUTES, SOUND,"
	elog "TERRAIN, UFOGRAPH, UFOINTRO, UNITS folders from original X-COM game to"
	elog "${GAMES_DATADIR}/${PN}/data"
}
