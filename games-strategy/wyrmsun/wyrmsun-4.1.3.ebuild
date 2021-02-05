# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Strategy game based on history, mythology and fiction"
HOMEPAGE="https://andrettin.github.io/"
SRC_URI="https://github.com/Andrettin/Wyrmsun/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="games-engines/wyrmgus"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Wyrmsun-${PV}"

src_prepare() {
	cmake_src_prepare
	sed -i -e 's:share/appdata:share/metainfo:g' CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		-DDOCSDIR="share/doc/${PF}"
	)
	cmake_src_configure
}

#src_install() {
#	cmake_src_install
#}
