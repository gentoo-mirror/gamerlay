# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )
inherit eutils versionator distutils-r1

DESCRIPTION="MCEdit, Minecraft World Editor"
HOMEPAGE="https://github.com/mcedit/mcedit"
MY_PVP="$(get_version_component_range 4)"
MY_PV="$(get_version_component_range 1-3)build${MY_PVP#p}"

SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/pyopengl-3.0.2
	dev-python/pygame
	dev-python/pyyaml
	dev-python/numpy
	"
S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	sed \
		-e '/from\ esky import/d' \
		-i "${S}/setup.py"
}
