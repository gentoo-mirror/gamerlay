# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
AUTOTOOLS_AUTORECONF=1
EGIT_REPO_URI="git://git.xonotic.org/xonotic/d0_blind_id.git"

inherit autotools-utils
[[ ${PV} == *9999* ]] && inherit git-2

DESCRIPTION="Blind-ID library for user identification using RSA blind signatures"
HOMEPAGE="http://git.xonotic.org/?p=xonotic/d0_blind_id.git;a=summary"
[[ ${PV} == *9999* ]] || \
SRC_URI="mirror://github/divVerent/d0_blind_id/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="dev-libs/gmp"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( d0_blind_id.txt )

src_configure() {
	local myeconfargs=(
		--enable-rijndael
		--without-openssl
		--without-tommath
	)
	autotools-utils_src_configure
}
