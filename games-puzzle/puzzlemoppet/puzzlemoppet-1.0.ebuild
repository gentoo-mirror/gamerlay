# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_PN="PuzzleMoppet"

inherit cmake-utils

DESCRIPTION="a serenely peaceful yet devilishly challenging 3D puzzle game"
HOMEPAGE="http://garnetgames.com/puzzlemoppet"
SRC_URI="
	http://garnetgames.com/${MY_PN}Full.tar.gz
	http://garnetgames.com/${MY_PN}Source.tar.gz
	https://raw.githubusercontent.com/nothings/stb/e2caccb811d70af0dc359be5522e6b0d3b503e46/stb_vorbis.c -> ${PN}.stb_vorbis.c
"

LICENSE="WTFPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-games/ode
	dev-games/irrlicht
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/"${MY_PN}Source/Litha Engine"
DAT="${WORKDIR}"/"${MY_PN}FullVersion"

src_prepare() {
	cp "${DISTDIR}"/${PN}.stb_vorbis.c "${S}"/source/SoundSystems/OpenALSoundSystem/stb_vorbis.c
	eapply "${FILESDIR}"/${PN}-irrpatch.patch
	eapply "${FILESDIR}"/${PN}-irrhack.patch
	eapply "${FILESDIR}"/${PN}-cmake.patch
	eapply "${FILESDIR}"/${PN}-64bit.patch
	for i in `find projects/Puzzle -name *.cpp`; do sed -i "$i" -e "s:../projects:/usr/share/${PN}/projects:g"; done
	for i in `find projects/ConfigApp -name *.cpp`; do sed -i "$i" -e "s:../projects:/usr/share/${PN}/projects:g"; done
	sed -i -e "s:config:"${PN}-config":g" -i projects/ConfigApp/CMakeLists.txt
	default
}

src_install() {
	insinto "/usr/share/${PN}"
	doins -r "${DAT}/projects"

	dobin "bin/${PN}"
	dobin "bin/${PN}-config"

	newicon "${DAT}/icons/main.png" "${PN}.png"

	make_desktop_entry "${PN}" "${MY_PN}" "${PN}"
}
