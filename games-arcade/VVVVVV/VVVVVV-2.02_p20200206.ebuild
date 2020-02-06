# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake desktop git-r3

DESCRIPTION="Retro-styled open-world 2D puzzle platformer"
HOMEPAGE="https://thelettervsixtim.es/"

EGIT_REPO_URI="https://github.com/TerryCavanagh/VVVVVV"
EGIT_COMMIT="4e378b6057cca8e994b5b3049ff8b0cdadf1ebd9"

SRC_URI="https://thelettervsixtim.es/makeandplay/data.zip -> ${PN}-data.zip"

RESTRICT="mirror"
LICENSE="VVVVVV-License-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl2
	media-libs/sdl2-mixer"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}/desktop_version"

src_install() {
	exeinto /opt/${PN}
	doexe "${BUILD_DIR}/${PN}"
	insinto /opt/${PN}
	newins "${DISTDIR}/${PN}-data.zip" data.zip
	make_wrapper "${PN}" "./${PN}" "/opt/${PN}"
	dodoc README.md
}
