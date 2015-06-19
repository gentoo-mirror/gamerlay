# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cdrom eutils games

DESCRIPTION="Data files for Descent 2: The Vertigo Series"
HOMEPAGE="http://www.interplay.com/games/support.php?id=103"
SRC_URI=""

# See readme.txt
LICENSE="${PN}"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc videos"

RDEPEND=""
DEPEND=""

S=${WORKDIR}
dir=${GAMES_DATADIR}/d2x

# Function to handle copying and renaming files from installation directory
copy_file() {
	local dest="${2}"
	local f=$(basename "${1}")
	if [ "${f:0:1}" == '*' -o ! -f "${1}" ]; then
		return 0
	else
		echo "Copying '${f}'"
		local d=$(echo ${f} | tr "[:upper:]" "[:lower:]")
		cp -f "${1}" "${dest}/${d}" || die "copy ${1} failed"
		return 0
	fi
}

pkg_setup() {
	games_pkg_setup

	# The Descent 2 CD, or an existing install (eg., for GOG), is needed
	CDROM_NAME_SET=( "CD-ROM Version" "CD-ROM" )
	cdrom_get_cds vertigo/d2x.hog:VERTIGO/D2X.HOG
	case ${CDROM_SET} in
		[01]) F_SOURCE='cd'
			F_ROOT="${CDROM_ROOT}/vertigo"
			einfo 'Found Descent II Vertigo Series CD' ;;
		*) die "Vertigo Series CD or files not found" ;;
	esac
}

src_unpack() {
	mkdir "${WORKDIR}/missions" || die "mkdir missions failed"

	# Copy index files
	for i in "${F_ROOT}"/{{hoard.ham,HOARD.HAM},*.{txt,TXT}}; do
		copy_file "$i" "${WORKDIR}"
	done

	# Copy mission files
	for i in "${F_ROOT}"/{d2x,D2X}.{hog,HOG,mn2,MN2}; do
		copy_file "$i" "${WORKDIR}/missions"
	done

	# Copy optional mission files
	for i in "${F_ROOT}"/{missions,MISSIONS}/*; do
		copy_file "$i" "${WORKDIR}/missions"
	done

	# Also copy video files if desired
	if use videos; then
		# Require high resolution movie files
		for i in "${F_ROOT}"/*-{h.mvl,H.MVL}; do
			copy_file "$i" "${WORKDIR}"
		done
		if [ ! -f "${WORKDIR}/d2x-h.mvl" ] ; then
			die "videos not found"
		fi

		# Also copy low resolution movie files (not available from GOG)
		# Would anyone really want low-res videos at this point? Probably not.
		#for i in "${F_ROOT}"/*-{l.mvl,L.MVL}; do
		#	copy_file "$i" "${WORKDIR}"
		#done
	fi

	mkdir doc || die "mkdir doc failed"
	mv *.txt doc/ # ignore fail
}

src_install() {
	insinto "${dir}"
	doins *

	insinto "${dir}/missions"
	doins missions/*

	if use doc; then
		dodoc doc/*.txt
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "A client is needed to run the game, e.g. games-action/d2x-rebirth."
	echo
}
