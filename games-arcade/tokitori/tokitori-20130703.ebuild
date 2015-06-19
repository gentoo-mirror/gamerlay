EAPI="5"

inherit base games unpacker-nixstaller

MY_PN="${PN^^t}"
TS="1372878397"
MY_P="${MY_PN}_${PV:0:4}-${PV:4:2}-${PV:6:2}_Linux_${TS}"

DESCRIPTION="Help a baby chicken save all the eggs."
HOMEPAGE="http://www.tokitori.com/"
SRC_URI="${MY_P}.sh"
RESTRICT="fetch"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	media-libs/libsdl2
	media-libs/openal
	sys-libs/zlib
"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

S="${WORKDIR}"

DOCS=( "README.linux" )

src_unpack() {
	local arch=x86
	use amd64 && arch=x86_64
	nixstaller_unpack "instarchive_all" "instarchive_all_${arch}"
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	local arch=x86
	use amd64 && arch=x86_64

	exeinto "${dir}"
	insinto "${dir}"

	make_desktop_entry "${PN}" "${MY_PN}" "${PN}"
	games_make_wrapper "${PN}" "./${PN}" "${dir}"

	newexe "${MY_PN}.bin.${arch}" "${PN}"
	newicon "${MY_PN}.png" "${PN}.png"

	doins -r \
		"namespace.txt" \
		"resourcecache.xml" \
		"audio" \
		"config" \
		"cursors" \
		"fx" \
		"animdata" \
		"credits" \
		"ending" \
		"input" \
		"localization" \
		"maps" \
		"menu" \
		"splash" \
		"textures"

	prepgamesdirs

	base_src_install_docs
}
