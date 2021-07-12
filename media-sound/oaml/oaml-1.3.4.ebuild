# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Open Adaptive Music Library"
HOMEPAGE="https://oamldev.github.io"
SRC_URI="https://github.com/oamldev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ogg soxr static-libs"

DEPEND="
	ogg? (
			media-libs/libogg[static-libs?]
			media-libs/libvorbis[static-libs?]
		)
	soxr? ( media-libs/soxr )
	media-libs/alsa-lib
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATIC=$(usex static-libs)
		-DENABLE_OGG=$(usex ogg)
		-DENABLE_SOXR=$(usex soxr)
	)
	cmake_src_configure
}
