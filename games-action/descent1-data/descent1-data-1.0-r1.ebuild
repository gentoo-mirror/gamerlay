# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

CDROM_OPTIONAL="yes"
inherit cdrom eutils games

# For GOG install
MY_EXE="setup_descent_1_2.exe"

DESCRIPTION="Data files for Descent 1"
HOMEPAGE="http://www.interplay.com/games/support.php?id=263"
SRC_URI="cdinstall? ( http://www.dxx-rebirth.com/download/dxx/misc/descent-game-content-10to14a-patch.zip )
	!cdinstall? ( $MY_EXE )"

# See readme.txt
LICENSE="${PN}"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="!cdinstall? ( fetch )"
IUSE="+cdinstall doc"

RDEPEND=""
DEPEND="app-arch/unzip
	!cdinstall? (
		app-arch/innoextract
	)"

S=${WORKDIR}
dir=${GAMES_DATADIR}/d1x

# Function to handle copying and renaming files from installation directory;
# Allows support of installation sources using capitalized file names
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

	if use cdinstall; then
	# Check for Descent 1 CD or an existing install (eg., for GOG)
		CDROM_NAME_SET=( "CD-ROM Version" "Installed Version" "Installed Version" )
		cdrom_get_cds descent/descent.hog:descent.hog:DESCENT.HOG
		case ${CDROM_SET} in
			0)
				F_ROOT="${CDROM_ROOT}/descent"
				einfo 'Found Descent I CD' ;;
			[12])
				F_ROOT="${CDROM_ROOT}"
				einfo 'Found Descent I Installation' ;;
			*)
				die 'Descent I CD or installation files not found' ;;
		esac

	else
		# Check for GOG installer
		if [ ! -e "${DISTDIR}/${MY_EXE}" ]; then
			ewarn "You must copy or symlink '${MY_EXE}' to your distfiles directory"
			die "GOG installer not found"
		fi
		F_ROOT="${WORKDIR}/gog/app/descent"
	fi
}

src_unpack() {
	mkdir "${WORKDIR}/missions" || die "mkdir missions failed"

	# Unpack GOG package if necessary
	if ! use cdinstall; then
		einfo "Unpacking ${MY_EXE}. This will take a while..."
		mkdir gog && cd gog || die "mkdir gog failed"
		innoextract -e -s -L "${DISTDIR}/${MY_EXE}" || die "innoextract failed"
		cd .. || die "cd .. failed"
	fi

	# Copy all (including optional) mission files
	for i in "${F_ROOT}"/*.{hog,HOG,msn,MSN,pig,PIG,txt,TXT,pdf,PDF}; do
		copy_file "$i" "${WORKDIR}/missions"
	done

	# Move and validate required files
	mv missions/descent.hog . || die 'descent.hog not found'
	mv missions/descent.pig . || die 'descent.pig not found'

	# Unpack data file patches
	if use cdinstall; then
		mkdir d1datapt && cd d1datapt
		unpack ../descent-game-content-10to14a-patch.zip
	fi

	mkdir doc || die "mkdir doc failed"
	mv missions/*.txt missions/*.pdf doc/ # ignore fail
}

src_prepare() {
	# Only try to apply patch if it's actually needed
	if [ "$(md5sum descent.hog | cut -f1 -d' ')" != "c792a21a30b869b1ec6d31ad64e9557e" ]; then
		einfo "Patching Descent 1 data files"
		patch -p0 descent.hog <d1datapt/descent.hog.diff
		patch -p0 descent.pig <d1datapt/descent.pig.diff
	fi
}

src_install() {
	insinto "${dir}"
	doins *

	insinto "${dir}/missions"
	doins missions/*

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

	elog "A client is needed to run the game, e.g. games-action/d1x-rebirth."
	echo
}
