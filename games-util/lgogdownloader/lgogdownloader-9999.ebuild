# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: lgogdownloader-9999.ebuild,v 1.0 2013/04/28 15:06:41 by frostwork Exp $

EAPI="4"

inherit eutils git-2

DESCRIPTION="Linux compatible gog.com downloader"
HOMEPAGE="https://sites.google.com/site/gogdownloader/"
EGIT_REPO_URI="git://github.com/Sude-/lgogdownloader.git"

LICENSE="WTFPL"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/jsoncpp
		net-libs/liboauth
		net-misc/curl
		dev-libs/boost
		dev-libs/tinyxml
		app-crypt/librhash
		net-libs/htmlcxx"
DEPEND="${RDEPEND}"

src_install() {
	dobin bin/Release/${PN}
}
