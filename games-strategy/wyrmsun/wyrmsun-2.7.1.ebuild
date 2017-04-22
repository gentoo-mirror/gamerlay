# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils

DESCRIPTION="Strategy game based on history, mythology and fiction"
HOMEPAGE="https://andrettin.github.io/"
SRC_URI="https://github.com/Andrettin/Wyrmsun/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="games-engines/wyrmgus"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN/w/W}-${PV}"

src_install() {
	domenu "linux/${PN}.desktop"
	newicon -s 128 graphics/ui/icons/wyrmsun_icon_128_background.png wyrmsun.png

	insinto "/usr/share/${PN}/"
	doins -r graphics maps music scripts sounds translations oaml.defs
	dodoc license.txt readme.txt
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
