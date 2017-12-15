# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="An open-source reimplementation of the popular UFO: Enemy Unknown"
HOMEPAGE="http://openxcom.org/"
# For translation files
#SRC_URI="http://openxcom.org/git_builds/openxcom_git_master_2015_09_25_2120.zip"
EGIT_REPO_URI="https://github.com/SupSuper/OpenXcom.git"
EGIT_COMMIT=19efea3da04465ddc4d61a3a6aae25d0eff105a3

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

src_configure() {
	mycmakeargs=(
		"-DCMAKE_INSTALL_BINDIR=/usr/bin"
		"-DCMAKE_INSTALL_DATADIR=/usr/share"
	)
	cmake-utils_src_configure
}

src_compile() {
	use doc && cmake-utils_src_compile doxygen
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc -r "${CMAKE_BUILD_DIR}/docs/html/"

#	for i in "common" "standard/xcom1" "standard/xcom2" ; do
#		insinto "${GAMES_DATADIR}/${PN}/${i}/"
#		doins -r "../openxcom/${i}/Language/"
#	done
#	insinto "${GAMES_DATADIR}/${PN}/standard/xcom1/Language/"
#	doins -r "../openxcom/standard/xcom1/Language/"
#	insinto "${GAMES_DATADIR}/${PN}/standard/xcom2/Language/"
#	doins -r "../openxcom/standard/xcom2/Language/"

	doicon res/linux/icons/openxcom.svg
	domenu res/linux/openxcom.desktop

}

pkg_postinst() {
	elog "In order to play you need copy UFO or TFTD game data"
	elog "(GEODATA, GEOGRAPH, MAPS, ROUTES, SOUND, TERRAIN, UFOGRAPH,"
	elog "UFOINTRO, UNITS folders) to"
	elog "/usr/share/${PN}/UFO or /usr/share/${PN}/TFTD respectively."
}
