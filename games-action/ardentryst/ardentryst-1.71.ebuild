# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1

MY_P=${P/-/}

DESCRIPTION="An action/RPG sidescoller, focused on story and character development."
HOMEPAGE="http://jordan.trudgett.com/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pygame[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_install() {
	insinto "/usr/share/${PN}"
	doins -r Base Data Demos Fonts Levels Music Sounds OPR.txt *.py *.dig *.xml || die "doins failed"
	python_optimize ${ED%/}/usr/share/${PN}
	make_wrapper ${PN} "${EPYTHON} ./ardentryst.py" "/usr/share/${PN}"
	newicon Data/icon.png ${PN}.png
	make_desktop_entry ${PN} Ardentryst
	dodoc help.txt || die
}
