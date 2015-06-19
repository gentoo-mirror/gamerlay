# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games

DESCRIPTION="Super Mario War is a Super Mario multiplayer game."
HOMEPAGE="http://smw.72dpiarmy.com"
SRC_URI="http://www.fileden.com/files/2007/9/11/1425938/${PN}-${PV}-src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="editor"

RDEPEND="media-libs/sdl-mixer
	media-libs/sdl-image"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}${PV}"

src_prepare(){
	epatch "${FILESDIR}"/${P}-gcc43.patch
	epatch "${FILESDIR}"/${P}-makefile.patch
	chmod +x configure
	dos2unix configure
	sed -s \
	-e 's/\-lSDL_mixer/-lSDL_mixer -lpng/g' -i configure \
	-e 's/\/usr\/share/${GAMES_DATADIR}/g' -i configure \
	-e 's/$(DESTDIR)\/usr\/share\/smw/${GAMES_DATADIR}/g' -i Makefile \
	|| die "sed failed"
}

src_configure() {
	econf || die "Configuration failed!"
}

src_compile() {

	emake smw || die "Make failed!"
	if use editor; then
	emake leveledit || die "Make editor failed!"
	fi
}

src_install() {
	dogamesbin ${PN}
	if use editor; then
	mv leveledit ${PN}-leveledit
	dogamesbin ${PN}-leveledit
	fi
	local datadir="${GAMES_DATADIR}"/"${PN}"
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/"${PN}"
	doins -r sfx gfx music maps tours || die
	make_desktop_entry "${PN}" "${PN}"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
