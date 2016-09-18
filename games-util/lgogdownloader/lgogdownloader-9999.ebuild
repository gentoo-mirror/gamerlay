# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CMAKE_MIN_VERSION="3.0.0"

inherit cmake-utils git-r3

DESCRIPTION="Unofficial GOG.com downloader for Linux"
HOMEPAGE="https://sites.google.com/site/gogdownloader/"
EGIT_REPO_URI="https://github.com/Sude-/lgogdownloader.git"
LICENSE="WTFPL-2"
SLOT="0"
IUSE="+debug"

RDEPEND=">=app-crypt/rhash-1.3.3-r2:=
	dev-cpp/htmlcxx:=
	dev-libs/boost:=
	>=dev-libs/jsoncpp-1.7:=
	dev-libs/tinyxml2:=
	net-libs/liboauth:=
	>=net-misc/curl-7.32:=[ssl]"

DEPEND="${RDEPEND}
	sys-apps/help2man
	virtual/pkgconfig"
