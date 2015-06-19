# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils games

DESCRIPTION="A design-based puzzle game from Zachtronics Industries."
HOMEPAGE="http://www.spacechemthegame.com/"

MY_PV="1.0.12"

SRC_URI="amd64? ( ${PN}-linux-1345144627-amd64.deb )
	x86? ( SpaceChem-i386.deb  )"

LICENSE="spacechem"
SLOT="0"
KEYWORDS="-* amd64 ~x86"
IUSE=""
RESTRICT="strip fetch"

RDEPEND="
	>=dev-lang/mono-2.10.3
	x11-misc/xclip
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image
	dev-db/sqlite:3
	amd64? (
		app-emulation/emul-linux-x86-sdl
	)
"

S="${WORKDIR}"


src_unpack() {
	unpack "${A}"
	cd "${S}"
	unpack "./data.tar.gz"
}

src_install() {
	GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${GAMEDIR}"
	exeinto "${GAMEDIR}"

	# install icon
	newicon opt/zachtronicsindustries/spacechem/icon.png ${PN}.png \
		|| die "install icon"

	# install docs
	dodoc opt/zachtronicsindustries/spacechem/readme/*

	# cleanup unneeded files
	rm opt/zachtronicsindustries/spacechem/*.{desktop,ico,png,sh}
	rm -rf opt/zachtronicsindustries/spacechem/readme

	# install game files
	doins -r opt/zachtronicsindustries/spacechem/* || die "doins opt"

	# install shortcuts
	games_make_wrapper "${PN}" "mono SpaceChem.exe" "${GAMEDIR}" "${GAMEDIR}" \
		|| die "install shortcut"
	make_desktop_entry "${PN}" "SpaceChem" "${PN}" "Game;LogicGame;" "Comment=Solve design-based challenges in this game from Zachtronics Industries"

	prepgamesdirs

	#cd "${S}/usr/share/man/man6"
	#doman spacechem.6.gz
}
