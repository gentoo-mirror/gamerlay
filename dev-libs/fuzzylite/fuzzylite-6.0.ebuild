# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A Fuzzy Logic Control Library in C++"
HOMEPAGE="http://www.fuzzylite.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

S="${WORKDIR}/${P}/${PN}"

DOCS="../README.md"

src_configure() {
	local mycmakeargs=(
		-DFL_BUILD_STATIC=$(usex static-libs)
		-DFL_USE_FLOAT=ON
		-DFL_BACKTRACE=ON
		-DFL_BUILD_TESTS=OFF
	)
	cmake_src_configure
}
