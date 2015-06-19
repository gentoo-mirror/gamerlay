# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-apps/briareos/briareos-0.7.ebuild,v 1.0 2010/09/01 09:33:12 by frostwork Exp $

EAPI="2"

inherit eutils

DESCRIPTION="A slim and transparent programlauncher - perfect for a hotkey."
HOMEPAGE="http://www.frostworx.de/"
SRC_URI="http://www.frostworx.de/briareos/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${P}"

RDEPEND="media-libs/ftgl
	virtual/opengl
	x11-libs/libXrender
	x11-libs/libXrandr
	media-fonts/liberation-fonts"
DEPEND="${RDEPEND}"

src_install() {
	dobin ${PN} || die "dobin failed"
}
