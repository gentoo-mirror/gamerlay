# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=Box2D

CMAKE_MIN_VERSION=2.8
inherit cmake-utils eutils

DESCRIPTION="Box2D is an open source physics engine written primarily for games."
HOMEPAGE="http://www.box2d.org"
SRC_URI="https://github.com/erincatto/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs examples"

RDEPEND="
	media-libs/freeglut
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}/${MY_PN}"

usx() {
	usex "${1}" "ON" "OFF"
}
#nusx() {
#	usex "${1}" "OFF" "ON"
#}

src_configure() {
	local mycmakeargs=(
		-DBOX2D_BUILD_SHARED=ON # no-shared build?
		-DBOX2D_BUILD_STATIC=$(usx static-libs)
		-DBOX2D_INSTALL_DOC=$(usx doc)
# Broken:
#		-DBOX2D_BUILD_EXAMPLES=$(usx examples)
# So:
		-DBOX2D_BUILD_EXAMPLES=OFF
	)
	cmake-utils_src_configure
}
