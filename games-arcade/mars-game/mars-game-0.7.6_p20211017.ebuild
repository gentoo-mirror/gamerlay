# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake prefix

MY_PN="marsshooter"
MY_P="${MY_PN}-${PV}"

COMMIT="84664cda094efe6e49d9b1550e4f4f98c33eefa2"

DESCRIPTION="M.A.R.S. a ridiculous shooter"
HOMEPAGE="http://mars-game.sourceforge.net"
SRC_URI="https://github.com/thelaui/M.A.R.S./archive/${COMMIT}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	dev-libs/fribidi
	media-libs/libsfml:=
	media-libs/taglib
	virtual/opengl
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/M.A.R.S.-${COMMIT}"

src_prepare() {
	cmake_src_prepare
	hprefixify src/System/settings.cpp

	sed -i -e 's|${CMAKE_INSTALL_FULL_DATAROOTDIR}/appdata|${CMAKE_INSTALL_FULL_DATAROOTDIR}/metainfo|g' \
		src/CMakeLists.txt || die

}

src_configure() {
	local mycmakeargs=(
		-Dmars_DATA_DEST_DIR="${EPREFIX}/usr/share/${MY_PN}"
		-Dmars_EXE_DEST_DIR="${EPREFIX}/usr/bin"
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
	)

	cmake_src_configure
}
