# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit unpacker games multilib

DESCRIPTION="A fast paced 2d platformer, focused on intense action and exploration."
HOMEPAGE="http://www.capsizedgame.com/"
SRC_URI="${PN}-${PV}-bin"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="linguas_de linguas_es linguas_fr linguas_it"

RESTRICT="fetch"

DEPEND="app-arch/zip"
RDEPEND="
	${DEPEND}
	media-libs/libtheora
	media-libs/libogg
	media-libs/libvorbis
	dev-lang/mono
	media-libs/openal
	media-libs/libsdl2
	media-libs/sdl2-mixer
"
#	dev-dotnet/monogame # someday
#	dev-dotnet/monogame-theoraplay # someday
#	media-libs/theoraplay # someday

DOCS=( "Linux.README" )

S="${WORKDIR}/data"
GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

MY_PN=Capsized

pkg_nofetch() {
	einfo "Please download ${A}"
	einfo "from your personal page in Humble Indie Bundle site"
	einfo "(http://www.humblebundle.com)"
	einfo "and place it to ${DESTDIR}"
}

src_unpack() {
	unpack_zip "${A}"
}

src_install() {
	insinto "${GAMEDIR}"
	doins -r Content
	doins   "${MY_PN}.bmp" \
		NePlusUltra.exe \
		FarseerPhysicsXNA.dll \
		Lidgren.Network.dll \
		MonoGame.Framework.dll \
		ProjectMercury.dll \
		'SDL2#'.dll \
		'SDL2#'.dll.config \
		'TheoraPlay#'.dll \
		'TheoraPlay#'.dll.config

	for lang in fr it es de; do
		use "linguas_${lang}" && doins -r "${lang}"
	done

	# Installing bundled sdl-mixer-2, since it is still not released as 
	# tarball [hg only].
	# btw, can be inserted in ${GAMEDIR} without subdir.
	#
	# Also installing bundled theoraplay, since in is no such package in
	# portage.
	insinto "${GAMEDIR}/$(get_libdir)"
#	doins "$(get_libdir)/libSDL2_mixer-2.0.so.0"
	doins "$(get_libdir)/libtheoraplay.so"

	games_make_wrapper "${PN}" "mono ./NePlusUltra.exe" "${GAMEDIR}" "${GAMEDIR}/$(get_libdir)"
	doicon "${FILESDIR}/${PN}.png"
	make_desktop_entry "${PN}" "${MY_PN}" "${PN}"

	prepgamesdirs
}
