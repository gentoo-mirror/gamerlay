# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils git-r3

DESCRIPTION="Linux compatible gog.com downloader"
HOMEPAGE="https://sites.google.com/site/gogdownloader/"
EGIT_REPO_URI="https://github.com/Sude-/lgogdownloader.git"

LICENSE="WTFPL"
SLOT="0"
KEYWORDS=""
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
