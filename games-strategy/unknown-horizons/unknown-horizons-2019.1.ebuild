# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_SINGLE_IMPL=1
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Anno-like real time strategy game"
HOMEPAGE="http://www.unknown-horizons.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/pyyaml
	dev-python/pillow
	>=games-engines/fifengine-0.4.2[python]
	>=games-engines/fifechan-0.1.5
	${PYTHON_DEPS}
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/greenlet
		dev-python/polib
		dev-python/isort
		dev-python/pylint
		dev-python/mock
		dev-python/nose
		dev-python/pycodestyle
	)
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_test() {
	${PYTHON} ./run_tests.py
}

src_compile() {
	distutils-r1_src_compile build_i18n
}

src_install() {
	distutils-r1_src_install
}
