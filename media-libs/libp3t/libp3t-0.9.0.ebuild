# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
#

EAPI=2
inherit cmake-utils

DESCRIPTION="A library to extract ps3 xmb p3t themes"
HOMEPAGE="http://frostworx.de/"
SRC_URI="http://frostworx.de/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

RDEPEND="media-libs/libpng"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use debug DEBUG)
	)
	cmake-utils_src_configure
}
