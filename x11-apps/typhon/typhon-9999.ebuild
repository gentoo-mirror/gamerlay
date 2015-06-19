# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-apps/typhon-9999.ebuild,v 1.2 2014/06/22 09:08:23 by frostwork Exp $

EAPI="4"

CMAKE_MIN_VERSION=2.8

inherit cmake-utils eutils subversion

ESVN_REPO_URI="http://typhon-launcher.googlecode.com/svn/trunk/"

DESCRIPTION="A slim and themeable opengl dashboard / program launcher"
HOMEPAGE="https://code.google.com/p/typhon-launcher/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug mmd +p3t"

S="${WORKDIR}/${P/_/-}"

RDEPEND="virtual/opengl
	dev-libs/tinyxml
	media-libs/libpng
	>=media-libs/libsfml-2.0
	sys-libs/zlib
	mmd? ( media-libs/libmmd )
	p3t? ( media-libs/libp3t )"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use debug DEBUG)
		$(cmake-utils_use !mmd NOMMD)
	)

	cmake-utils_src_configure
}
