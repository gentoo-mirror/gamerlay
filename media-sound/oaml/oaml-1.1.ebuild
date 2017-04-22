# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Open Adaptive Music Library"
HOMEPAGE="https://oamldev.github.io"
SRC_URI="https://github.com/oamldev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ogg static-libs"

DEPEND="
	ogg? (
		static-libs? (
			media-libs/libogg[static-libs]
			media-libs/libvorbis[static-libs]
		)
		!static-libs? (
			media-libs/libogg
			media-libs/libvorbis
		)
	)
	media-libs/alsa-lib
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATIC=$(usex static-libs)
		-DENABLE_OGG=$(usex ogg)
	)
	cmake-utils_src_configure
}
