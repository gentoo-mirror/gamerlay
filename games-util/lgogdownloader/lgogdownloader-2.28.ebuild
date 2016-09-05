# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils

DESCRIPTION="Linux compatible gog.com downloader"
HOMEPAGE="https://sites.google.com/site/gogdownloader/"
SRC_URI="https://github.com/Sude-/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="WTFPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/jsoncpp
	net-libs/liboauth
	net-misc/curl
	dev-libs/boost
	dev-libs/tinyxml
	app-crypt/librhash
	net-libs/htmlcxx
"
DEPEND="${RDEPEND}"
