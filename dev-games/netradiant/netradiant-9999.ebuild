# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

ESVN_DISABLE_DEPENDENCIES="true"
ESVN_OPTIONS="--trust-server-cert --non-interactive"

inherit eutils multilib toolchain-funcs subversion git

RADIANT_MAJOR_VERSION="5"
RADIANT_MINOR_VERSION="0"
DESCRIPTION="NetRadiant is a fork of map editor for Q3 based games, GtkRadiant 1.5"
HOMEPAGE="http://dev.alientrap.org/projects/netradiant"
EGIT_REPO_URI="git://git.xonotic.org/xonotic/netradiant.git"
BASE_ZIP_URI="http://ingar.satgnu.net/files/gtkradiant/gamepacks/"
SRC_URI="
	!bindist? (
		openarena? ( ${BASE_ZIP_URI}/OpenArenaPack.zip )
		quake? ( ${BASE_ZIP_URI}/QuakePack.zip )
		quake2? ( ${BASE_ZIP_URI}/Quake2Pack.zip )
		tremulous? ( ${BASE_ZIP_URI}/TremulousPack.zip )
	)
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
RADIANT_GPL_PACKS="darkplaces nexuiz quake2world warsow +xonotic"
RADIANT_NONGPL_PACKS="openarena quake quake2 quake3 tremulous ufoai"
RADIANT_TOOLS="h2data q2map q3data q3map2 qdata3"
RADIANT_PACKS="${RADIANT_GPL_PACKS} ${RADIANT_NONGPL_PACKS}"
RADIANT_BINS=" ${RADIANT_TOOLS} gtk"
IUSE="${RADIANT_PACKS} ${RADIANT_BINS// / +} bindist"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2
	>=media-libs/libpng-1.2
	>=sys-libs/zlib-1.2
	gtk? (
		>=x11-libs/gtk+-2.4:2
		>=x11-libs/gtkglext-1
		x11-libs/pango
	)
	!dev-games/gtkradiant
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	darkplaces? ( ${SUBVERSION_DEPEND} )
	quake2world? ( ${SUBVERSION_DEPEND} )
	warsow? ( ${SUBVERSION_DEPEND} )
	xonotic? ( net-misc/wget )
	!bindist? (
		openarena? ( app-arch/unzip )
		quake? ( app-arch/unzip )
		quake2? ( app-arch/unzip )
		quake3? ( ${SUBVERSION_DEPEND} )
		tremulous? ( app-arch/unzip )
		ufoai? ( ${SUBVERSION_DEPEND} )
	)
"
WGET="/usr/bin/wget -t 3 -T 60"

radiant_svn_unpack() {
	if use ${1}; then
		cd "${WORKDIR}/packs/" || die
		ESVN_REPO_URI="${2}" \
		ESVN_PROJECT="${PN}-${1}" \
		S="${WORKDIR}/packs/${1}" \
		subversion_fetch
	fi
}

radiant_zip_unpack() {
		if use ${1,,}; then
			cd "${WORKDIR}/packs/" || die
			unpack "${1}Pack.zip" || die
			mv ${1}Pack ${1,,} || die
		fi
}

pkg_setup() {
	targets=""
	for i in ${RADIANT_BINS};do
		if use $i; then
			targets+=" ${i/gtk/radiant}"
		fi
	done
	if [ "x$targets" = "x" ]; then
		targets=" q3map2"
		ewarn "You disabled all binaries: defaulting to USE=\"q3map2\""
	fi
}

