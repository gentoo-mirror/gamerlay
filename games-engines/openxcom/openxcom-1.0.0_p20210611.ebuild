# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="An open-source reimplementation of the popular UFO: Enemy Unknown"
HOMEPAGE="http://openxcom.org/"
# For translation files
#SRC_URI="http://openxcom.org/git_builds/openxcom_git_master_2015_09_25_2120.zip"
EGIT_REPO_URI="https://github.com/SupSuper/OpenXcom.git"
EGIT_COMMIT=8d45159bf3e27d6aef62aff6035d9f6a59caf00b

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND=">=dev-cpp/yaml-cpp-0.5.3
	media-libs/libsdl
	media-libs/sdl-gfx
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-sound/timidity++"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

#S="${WORKDIR}/OpenXcom"

DOCS=( README.md )

src_prepare() {
	default
	sed -i -e "s:/man/man6:/share/man/man6:g" docs/CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		"-DCMAKE_INSTALL_BINDIR=/usr/bin"
		"-DCMAKE_INSTALL_DATADIR=/usr/share"
	)
	cmake_src_configure
}

src_compile() {
	use doc && cmake_src_compile doxygen
	cmake_src_compile
}

src_install() {
	cmake_src_install
	use doc && dodoc -r "${CMAKE_BUILD_DIR}/docs/html/"

#	for i in "common" "standard/xcom1" "standard/xcom2" ; do
#		insinto "${GAMES_DATADIR}/${PN}/${i}/"
#		doins -r "../openxcom/${i}/Language/"
#	done
#	insinto "${GAMES_DATADIR}/${PN}/standard/xcom1/Language/"
#	doins -r "../openxcom/standard/xcom1/Language/"
#	insinto "${GAMES_DATADIR}/${PN}/standard/xcom2/Language/"
#	doins -r "../openxcom/standard/xcom2/Language/"
}

pkg_postinst() {
	elog "In order to play you need copy UFO or TFTD game data"
	elog "(GEODATA, GEOGRAPH, MAPS, ROUTES, SOUND, TERRAIN, UFOGRAPH,"
	elog "UFOINTRO, UNITS folders) to"
	elog "/usr/share/${PN}/UFO or /usr/share/${PN}/TFTD respectively."
}
