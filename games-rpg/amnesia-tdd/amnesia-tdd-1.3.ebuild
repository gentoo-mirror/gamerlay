# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

MY_PN="Amnesia The Dark Decent"
MY_SRC_PN="Amnesia_The_Dark_Descent"
# ^ upstream did a typo (Decent vs Descent)

DESCRIPTION="A first person survival horror. Immersion, discovery and living in a nightmare."
HOMEPAGE="http://www.amnesiagame.com/"
SRC_URI="${MY_SRC_PN}_Linux.zip"

RESTRICT="fetch strip bindist"
LICENSE="all-rights-reserved"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="doc l10n_de l10n_es l10n_fr l10n_it l10n_ru"

DEPEND="app-arch/xz-utils"
RDEPEND="media-libs/freealut
	>=media-libs/glew-1.5
	virtual/jpeg-compat
	media-libs/libpng-compat:1.2
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl-image
	media-libs/sdl-ttf
	sys-libs/zlib
	x11-libs/libxcb
	x11-libs/libXext
	virtual/glu
	virtual/opengl"

S="${WORKDIR}/${MY_PN}"

GAMEDIR="/usr/share/${P}"

pkg_nofetch() {
	einfo ""
	einfo "Please buy and download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE} (or HumbleBundle or GOG)"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo ""
}

src_prepare() {
	default
	local arch archdrop libdir liddropdir

	if use amd64; then
		arch="x86_64"
		archdrop="x86"
		libdir="lib64"
		libdropdir="lib"
	else
		arch="x86"
		archdrop="x86_64"
		libdir="lib"
		libdropdir="lib64"
	fi
	# Files to remove.
	REMOVE=(
		"${libdir}/*"
		"*.pdf"
		"*.rtf"
		"*.bin.${archdrop}"
		"*.sh"
		"${libdropdir}"
	)

	KEEP=("${libdir}/libsteam_api.so")

	if use doc && [[ ( "${linguas_in_use}" == "0" || "${docs_eng}" != "0" ) ]]; then
		KEEP="${KEEP} EULA_en.rtf Manual_en.pdf Remember*.pdf *ChangeLog*"
	fi

	mv "Amnesia.bin.${arch}" "Amnesia.bin" || die "mv \"Amnesia.bin64\" failed"
	mv "Launcher.bin.${arch}" "Launcher.bin" || die "mv \"Launcher.bin64\" failed"

	einfo " Removing useless files ..."
	for remove in ${REMOVE[@]}; do
		local removable="1"
		for keep in ${KEEP[@]}; do
			if [[ "${remove}" == "${keep}" && "${removable}" == "1" ]]; then
				local removable="0"
			fi
		done

		if [[ "${removable}" == "1" ]]; then
			rm -r "${S}/"${remove} &> /dev/null
		fi
	done
}

src_install() {
	# Install data
	insinto "${GAMEDIR}"

	einfo " Installing game data files ..."
	for directory in $(find * -maxdepth 0 -type d ! -name "lib*"); do
		doins -r ${directory} || die "doins game data files failed"
	done

	# Other files
	find . \
		-maxdepth 1 \
		-type f \
		! -name "*.bin" \
		! -name "*.pdf" \
		! -name "*.png" \
		! -name "*.rtf" \
		! -name "*.sh" \
		! -name "*.txt" \
		-exec doins '{}' \; || die "doins other files failed"

	# Install libraries and executables
	einfo " Installing libraries and executables ..."
	if use amd64; then
		local libsdir="lib64"
	else
		local libsdir="lib"
	fi

	exeinto "${GAMEDIR}/${libsdir}" || die "exeinto \"${libsdir}\" failed"
	doexe "${libsdir}"/* || die "doexe \"lib\" failed"

	exeinto "${GAMEDIR}" || die "exeinto \"${GAMEDIR}\" failed"
	doexe ./*.bin || die "doexe failed"
	local ext="${PN}-justine"

	cat << EOF >> "${PN}" || die "echo failed"
#!/bin/sh
cd "${GAMEDIR}"

if [[ "\$(basename "\${0}")" == "${ext}" ]]; then
	params="ptest \${@}"
fi

if [[ -w "\${HOME}/.frictionalgames/Amnesia/Main/main_settings.cfg" ]]; then
	exec ./Amnesia.bin \${params:-"\${@}"}
else
	exec ./Launcher.bin "\${@}"
fi
EOF

	dobin "${PN}" || die "dobin failed"
	dosym "${PN}" "${EROOT}/usr/bin/${ext}" || die "dosym \"${ext}\" failed"

	# Install icon and desktop file
	newicon "${FILESDIR}/Amnesia.png" "${PN}.png" || die "newicon failed"
	make_desktop_entry "${PN}" "Amnesia: The Dark Descent" "${PN}" || die "make_desktop_entry failed"
	make_desktop_entry "${ext}" "Amnesia: The Dark Descent - Justine" "${PN}" || die "make_desktop_entry failed"

	# Install documentation
	if use doc; then
		dodoc *.rtf *.pdf *.txt || die "dodoc failed"
	fi
}

pkg_postinst() {
	ewarn ""
	ewarn "Amnesia: The Dark Descent needs video drivers that provide a complete".
	ewarn "GLSL 1.20 implementation.  For more information, please visit:"
	ewarn "http://www.frictionalgames.com/forum/thread-3760.html"
	ewarn ""
	ewarn "--------------------------------------------------------------------"
	ewarn ""
	ewarn "Saved games from previous versions may not be fully compatible."
	ewarn ""
	ewarn "--------------------------------------------------------------------"
	ewarn ""
	ewarn "Also, be noticed that Launcher binary can segfault on Intel videocards,"
	ewarn "so you'll need to manually create ~/.frictionalgames/Amnesia/Main/main_settings.cfg"
	ewarn "(to pass wrapper check to directly run the game instead of launcher)"
	ewarn ""
}
