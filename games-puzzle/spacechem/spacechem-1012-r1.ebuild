# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper multilib-minimal

DESCRIPTION="A design-based puzzle game from Zachtronics Industries."
HOMEPAGE="http://www.spacechemthegame.com/"

SRC_URI="amd64? ( ${PN}-linux-1345144627-amd64.deb )
	x86? ( SpaceChem-i386.deb )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip fetch"

RDEPEND="
	>=dev-lang/mono-2.10.3[${MULTILIB_USEDEP}]
	media-libs/libsdl[${MULTILIB_USEDEP}]
	media-libs/sdl-mixer[${MULTILIB_USEDEP}]
	media-libs/sdl-image[${MULTILIB_USEDEP}]
	dev-db/sqlite:3[${MULTILIB_USEDEP}]
"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack "./data.tar.gz"
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	exeinto "${dir}"

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
	make_wrapper "${PN}" "mono SpaceChem.exe" "${dir}" "${dir}" \
		|| die "install shortcut"
	make_desktop_entry "${PN}" "SpaceChem" "${PN}" "Game;LogicGame;" "Comment=Solve design-based challenges in this game from Zachtronics Industries"
}
