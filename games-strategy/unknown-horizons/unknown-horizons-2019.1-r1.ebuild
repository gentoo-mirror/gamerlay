# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_SINGLE_IMPL=1
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Anno-like real time strategy game"
HOMEPAGE="https://www.unknown-horizons.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

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

PATCHES=(
	"${FILESDIR}/python-3.8.patch"
	"${FILESDIR}/util_preloader.patch"
	"${FILESDIR}/json_decoder.patch"
	"${FILESDIR}/unitmanager.patch"
)

src_test() {
	${PYTHON} ./run_tests.py
}

src_compile() {
	distutils-r1_src_compile build_i18n
	chmod +x horizons/engine/generate_atlases.py
	horizons/engine/generate_atlases.py 2048
}

src_install() {
	distutils-r1_src_install
	insinto "/usr/share/unknown-horizons/content"
	doins "content/atlas.sql"
}
