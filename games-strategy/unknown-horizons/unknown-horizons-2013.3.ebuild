# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_DEPEND="2:2.7"
RESTRICT_PYTHON_ABIS="3.*"

PYTHON_USE_WITH="sqlite"

inherit python games distutils

DESCRIPTION="Anno-like real time strategy game"
HOMEPAGE="http://www.unknown-horizons.org/"
SRC_URI="http://github.com/unknown-horizons/unknown-horizons/archive/${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="dev-python/pyyaml
	dev-python/bsddb3
	>=games-engines/fife-0.3.5"

RDEPEND="$DEPEND"

#S="${WORKDIR}"/${PN}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	games_pkg_setup
}

src_compile() {
	distutils_src_compile build_i18n
}

src_prepare() {
	# make sure version two is started for startup scripts
	python_convert_shebangs -r 2 .
}

src_install() {
	distutils_src_install
	# fix install paths to Gentoo specific locations
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r content || die "doins failed"
	rm -rf "${D}/usr/share/${PN}/content"
	dogamesbin "${D}/usr/bin/${PN}" || die "dogamesbin failed"
	rm -rf "${D}/usr/bin/"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	distutils_pkg_postinst
}
