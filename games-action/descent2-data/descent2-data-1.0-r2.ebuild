# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

CDROM_OPTIONAL="yes"
inherit cdrom eutils games

# Not possible to apply official 1.2 patch under Linux, so provide our own
# http://www.interplay.com/support/support.php?id=104
# Should only be needed for original DOS CD-ROM release
MY_PATCH="http://www.dxx-rebirth.com/download/dxx/misc/d2xptch12.tgz"

# For GOG install
MY_EXE="setup_descent_1_2.exe"

DESCRIPTION="Data files for Descent 2"
HOMEPAGE="http://www.interplay.com/games/support.php?id=104"
SRC_URI="cdinstall? ( $MY_PATCH )
	!cdinstall? ( $MY_EXE )"

# See readme.txt
LICENSE="${PN}"
SLOT="0"
KEYWORDS="amd64 ppc x86"
RESTRICT="!cdinstall? ( fetch )"
IUSE="+cdinstall doc vertigo videos"

# d2x-0.2.5-r2 may include the CD data itself.
# d2x-0.2.5-r3 does not include the CD data.
# d2x-rebirth is favoured because it is stable.
#RDEPEND="|| (
#	games-action/d2x-rebirth
#	>=games-action/d2x-0.2.5-r3 )"
RDEPEND="!<games-action/d2x-0.2.5-r3"
DEPEND="app-arch/unarj
	vertigo? ( games-action/descent2-vertigo )
	cdinstall? (
		dev-util/xdelta:3
	)
	!cdinstall? (
		app-arch/innoextract
		app-arch/unzip
	)"

S=${WORKDIR}
dir=${GAMES_DATADIR}/d2x

# Function to handle copying and renaming files from installation directory
copy_file() {
	local dest="${2}"
	local f=$(basename "${1}")
	if [ "${f:0:1}" == '*' ]; then
		return 0
	else
		echo "Copying '${f}'"
		local d=$(echo ${f} | tr "[:upper:]" "[:lower:]")
		cp -f "${1}" "${dest}/${d}" || die "copy ${1} failed"
		return 0
	fi
}

pkg_nofetch() {
	elog "You must place a copy of, or symlink to, the GOG setup package here:"
	elog "${DISTDIR}/${MY_EXE}"
	echo
	elog "If you wish to install from CD-ROM instead, please enable the cdinstall flag"
}

pkg_setup() {
	games_pkg_setup
	local m need_cd="n"

	if use cdinstall; then
		# Check for supported CD-ROM or local install
		CDROM_NAME_SET=( "CD-ROM Version" "Installed Version" "Installed Version" )
		cdrom_get_cds d2data/descent2.sow:descent2.hog:DESCENT2.HOG
		case ${CDROM_SET} in
			0) F_SOURCE='cd'
				F_ROOT="${CDROM_ROOT}/d2data"
				einfo 'Found Descent II CD' ;;
			[12]) F_SOURCE='install'
				F_ROOT="${CDROM_ROOT}"
				einfo 'Found Descent II Installation' ;;
			*) die 'Descent II CD or installation files not found' ;;
		esac

	else
		# Check for GOG installer
		if [ ! -e "${DISTDIR}/${MY_EXE}" ]; then
			ewarn "You must copy or symlink '${MY_EXE}' to your distfiles directory"
			die "GOG installer not found"
			F_SOURCE='gog'
		fi
		F_ROOT="${WORKDIR}/gog/app/descent 2"
	fi
}

src_unpack() {
	mkdir "${WORKDIR}"/{demos,missions} || die "mkdir {demos,missions} failed"
	use cdinstall && unpack ${MY_PATCH}

	# Extract level data if installing from CD
	if [ "${F_SOURCE}" == "cd" ]; then
		unarj e "${F_ROOT}/descent2.sow" || die "unarj '${F_ROOT}/descent2.sow' failed"

		# Remove files not needed by any Linux native client
		rm -f *.{bat,dll,exe,ini,lst} endnote.txt # ignore fail

		# Move missions to appropriate directory
		mv d2-2plyr.{hog,mn2} d2chaos.{hog,mn2} missions/ || \
			die "move missions failed"

		# Move demos to appropriate directory
		mv *.dem demos/ || die "move demos failed"

	# Othwerwise, copy files if pulling from install source
	else
		# Extract files from GOG package if necessary
		if ! use cdinstall; then
			einfo "Unpacking ${MY_EXE}. This will take a while..."
			mkdir gog && cd gog || die "mkdir gog failed"
			innoextract -e -s -p1 -L "${DISTDIR}/${MY_EXE}" || die "innoextract failed"
			cd .. || die "cd .. failed"
		fi

		for i in "${F_ROOT}"/*.{ham,HAM,hog,HOG,pig,PIG,s11,S11,s22,S22,txt,TXT,pdf,PDF}; do
			copy_file "$i" "${WORKDIR}"
		done

		# Also copy optional missions and demos if available
		for i in "${F_ROOT}"/{missions,MISSIONS}/*; do
			copy_file "$i" "${WORKDIR}/missions"
		done
		for i in "${F_ROOT}"/{demos,DEMOS}/*; do
			copy_file "$i" "${WORKDIR}/demos"
		done
	fi

	# Also copy video files if desired
	if use videos; then
		# Require high resolution movie files
		for i in "${F_ROOT}"/*-{h.mvl,H.MVL}; do
			copy_file "$i" "${WORKDIR}"
		done
		if [ ! -f "${WORKDIR}/intro-h.mvl" \
			-o ! -f "${WORKDIR}/other-h.mvl" \
			-o ! -f "${WORKDIR}/robots-h.mvl" ] ; then
			die "videos not found"
		fi

		# Also copy low resolution movie files (not available from GOG)
		# Would anyone really want low-res videos at this point? Probably not.
		#for i in "${F_ROOT}"/*-{l.mvl,L.MVL}; do
		#	copy_file "$i" "${WORKDIR}"
		#done
	fi

}

src_prepare() {
	# Patch to 1.2 if necessary
	if use cdinstall; then
		if [ "$(md5sum descent2.ham)" != "7f30c3d7d4087b8584b49012a53ce022" ]; then
			for i in *.xdelta; do
				xdelta3 -d -s ${i%.*} ${i} ${i%.*}.new \
					|| die "patch ${i%.*} failed"
				mv ${i%.*}.new ${i%.*} || die "patch ${i%.*} failed"
			done
		fi
		rm *.xdelta || die "rm *.xdelta"
	fi

	mkdir doc || die "mkdir doc failed"
	mv *.{txt,pdf} doc/ # ignore fail
}

src_install() {
	insinto "${dir}"
	doins *

	if [ "$(ls -A missions/)" ]; then
		insinto "${dir}/missions"
		doins missions/*
	fi

	if [ "$(ls -A demos/)" ]; then
		insinto "${dir}/demos"
		doins demos/*
	fi

	if use doc; then
		dodoc doc/*.txt
		if [ $(ls doc/*.pdf 2>/dev/null | wc -l) -gt 0 ]; then
			insinto "/usr/share/doc/${PF}"
			doins doc/*.pdf
		fi
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "A client is needed to run the game, e.g. games-action/d2x-rebirth."
	echo
}
