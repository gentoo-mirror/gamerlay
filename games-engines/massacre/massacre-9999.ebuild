# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils git-2

DESCRIPTION="A crossplatform despair simulator engine"
HOMEPAGE="https://github.com/Dark-Confidant/Massacre"
EGIT_REPO_URI="git://github.com/Dark-Confidant/Massacre.git"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/Massacre

DEPEND="media-libs/glew
		=dev-cpp/yaml-cpp-0.3.0
		dev-libs/boost
		media-libs/libsdl
		media-libs/libpng
		media-libs/libjpeg-turbo
		sys-libs/zlib
		media-libs/freetype"

RDEPEND="${DEPEND}"
