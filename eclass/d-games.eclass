# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: d-games.eclass
# @MAINTAINER:
# gamerlay@gentoo.org
# @BLURB: Eclass for writting ebuilds for D games.
# @DESCRIPTION:
# This eclass is ment to ease writting ebuilds for games that are written
# in D programming language.

# base added for PATCHES=( ${FILESDIR}/patch ) support
# @ECLASS-VARIABLE: EAPI
# @DESCRIPTION:
# By default we want EAPI 2 which might be redefinable to newer versions later.
case ${EAPI:-0} in
	[2-7]) : ;;
	*) die "d-games.eclass doesn't support your EAPI" ;;
esac

EXPORT_FUNCTIONS src_prepare

d-games_src_prepare() {
	# not eapi-handled due to danger of change for sys package in future.
	if ! has_version sys-devel/gcc[d]; then
		ewarn "sys-devel/gcc must be built with d useflag (although, some new versions have no this flag anymore)"
		die "recompile gcc with USE=\"d\" (or install the version that have this flag at all, and select this version to be used for this package"
	fi
}
