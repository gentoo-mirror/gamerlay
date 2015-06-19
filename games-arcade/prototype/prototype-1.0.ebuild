# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils games

DESCRIPTION="awarded winning RType clone"
HOMEPAGE="http://xout.blackened-interactive.com/ProtoType.html"
SRC_URI="http://xout.blackened-interactive.com/dump/new/ProtoType_src.zip
	http://xout.blackened-interactive.com/ProtoType/ProtoType.zip"
LICENSE="public-domain"
KEYWORDS="~x86"
IUSE=""
SLOT="0"

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl
	media-libs/devil
	=media-libs/fmod-3*"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}_${PV}

src_prepare(){
	edos2unix *.{cpp,h}
	epatch ${FILESDIR}/"${P}-makefile.patch"
	epatch ${FILESDIR}/"${P}-includes.patch"
	epatch ${FILESDIR}/"${P}-sdlrendertarget.patch"
	epatch ${FILESDIR}/"${P}-setstate.patch"
	epatch ${FILESDIR}/"${P}-linuxfixes.patch"
	epatch ${FILESDIR}/"${P}-hacks.patch"
	epatch ${FILESDIR}/"${P}-homedir.patch"
	for i in "${WORKDIR}"/*.cpp; do sed -i "$i" -e "s:Data/:"${GAMES_DATADIR}"/"${PN}"/:g"; done
}

src_install() {
	dogamesbin ${PN}
	local datadir="${GAMES_DATADIR}"/"${PN}"
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/"${PN}"
	mv ProtoType/Data/Gfx/forcecharge.png ProtoType/Data/Gfx/ForceCharge.png
	mv ProtoType/Data/Gfx/chainParticle.png ProtoType/Data/Gfx/ChainParticle.png
	mv ProtoType/Data/Gfx/Ladybird.png ProtoType/Data/Gfx/LadyBird.png
	mv ProtoType/Data/Gfx/Turret1.png ProtoType/Data/Gfx/turret1.png
	mv ProtoType/Data/Gfx/StarBurst.png ProtoType/Data/Gfx/Starburst.png
	mv ProtoType/Data/Gfx/forceblast.png ProtoType/Data/Gfx/Forceblast.png
	mv ProtoType/Data/Gfx/Fireball.png ProtoType/Data/Gfx/FireBall.png
	mv ProtoType/Data/Gfx/anim_back1.png ProtoType/Data/Gfx/Anim_back1.png
	mv ProtoType/Data/Gfx/anim_back2.png ProtoType/Data/Gfx/Anim_back2.png
	mv ProtoType/Data/Gfx/anim_Fore1.png ProtoType/Data/Gfx/Anim_Fore1.png
	mv ProtoType/Data/Gfx/anim_Fore2.png ProtoType/Data/Gfx/Anim_Fore2.png
	mv ProtoType/Data/Gfx/anim_Fore3.png ProtoType/Data/Gfx/Anim_Fore3.png
	mv ProtoType/Data/Gfx/WaterSplash.png ProtoType/Data/Gfx/watersplash.png
	mv ProtoType/Data/Gfx/PrototypeMk1.png ProtoType/Data/Gfx/Prototypemk1.png
	mv ProtoType/Data/Sound/deflection.wav ProtoType/Data/Sound/Deflection.wav
	mv ProtoType/Data/Sound/smallExplosion.wav ProtoType/Data/Sound/SmallExplosion.wav
	mv ProtoType/Data/Sound/PickUp.wav ProtoType/Data/Sound/Pickup.wav
	mv ProtoType/Data/Sound/UI_Select.wav ProtoType/Data/Sound/UI_select.wav
	doins -r ProtoType/Data/* || die
	newicon ProtoType/Data/Gfx/FireBug.png "${PN}.png"
	make_desktop_entry "${PN}" "${PN}"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

}