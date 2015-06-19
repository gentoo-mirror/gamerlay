# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2"

inherit subversion python

DESCRIPTION="Flexible Isometric Free Engine"
HOMEPAGE="http://fifengine.de/"

ESVN_REPO_URI="http://fife.svn.cvsdude.com/engine/trunk"

LICENSE="LGPL-2"

SLOT="0"
IUSE="debug profile"

RDEPEND="dev-libs/boost
	dev-python/pyyaml
	media-libs/libsdl
	media-libs/sdl-ttf
	media-libs/sdl-image[png]
	media-libs/libvorbis
	media-libs/libogg
	media-libs/openal
	sys-libs/zlib
	x11-libs/libXcursor
	virtual/opengl
	virtual/glu
	dev-games/guichan[sdl,opengl]
	media-libs/libpng
	x11-libs/libXext
"

DEPEND="${RDEPEND}
	dev-util/scons
	dev-lang/swig
"

src_prepare() {
	#remove bundled libs
	rm -r ext
	epatch "${FILESDIR}/${PN}-0.3.1-unbundle-libpng.patch"
}

# Compiles only with one thread
SCONSOPTS="-j1"

src_compile() {
	local SCONS_ARGS=""
	if use debug; then
		SCONS_ARGS="$SCONS_ARGS --enable-debug"
	fi

	if use profile; then
		SCONS_ARGS="$SCONS_ARGS --enable-profile"
	fi

	scons --python-prefix="${D}"/$(python_get_sitedir) --prefix="${D}"/usr "$SCONS_ARGS"
}

src_install() {
	scons install-python --python-prefix="${D}/$(python_get_sitedir)" --prefix="${D}/usr" || die 'install failed'
}
