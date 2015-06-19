# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils games subversion

DESCRIPTION="Zelda Mystery of Solarus DX"
HOMEPAGE="http://www.zelda-solarus.com"
ESVN_REPO_URI="svn://svn.solarus-engine.org/solarus/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug luajit"

DEPEND="media-libs/sdl-image[png]
	media-libs/sdl-ttf
	media-libs/openal
	|| ( =dev-lang/lua-5.1* dev-lang/luajit:2 )
	luajit? ( dev-lang/luajit )
	media-libs/libsndfile
	dev-games/physfs[zip]"
RDEPEND="${DEPEND}
	app-arch/zip"

src_prepare() {
	use luajit && {
		cp "${FILESDIR}/FindLuaJIT.cmake" "${S}/cmake/modules/" || die "copying failed"
		sed \
			-e "s#Lua51#LuaJIT#" \
			-i "${S}/src/CMakeLists.txt" || die "luajit sed failed"
		sed -r \
			-e 's#(COMMAND) (luac -o) (\$\{CMAKE_CURRENT_BINARY_DIR\}/\$\{lua_source_file\}c) (\$\{lua_source_file\})#\1 luajit -b \4 \3#' \
			-i "${S}/quests/zsdx/data/CMakeLists.txt"
	}
	sed \
		-e "s#-pedantic -Wall -Werror#-Wno-error -fpermissive#" \
		-i "${S}/src/CMakeLists.txt" || die "compilation fix sed failed"
	sed \
		-e "s%#%%g" \
		-i "${S}/quests/zsdx/data/languages/languages.dat"
}

src_configure() {
	mycmakeargs="${mycmakeargs} -DDATAPATH=${GAMES_DATADIR}/${PN}"

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	dogamesbin "${WORKDIR}/${P}_build/src/${PN}" || die "dobin failed"

	local datadir="${GAMES_DATADIR}"/"${PN}"
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/"${PN}"
	doins "${WORKDIR}/${P}_build/quests/zsdx/data/data.${PN}" || die "doins failed"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
