# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

SCM=""
if [ "${PV%9999}" != "${PV}" ] ; then
	SCM=mercurial
	EHG_REPO_URI="http://hg.openttdcoop.org/${PN}"
fi

inherit toolchain-funcs ${SCM}

MY_PV=${PV/_rc/-RC}
DESCRIPTION="A suite of programs to modify openttd/Transport Tycoon Deluxe's GRF files"
HOMEPAGE="http://dev.openttdcoop.org/projects/grfcodec"

if [ "${PV%9999}" != "${PV}" ] ; then
	SRC_URI=""
else
	SRC_URI="http://binaries.openttd.org/extra/${PN}/${MY_PV}/${PN}-${MY_PV}-source.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

if [ "${PV%9999}" != "${PV}" ] ; then
	S=${WORKDIR}/${PN}
else
	S=${WORKDIR}/${PN}-${MY_PV}-source
fi

DEPEND="!games-util/nforenum
	dev-lang/perl
	dev-libs/boost
	media-libs/libpng"
RDEPEND=""

src_prepare() {
# Set up Makefile.local so that we respect CXXFLAGS/LDFLAGS
cat > Makefile.local <<-__EOF__
		CXX = $(tc-getCXX)
		CXXFLAGS = ${CXXFLAGS}
		LDOPT = ${LDFLAGS}
		UPX =
		V = 1
	__EOF__
}

src_install() {
	dobin ${PN} grf{diff,id,merge} nforenum || die
	doman docs/*.1 || die
	dodoc changelog.txt docs/*.txt || die
}
