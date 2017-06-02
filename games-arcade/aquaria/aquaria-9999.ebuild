# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EHG_REPO_URI="http://hg.icculus.org/icculus/aquaria"

inherit eutils flag-o-matic cmake-utils mercurial versionator

DESCRIPTION="A 2D scroller set in a massive ocean world"
HOMEPAGE="http://www.bit-blot.com/aquaria/"
SRC_URI="aquaria-lnx-humble-bundle.mojo.run"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="luajit"
RESTRICT="fetch"

RDEPEND="
	luajit? (
		dev-lang/luajit:2
	)
	!luajit? (
		|| (
			dev-lang/lua:5.1
			dev-lang/lua:0
		)
	)
	>=dev-libs/tinyxml-2.6.1-r1[stl]
	games-engines/bbge
	media-libs/glpng
	media-libs/libsdl
"

DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${PN}"

pkg_nofetch() {
	echo
	ewarn "Despite game code is open source, it still need artwork from original humblebundle package."
	ewarn "Please, download ${A} from ${HOMEPAGE} (or from your humble bundle library) and place it in ${DISTDIR}"
	echo
}

src_unpack() {
	# self unpacking zip archive; unzip warns about the exe stuff
	local a="${DISTDIR}/${A}"
	echo ">>> Unpacking ${a} to ${PWD}"
	unzip -q "${a}"
	[ $? -gt 1 ] && die "unpacking failed"

	mercurial_src_unpack
}

src_prepare() {
	local lua=lua
	use luajit && lua=luajit-5.1
	has_version 'dev-lang/lua:5.1' && lua=lua5.1

	# Fix include paths.
	sed -i \
		-e "s:\.\./ExternalLibs/glpng:GL/glpng:" \
		-e "s:\.\./ExternalLibs/::" \
		-e "s:\.\./BBGE/:BBGE/:" \
		Aquaria/*.{cpp,h} || die "Fix include patch failed"

	# Only build game sources.
	rm -r BBGE/ ExternalLibs/ || die "dropping bbge && ExternalLibs faled"
	sed -i "/ADD_EXECUTABLE[(]/,/[)]/d" CMakeLists.txt || die "dropping bbge && ExternalLibs faled"
	echo 'ADD_EXECUTABLE(aquaria ${AQUARIA_SRCS})' >> CMakeLists.txt || die "dropping bbge && ExternalLibs faled"

	# Redefine libraries to link against.
	sed -i "/TARGET_LINK_LIBRARIES/d" CMakeLists.txt || die
	echo "TARGET_LINK_LIBRARIES(aquaria BBGE glpng ${lua} pthread SDL tinyxml)" >> CMakeLists.txt || die

	default
}

src_configure() {
	local lua=lua

	use luajit && (
		local ljpk="$(best_version dev-lang/luajit:2)"
		local ljv="$(get_version_component_range 1-2 ${ljpk/*luajit-/})"
		append-cppflags -I/usr/include/luajit"${ljv}"
	)

	has_version 'dev-lang/lua:5.1' && append-cppflags -I/usr/include/lua5.1

	append-cppflags -I/usr/include/BBGE -I/usr/include/freetype2
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	cd ../data
	insinto /usr/share/Aquaria
	doins -r *.xml */
	doins -r "${S}"/game_scripts/*

	dodoc README-linux.txt
	dodoc -r docs/*

	doicon "${PN}.png"
	make_desktop_entry "${PN}" "Aquaria"
}
