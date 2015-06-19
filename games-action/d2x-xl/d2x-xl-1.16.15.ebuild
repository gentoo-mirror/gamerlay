# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils flag-o-matic toolchain-funcs games

SRC_D2X="http://www.descent2.de/files"
SRC_FILE="${PN}-src-${PV}.7z"
DATA_FILE="${PN}-data-1.15.295.7z"

DESCRIPTION="Descent 2 engine supporting high-resolution textures"
HOMEPAGE="http://www.descent2.de/"

D1_TEXTURES="ceilings doors fans-grates lava lights metal rock signs special switches"
D2_TEXTURES="ceilings doors fans-grates lava-water lights metal rock signs special switches"
TEXTURES_SRC_URI=""

for X in ${D1_TEXTURES}; do
	TEXTURES_SRC_URI="${TEXTURES_SRC_URI} ${SRC_D2X}/textures/D1-hires-${X}.7z";
done
for X in ${D2_TEXTURES}; do
	TEXTURES_SRC_URI="${TEXTURES_SRC_URI} ${SRC_D2X}/textures/D2-hires-${X}.7z";
done

# www.descent2.de must be *first* in the SRC_URI list, because
# all the SourceForge links exhaust Portage's retry patience.
SRC_URI="${SRC_D2X}/${SRC_FILE}
	${SRC_D2X}/${DATA_FILE}
	mirror://sourceforge/${PN}/${SRC_FILE}
	mirror://sourceforge/${PN}/${DATA_FILE}
	models? ( ${SRC_D2X}/models/hires-models.7z )
	sounds? ( ${SRC_D2X}/sound/hires-sounds.7z )
	textures? ( ${TEXTURES_SRC_URI} )"

LICENSE="D1X"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="descent1 descent2 descent2-vertigo debug icon models openmp sounds textures"

CDEPEND="media-libs/glew
	>=media-libs/libsdl-1.2.8:0
	media-libs/sdl-image:0
	media-libs/sdl-mixer:0
	media-libs/sdl-net:0
	net-misc/curl
	virtual/opengl"

RDEPEND="${CDEPEND}
	descent1? ( games-action/descent1-data )
	descent2? ( games-action/descent2-data )
	descent2-vertigo? ( games-action/descent2-vertigo )"

DEPEND="${CDEPEND}
	app-arch/p7zip
	icon? ( media-gfx/icoutils )"

S="${WORKDIR}"
DIR="${GAMES_DATADIR}/${PN}"

RESTRICT=mirror

src_unpack() {
	unpack "${SRC_FILE}" "./${PN}-makefiles.7z"
}

src_prepare() {
	if use icon ; then
		icotool -x "${PN}.ico" || die "icotool failed"
	fi

	# Use our own data directory.
	sed -i "s:/usr/local/games/${PN}:${DIR}:g" main/{setup,gamefolders}.cpp || \
		die "sed #1 failed"

	# Don't need these libraries.
	sed -i -r "/d2x_sdl_LDADD/s/-l(Xm|Xt|X11)//g" Makefile.am || \
		die "sed #2 failed"

	# Strip C(XX)FLAGS.
	sed -i -r "/C(XX)?FLAGS/s/-(fopenmp|g|O[0-9])//g" configure.ac || \
		die "sed #3 failed"

	chmod a+x ./autogen.sh || die "chmod #1 failed"
	./autogen.sh || die "autogen.sh failed"
	chmod +x configure || die "chmod #2 failed"
	eautoreconf
}

src_configure() {
	if use openmp && tc-has-openmp; then
		append-cppflags -fopenmp
		export LIBS="${LIBS} -lgomp"
	fi

	local DEBUG_CONF="--disable-debug --enable-release"
	use debug && DEBUG_CONF="--enable-debug --disable-release"

	egamesconf ${DEBUG_CONF} --with-opengl
}

src_install() {
	use icon && newicon "${PN}_1_48x48x32.png" "${PN}.png"

	dogamesbin "${PN}"
	make_desktop_entry "${PN}" "D2X-XL" "${PN}"

	# Unpack D2X-XL data files.
	dodir "${DIR}"
	cd "${D}${DIR}" || die "cd \"${D}${DIR}\" failed"
	unpack "${DATA_FILE}"

	# Symlink original data files, which may or may not be present.

	if use descent1; then
		ln -s ../../d1x/descent.{hog,pig} data/ || die "ln #1 failed"
	fi

	if use descent2; then
		ln -s ../../d2x/descent2.{ham,hog,s11,s22} data/ || \
			die "ln #2 failed"
		ln -s ../../d2x/{groupa,alien{1,2},fire,ice,water}.pig data/ || \
			die "ln #3 failed"
	fi

	if use descent2-vertigo; then
		ln -s ../../d2x/hoard.ham data/ || die "ln #4 failed"
		mkdir missions || die "mdir missions failed"
		ln -s ../../d2x/missions/d2x.{hog,mn2} missions/ || die "ln #5 failed"
	fi

	# Optional data.
	use models && unpack hires-models.7z
	use sounds && unpack hires-sounds.7z

	if use textures; then
		for X in ${D1_TEXTURES}; do unpack "D1-hires-${X}.7z"; done
		for X in ${D2_TEXTURES}; do unpack "D2-hires-${X}.7z"; done

		# Make everything lower case.
		mv textures/D1 textures/d1 || die "mv #1 failed"
		mv sounds2/D1 sounds2/d1 || die "mv #2 failed"
		find -name "*[A-Z]*" -exec sh -c 'mv {} $(echo {} | tr A-Z a-z)' \; || \
			die "find -exec mv failed"
	fi

	prepgamesdirs
}
