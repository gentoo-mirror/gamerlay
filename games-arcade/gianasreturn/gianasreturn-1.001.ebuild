# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-arcade/gianasreturn-1.0.ebuild,v 1.0 2011/01/12 12:06:59 frostwork Exp $

EAPI="2"
inherit games

DESCRIPTION="Unofficial sequel of The Great Giana Sisters"
HOMEPAGE="http://www.gianas-return.de/"
SRC_URI="http://www.gianas-return.de/gr-v${PV/./}-ubuntu.zip"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip"
RDEPEND="media-libs/libsdl
	media-libs/sdl-mixer[flac,mad,mikmod,vorbis]
	sys-libs/zlib"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}

src_install() {
	if use amd64; then
		local bin=giana_ubuntu64
	fi
	if use x86; then
		local bin=giana_ubuntu32
	fi

	insinto "${dir}"
	doins -r data || die "doins failed"
	exeinto "${dir}"
	doexe "${bin}" || die "doexe failed"

	games_make_wrapper gianasreturn ./"${bin}" "${dir}" "${dir}"
	doicon giana.png
	make_desktop_entry gianasreturn "Giana's Return" giana
	dodoc {config,options,readme}.txt

	prepgamesdirs
}
