# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-multilib vcs-snapshot

DESCRIPTION="An OpenGL PNG image library"
HOMEPAGE="http://repo.or.cz/glpng.git"
SRC_URI="http://repo.or.cz/glpng.git/snapshot/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="static-libs"

RDEPEND="
	virtual/opengl[${MULTILIB_USEDEP}]
	virtual/glu[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
"
DEPEND=${RDEPEND}

src_configure() {
	local mycmakeargs=( -DBUILD_STATIC_LIBS=$(usex static-libs ON OFF) )
	cmake-multilib_src_configure
}
