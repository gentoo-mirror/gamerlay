# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

EGIT_REPO_URI="https://github.com/thp/numptyphysics"

DESCRIPTION="A drawing puzzle game in the spirit of Crayon Physics"
HOMEPAGE="https://github.com/thp/numptyphysics"

KEYWORDS=""
LICENSE="GPL-3"
SLOT="0"

RDEPEND="media-libs/libsdl
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	x11-libs/libX11
	dev-libs/box2d
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -r \
		-e '/git describe/s@--tags@--always@' \
		-i makefile
	default
}
