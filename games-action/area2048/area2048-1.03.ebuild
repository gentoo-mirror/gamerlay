# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit d-games

MY_PN=a2k
MY_PV=${PV//./_}

DESCRIPTION="jumpei isshiki's HelloWorldProject (2005/01/17) "
HOMEPAGE="https://sourceforge.net/projects/area2048/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-linux.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer
	dev-libs/libbulletml"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

src_unpack(){
	cd "${WORKDIR}"
	unpack ${MY_PN}.zip
	cd "${S}"
	unpack ${MY_PN}_src.zip

}

src_prepare(){
	epatch "${FILESDIR}"/${P}-import.patch
	epatch "${FILESDIR}"/${P}-src.patch
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-homedir.patch
	sed -i \
	-e 's:"\(icon.bmp[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a2k_src/src/util_pad.d \
	-e 's:"\(title.bmp[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a2k_src/src/init.d \
	-e 's:"\(stg0[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a2k_src/src/init.d \
	-e 's:"\(boss0[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a2k_src/src/init.d \
	-e 's:"\(se_[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a2k_src/src/init.d \
	-e 's:"\(voice[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a2k_src/src/init.d \
	-e 's:"\(bullet[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a2k_src/src/init.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN} || die "dogamesbin failed"

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins *.xml *.bmp *.ogg *.wav || die
	newicon "${FILESDIR}"/${PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
