# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A Fuzzy Logic Control Library in C++"
HOMEPAGE="https://www.fuzzylite.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

S="${WORKDIR}/${P}/${PN}"

DOCS="../README.md"

PATCHES=( "${FILESDIR}"/0000-add-gcc11-12-suppor.patch )

src_configure() {
	local mycmakeargs=(
		-DFL_BUILD_STATIC=$(usex static-libs)
		-DFL_USE_FLOAT=OFF # https://bugs.gentoo.org/905664#c1
		-DFL_BACKTRACE=ON
		-DFL_BUILD_TESTS=OFF
		-DCMAKE_CXX_FLAGS="-Wno-error"
	)
	cmake_src_configure
}
