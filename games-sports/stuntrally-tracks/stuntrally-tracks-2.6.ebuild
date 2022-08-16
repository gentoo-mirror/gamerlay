# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A set of tracks for ${CATEGORY}/${P//-tracks}"
HOMEPAGE="http://stuntrally.tuxfamily.org/"

SLOT="0"
LICENSE="GPL-3"
IUSE=""

SRC_URI="https://github.com/stuntrally/tracks/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/tracks-${PV}"

src_configure() {
	local mycmakeargs+=(
		-DSHARE_INSTALL="/usr/share/stuntrally"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}
