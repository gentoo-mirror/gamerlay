# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="The Legend of Edgar, 2d jump n run"
HOMEPAGE="http://www.parallelrealities.co.uk/projects/edgar.php"
SRC_URI="https://github.com/riksweeney/edgar/releases/download/${PV}/${P}-1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl2
	media-libs/sdl2-mixer
	media-libs/sdl2-image[png]
	media-libs/sdl2-ttf
	sys-libs/zlib:=
	"
DEPEND="${RDEPEND}"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		BIN_DIR="/usr/bin/" DATA_DIR="/usr/share/${PN}/" \
		|| die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" BIN_DIR="${D}/usr/bin/" \
		DATA_DIR="${D}/usr/share/${PN}/" DOC_DIR="${D}/usr/share/doc/${P}/" \
		APPDATA_DIR="${D}/usr/share/metainfo/" install \
		|| die "emake install failed"
}