src_unpack() {
	git_src_unpack

	if use gtk; then
		mkdir "${WORKDIR}/packs/" || die

		radiant_svn_unpack darkplaces \
			"https://zerowing.idsoftware.com/svn/radiant.gamepacks/DarkPlacesPack/branches/1.5/"
		radiant_svn_unpack quake2world \
			"svn://jdolan.dyndns.org/quake2world/trunk/gtkradiant"
		radiant_svn_unpack warsow \
			"https://svn.bountysource.com/wswpack/trunk/netradiant/games/WarsowPack/"

		if use nexuiz; then
			cd "${WORKDIR}/packs/" || die
			ewarn "Using \"git archive\" directly for downloading from http://git.xonotic.org/"
			ewarn "This might be potential security risk, make sure that you know what you are doing"
			git archive \
				--remote="git://git.icculus.org/divverent/nexuiz.git" \
				--prefix="nexuiz/" \
				master:misc/netradiant-NexuizPack \
				| tar xvf - 2>/dev/null || die
		fi

		if use xonotic; then
			EGIT_REPO_URI="git://git.xonotic.org/xonotic/netradiant-xonoticpack.git" \
			EGIT_BRANCH="master" \
			EGIT_PROJECT="${PN}-xonotic" \
			S="${WORKDIR}/packs/xonotic" \
			git_fetch

			cd "${WORKDIR}/packs/xonotic" || die
			ewarn "Using \"wget\" directly for downloading from http://git.xonotic.org/"
			ewarn "This might be potential security risk, make sure that you know what you are doing"
			while IFS="	" read -r FILE URL; do
				$WGET -O "$FILE" "$URL" || die
			done < "extra-urls.txt"
		fi

		if use !bindist; then
			MY_RADIANT_PACKS="${RADIANT_GPL_PACKS//+/} ${RADIANT_NONGPL_PACKS}"
			radiant_svn_unpack ufoai \
				"https://zerowing.idsoftware.com/svn/radiant.gamepacks/UFOAIPack/branches/1.5/"

			radiant_zip_unpack OpenArena
			radiant_zip_unpack Quake
			radiant_zip_unpack Quake2
			radiant_zip_unpack Tremulous

			if use quake3; then
				ESVN_REPO_URI="https://zerowing.idsoftware.com/svn/radiant.gamepacks/Q3Pack/trunk/" \
				ESVN_PROJECT="${PN}-quake3" \
				ESVN_REVISION="29" \
				S="${WORKDIR}/packs/quake3-tmp" \
				subversion_fetch
				cd "${WORKDIR}/packs/" || die
				mv quake3-tmp/tools quake3 || die
				rm -rf quake3-tmp || die
			fi
		else
			MY_RADIANT_PACKS="${RADIANT_GPL_PACKS//+/}"
			for i in ${RADIANT_NONGPL_PACKS}; do
				if use ${i}; then
					ewarn "USE bindist disables ${i} non GPL pack"
				fi
			done
		fi
	fi
}

src_prepare() {
	sed -e '/$(INSTALLDIR)/s,heretic2/h2data,/h2data,' \
		-i Makefile || die
}

src_configure() {
	tc-export CC CXX AR RANLIB

	export TEE_STDERR=""

	# dependencies-check wants gtk
	if use gtk; then
		emake dependencies-check || die
	fi
}

src_compile() {
	emake ${targets// / binaries-} || die
}

src_install() {
	insinto /usr/$(get_libdir)/${PN}
	doins \
		setup/data/tools/q3data.qdt \
		|| die

	dodoc ChangeLog ChangeLog.idsoftware CONTRIBUTORS TODO tools/quake3/q3map2/changelog.q3map{1,2.txt}

	pushd install || die
	exeinto /usr/$(get_libdir)/${PN}
	for i in ${targets}; do
		doexe ${i}.x86 || die
		dosym /usr/$(get_libdir)/${PN}/${i}.x86 /usr/bin/${i} || die
	done

	# radiant
	if use gtk; then
		dosym /usr/$(get_libdir)/${PN}/radiant.x86 /usr/bin/${PN} || die

		newicon "${S}"/icons/radiant-src.png ${PN}.png || die
		make_desktop_entry ${PN} NetRadiant ${PN} "Development;GTK;"

		# modules
		insinto /usr/$(get_libdir)/${PN}/modules
		doins modules/*.so || die

		# plugins
		insinto /usr/$(get_libdir)/${PN}/plugins
		doins plugins/*.so || die

		# data
		popd || die
		echo "$RADIANT_MINOR_VERSION" > RADIANT_MINOR || die
		echo "$RADIANT_MAJOR_VERSION" > RADIANT_MAJOR || die
		insinto /usr/$(get_libdir)/${PN}
		doins -r \
			RADIANT_MAJOR \
			RADIANT_MINOR \
			setup/data/tools/bitmaps \
			setup/data/tools/gl \
			setup/data/tools/global.xlink \
			setup/data/tools/plugins \
			docs \
			|| die

		# packs
		for x in ${MY_RADIANT_PACKS//+/}; do
			if use $x; then
				cd "${WORKDIR}"/packs/${x} || die
				# USE and dir names differ
				n="$(echo $x | sed \
					-e 's/^quake/q/' \
					-e 's/^q$/q1/' \
					-e 's/2world$/2w/' \
					-e 's/^openarena/oa/' \
					-e 's/^tremulous/trem/' \
				)"
				insinto /usr/$(get_libdir)/${PN}
				doins -r ${n}.game || die

				insinto /usr/$(get_libdir)/${PN}/games
				doins games/${n}.game || die
			fi
		done
	fi
}

pkg_preinst() {
	# subversion_pkg_preinst seems broken
	true
}
