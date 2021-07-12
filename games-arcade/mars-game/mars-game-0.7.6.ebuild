# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake prefix

MY_PN="marsshooter"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="M.A.R.S. a ridiculous shooter"
HOMEPAGE="http://mars-game.sourceforge.net"
SRC_URI="https://github.com/jwrdegoede/M.A.R.S./archive/${MY_P}.tar.gz"
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

S="${WORKDIR}/M.A.R.S.-${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}"-{GNUInstallDirs,glib}.patch
)

src_prepare() {
	cmake_src_prepare
	hprefixify src/System/settings.cpp
}

src_configure() {
	local mycmakeargs=(
		-Dmars_DATA_DEST_DIR="${EPREFIX}/usr/share/${MY_PN}"
		-Dmars_EXE_DEST_DIR="${EPREFIX}/usr/bin"
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
	)

	cmake_src_configure
}
