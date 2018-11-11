# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="A Fuzzy Logic Control Library in C++"
HOMEPAGE="http://www.fuzzylite.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+c++11 static-libs"

S="${WORKDIR}/${P}/${PN}"

src_configure() {
	local mycmakeargs=(
		-DFL_BUILD_STATIC=$(usex static-libs)
		-DFL_USE_FLOAT=ON
		-DFL_BACKTRACE=ON
		-DFL_CPP11=$(usex c++11)
	)
	cmake-utils_src_configure
}

#pkg_postinst() {
#    games_pkg_postinst
#
#	elog For the game to work properly, please copy your 
#	elog \"Heroes Of Might and Magic: The Wake  Of Gods\" 
#	elog game directory into ${GAMES_DATADIR}/${PN} .
#	elog For more information, please visit:
#	elog http://wiki.vcmi.eu/index.php?title=Installation_on_Linux
#}
