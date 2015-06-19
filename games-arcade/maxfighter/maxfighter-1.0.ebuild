# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils games

DESCRIPTION="Vertically-scrolling asteroids-style shoot-em-up"
HOMEPAGE="http://maxfighter.musgit.com/"
SRC_URI="http://source.musgit.com/files/${PN}_${PV}.tar.bz2"
LICENSE="CCPL-Attribution-ShareAlike-NonCommercial-2.5
	GPL-2"
KEYWORDS="~x86"
IUSE=""
SLOT="0"

RDEPEND="media-libs/mysdl"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}_${PV}
release=${S}/dist/linux/${PN}

src_compile() {
	scons dist=1 || die "scons failed"
}

src_install() {
	local dir=${GAMES_DATADIR}/${PN}
	local state_dir=${GAMES_STATEDIR}/${PN}

	dogamesbin "${release}/${PN}" || die "dogamesbin failed"

	insinto "${dir}"
	doins -r "${release}"/resources/* || die "doins resources failed"

	dohtml -r "${release}"/docs/* || die "dohtml docs failed"

	# Use a suitable icon from the many images available
	newicon "${release}"/resources/images/player_1_0006.png ${PN}.png \
		|| die "newicon failed"
	make_desktop_entry ${PN} "Max Fighter" ${PN}.png

	# Shared highscores file
	dodir "${state_dir}"
	touch "${D}/${state_dir}"/highscores.xml || die "touch failed"
	fperms g+w "${state_dir}"/highscores.xml || die "fperms failed"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

}