# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
EGIT_REPO_URI="git://github.com/graphitemaster/gmqcc.git"

inherit toolchain-funcs
[[ ${PV} == *9999* ]] && inherit git-2

DESCRIPTION="An Improved Quake C Compiler"
HOMEPAGE="http://graphitemaster.github.com/gmqcc/"
[[ ${PV} == *9999* ]] || \
SRC_URI="https://github.com/graphitemaster/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	# fixed in git master
	sed -i -e "s:-Werror ::" Makefile || die
}

src_configure() {
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dodoc README AUTHORS TODO CHANGES
}
