# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=$(ver_rs 3 -)

DESCRIPTION="Gamepacks for NetRadiant editor"
HOMEPAGE="https://netradiant.gitlab.io/"
SRC_URI="https://dl.illwieckz.net/b/netradiant/build/preversions/netradiant_${MY_PV}-illwieckz-linux-amd64.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/netradiant_${MY_PV}-illwieckz-linux-amd64"

src_install() {
	insinto /usr/share/netradiant/gamepacks
	doins -r gamepacks/*
}
