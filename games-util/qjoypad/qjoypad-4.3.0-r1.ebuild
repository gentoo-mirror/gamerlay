# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils cmake-utils

DESCRIPTION="Translate gamepad/joystick input into key strokes/mouse actions in X"
HOMEPAGE="https://github.com/panzi/qjoypad"
SRC_URI="https://github.com/panzi/qjoypad/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	x11-libs/libXtst
	dev-qt/qtgui:5
"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/xextproto
	x11-proto/xproto
"

