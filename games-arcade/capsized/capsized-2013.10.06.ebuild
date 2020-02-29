# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils multilib-minimal unpacker

MY_PN=Capsized

DESCRIPTION="A fast paced 2d platformer, focused on intense action and exploration."
HOMEPAGE="http://www.capsizedgame.com/"
SRC_URI="${PN}-$(ver_cut 3)$(ver_cut 2)$(ver_cut 1)-bin"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="l10n_de l10n_es l10n_fr l10n_it"

RESTRICT="fetch"

DEPEND="app-arch/zip"
RDEPEND="
	media-libs/libtheora[${MULTILIB_USEDEP}]
	media-libs/libogg[${MULTILIB_USEDEP}]
	media-libs/libvorbis[${MULTILIB_USEDEP}]
	dev-lang/mono[${MULTILIB_USEDEP}]
	media-libs/openal[${MULTILIB_USEDEP}]
	media-libs/libsdl2[${MULTILIB_USEDEP}]
	media-libs/sdl2-mixer[${MULTILIB_USEDEP}]
"
#	dev-dotnet/monogame # someday
#	dev-dotnet/monogame-theoraplay # someday
#	media-libs/theoraplay # someday

DOCS=( "Linux.README" )

S="${WORKDIR}/data"

pkg_nofetch() {
	einfo "Please download ${A}"
	einfo "from your personal page in Humble Indie Bundle site"
	einfo "(http://www.humblebundle.com)"
	einfo "and place it to ${DESTDIR}"
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	local dir="/opt/${PN}"
	insinto "${dir}"
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
		use "l10n_${lang}" && doins -r "${lang}"
	done

	# Installing bundled theoraplay, since in is no such package in portage.
	insinto "${dir}/$(get_libdir)"
	doins "$(get_libdir)/libtheoraplay.so"

	make_wrapper "${PN}" "mono ./NePlusUltra.exe" "${dir}" "${dir}/$(get_libdir)"
	doicon "${FILESDIR}/${PN}.png"
	make_desktop_entry "${PN}" "${MY_PN}" "${PN}"
}
