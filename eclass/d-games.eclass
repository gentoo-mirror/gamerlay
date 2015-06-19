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
inherit eutils base games

# @ECLASS-VARIABLE: EAPI
# @DESCRIPTION:
# By default we want EAPI 2 which might be redefinable to newer versions later.
case ${EAPI:-0} in
	2) : ;;
	*) DEPEND="EAPI-TOO-OLD" ;;
esac

EXPORT_FUNCTIONS src_prepare

d-games_src_prepare() {
	# not eapi-handled due to danger of change for sys package in future.
	if ! built_with_use sys-devel/gcc d; then
		ewarn "sys-devel/gcc must be built with d useflag"
		die "recompile gcc with USE=\"d\""
	fi

	# TODO: add check for correct gcc version selected in profile.

	base_src_prepare
	games_src_prepare
}
