# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit wrapper cmake desktop git-r3

DESCRIPTION="Retro-styled open-world 2D puzzle platformer"
HOMEPAGE="https://thelettervsixtim.es/"

EGIT_REPO_URI="https://github.com/TerryCavanagh/VVVVVV"
EGIT_COMMIT="fb386681821d503b767c465d41d99126626c2789"
# TODO
# EGIT_SUBMODULES=( -third_party/{physfs,libxml2,FAudio} )

SRC_URI="https://thelettervsixtim.es/makeandplay/data.zip -> ${PF}-data.zip"

RESTRICT="mirror"
LICENSE="VVVVVV-License-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl2
	media-libs/sdl2-mixer
"
#	dev-libs/tinyxml2
#	app-emulation/faudio
#	dev-games/physfs
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}/desktop_version"

src_install() {
	exeinto /opt/"${PN}"
	doexe "${BUILD_DIR}/${PN}"
	insinto /opt/"${PN}"
	newins "${DISTDIR}/${PF}-data.zip" data.zip
	make_wrapper "${PN}" "./${PN}" "/opt/${PN}"
	dodoc README.md
}
