# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator multilib-minimal

MY_P=fmodapi$(delete_all_version_separators)linux

DESCRIPTION="music and sound effects library, and a sound processing system"
HOMEPAGE="http://www.fmod.org"
SRC_URI="http://www.fmod.org/download/fmodex/api/Linux/${MY_P}.tar.gz"

LICENSE="BSD BSD-2 fmod"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="designer examples tools"

RESTRICT="strip test"

QA_FLAGS_IGNORED="opt/fmodex/tools/fsbanklib/.*"
QA_PREBUILT="opt/fmodex/fmoddesignerapi/api/lib/*
	opt/fmodex/api/lib/*"
QA_TEXTRELS="opt/fmodex/fmoddesignerapi/api/lib/*
	opt/fmodex/api/lib/*"

S=${WORKDIR}/${MY_P}

multilib_src_compile() {
	if use examples; then
		if use amd64; then
			emake -j1 fmod_examples CPU=x64
		elif use x86; then
			emake -j1 fmod_examples CPU=x86
		fi
	fi
}

multilib_src_install() {
	local ldpath="/opt/fmodex/api/lib"

	dodir /opt/fmodex

	if ! use x86; then
		rm api/lib/libfmodex-${PV}.so
		rm api/lib/libfmodex.so
		rm api/lib/libfmodexL-${PV}.so
		rm api/lib/libfmodexL.so
		rm fmoddesignerapi/api/lib/libfmodevent-${PV}.so
		rm fmoddesignerapi/api/lib/libfmodevent.so
		rm fmoddesignerapi/api/lib/libfmodeventL-${PV}.so
		rm fmoddesignerapi/api/lib/libfmodeventL.so
		rm fmoddesignerapi/api/lib/libfmodeventnet-${PV}.so
		rm fmoddesignerapi/api/lib/libfmodeventnet.so
		rm fmoddesignerapi/api/lib/libfmodeventnetL-${PV}.so
		rm fmoddesignerapi/api/lib/libfmodeventnetL.so
		rm tools/fsbanklib/celt_encoder.so
		rm tools/fsbanklib/libfsbankex.a
		rm tools/fsbanklib/libmp3lame.so
		rm tools/fsbanklib/twolame.so
	fi
	if ! use amd64; then
		rm api/lib/*64*
		rm fmoddesignerapi/api/lib/*64*
		rm tools/fsbanklib/*64*
	fi

	cp -dpR api "${D}"/opt/fmodex || die

	rm -rf "${D}"/opt/fmodex/{documentation,fmoddesignerapi/*.TXT}

	if use designer; then
		ldpath="${ldpath}:/opt/fmodex/fmoddesignerapi/api/lib"

		if ! use examples; then
			rm -r fmoddesignerapi/examples
		fi

		cp -dpR fmoddesignerapi "${D}"/opt/fmodex || die

		dosym /opt/fmodex/fmoddesignerapi/api/inc /usr/include/fmoddesigner || die

		dodoc fmoddesignerapi/*.TXT
	fi

	if use examples; then
		cp -dpR examples "${D}"/opt/fmodex || die
	fi

	if use tools; then
		cp -dpR tools "${D}"/opt/fmodex || die
	fi

	dosym /opt/fmodex/api/inc /usr/include/fmodex || die

	docinto /usr/share/doc/${PF}/pdf
	dodoc documentation/*.pdf

	docinto /usr/share/doc/${PF}/chm
	dodoc documentation/*.chm

	dodoc documentation/*.txt

	echo "LDPATH=\"$ldpath\"" > ${T}/65fmodex

	doenvd "${T}"/65fmodex
}
