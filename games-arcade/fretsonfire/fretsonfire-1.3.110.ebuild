# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

#PYTHON_DPEEND="2:2.4"
PYTHON_COMPAT=( python2_7 )

inherit base eutils distutils-r1 games

MY_PN="Frets on Fire"
MY_PN_URI="FretsOnFire"
DESCRIPTION="A game of musical skill and fast fingers"
HOMEPAGE="http://fretsonfire.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN_URI}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc guitarhero"

DEPEND=""
RDEPEND="dev-python/pygame
	>=dev-python/pyopengl-2.0.1.09-r1
	dev-python/numpy
	media-libs/sdl-mixer[vorbis]
	virtual/python-imaging
	doc? ( >=dev-python/epydoc-3.0.1 )
	guitarhero? ( media-sound/vorbis-tools )"

S=${WORKDIR}/${MY_PN}-${PV}

DOCS="readme.txt todo.txt"

src_prepare() {
	# change main game executable path
	sed \
		-e "s:\(FretsOnFire.py\):$(games_get_libdir)/${PN}/\1:" \
		-i src/FretsOnFire.py || die "patching src/FretsOnFire.py failed"

	# change data path
	sed \
		-e "s:os.path.join(\"..\", \"\(data\)\"):\"${GAMES_DATADIR}/${PN}/\1\":" \
		-i src/Version.py || die "patching src/Version.py failed"

	sed \
		-e 's/sdist:/dist:/' \
		-i Makefile

	sed -r \
		-e 's/^(PYTHON).*/\1=python2/' \
		-i 'data/Makefile'

	epatch "${FILESDIR}/${P}-PIL.patch"
#	distutils-r1_src_prepare;
}

src_compile() {
	python_setup;
	emake graphics translations killscores;

	if use doc; then
		epydoc --html -o "doc/html" -n "Frets on Fire" src/*.py src/midi/*.py \
			|| die "documentation generation failed"
	fi
}

src_install() {
    insinto "$(games_get_libdir)/${PN}"
    doins src/*.py src/*.pot || die "installation failed"

    insinto "$(games_get_libdir)/${PN}/midi"
    doins src/midi/*.py || die "installation failed"

    insinto "${GAMES_DATADIR}/${PN}"
    rm -fr data/win32 data/translations/*.po
    doins -r data || die "data installation failed"

	games_make_wrapper \
		${PN} "python2 FretsOnFire.py" "$(games_get_libdir)/${PN}" \
		|| die "games wrapper installation failed"
	if use doc; then
		dohtml -r doc/html/* || die "documentation installation failed"
	fi
	base_src_install_docs
	newicon data/icon.png ${PN}.png
	make_desktop_entry ${PN} "Frets on Fire"
	python_optimize "${D}$(games_get_libdir)/${PN}"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}

