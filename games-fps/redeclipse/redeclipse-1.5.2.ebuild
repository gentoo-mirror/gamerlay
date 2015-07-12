# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games versionator

MAJOR_VERSION=$(get_version_component_range 1-2)

DESCRIPTION="First-person ego-shooter, built as a total conversion of Cube Engine 2"
HOMEPAGE="http://www.redeclipse.net/"
SRC_URI="http://www.indiedb.com/downloads/mirror/86141/100/0789359bfb023138a8c5520fcb632b7d -> ${PN}_${PV}_nix.tar.bz2"

# According to doc/license.txt file
LICENSE="HPND ZLIB CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated"

DEPEND="!dedicated? (
		media-libs/freetype:2
		media-libs/libsdl:0[opengl]
		media-libs/sdl-image:0[jpeg,png]
		media-libs/sdl-mixer:0[mp3,vorbis]
		virtual/opengl
		x11-libs/libX11
	)
	net-libs/enet:1.3
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	# Unbundle enet
	epatch "${FILESDIR}/${P}_unbundle-enet.patch"
	rm -r src/enet

	# Menu and mans
	sed -e "s:@APPNAME@:${PN}:" \
		-e "/^Keywords=/s/$/;/" \
		src/install/nix/redeclipse.desktop.am \
		> src/install/nix/redeclipse.desktop

	sed -e "s:@LIBEXECDIR@:$(games_get_libdir):g" \
		-e "s:@DATADIR@:${GAMES_DATADIR}:g" \
		-e "s:@DOCDIR@:${GAMES_DATADIR_BASE}/doc/${PF}:" \
		-e "s:@REDECLIPSE@:${PN}:g" \
		doc/man/redeclipse.6.am \
		> doc/man/redeclipse.6

	sed -e "s:@LIBEXECDIR@:$(games_get_libdir):g" \
		-e "s:@DATADIR@:${GAMES_DATADIR}:g" \
		-e "s:@DOCDIR@:${GAMES_DATADIR_BASE}/doc/${PF}:" \
		-e "s:@REDECLIPSE@:${PN}:g" \
		doc/man/redeclipse-server.6.am \
		> doc/man/redeclipse-server.6
}

src_compile() {
	if ! use dedicated ; then
		emake CXXFLAGS="${CXXFLAGS}" STRIP= -C src client server
	else
		emake CXXFLAGS="${CXXFLAGS}" STRIP= -C src server
	fi
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	insinto "${dir}"
	doins -r config data

	exeinto "${dir}"
	doexe src/redeclipse_server_linux
	if ! use dedicated ; then
		doexe src/redeclipse_linux
		newicon src/install/nix/${PN}_x128.png ${PN}.png
		domenu src/install/nix/redeclipse.desktop
		doman doc/man/redeclipse.6
	fi

	games_make_wrapper "${PN}" "${dir}/redeclipse_linux" "${dir}"
	games_make_wrapper "${PN}_server" "${dir}/redeclipse_server_linux" "${dir}"

	doman doc/man/redeclipse-server.6
	dodoc readme.txt doc/examples/servinit.cfg

	prepgamesdirs
}
