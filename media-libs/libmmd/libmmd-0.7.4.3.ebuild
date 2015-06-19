# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#

EAPI=2
inherit cmake-utils

DESCRIPTION="a renderlib for mikumiku dance pmd model and vmd motion files"
HOMEPAGE="http://frostworx.de/"
SRC_URI="http://frostworx.de/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+bullet debug +sfml"

RDEPEND="bullet? ( sci-physics/bullet[-double-precision] )
	sfml? ( media-libs/libsfml )"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use debug DEBUG)
		$(cmake-utils_use !sfml NOSFML)
		$(cmake-utils_use bullet WANTBULLET)
	)
	cmake-utils_src_configure
}
