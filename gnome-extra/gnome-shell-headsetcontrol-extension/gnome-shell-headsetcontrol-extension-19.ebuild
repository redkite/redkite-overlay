# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils

DESCRIPTION="Gnome Shell Extension to visualize headset status from HeadsetControl"
HOMEPAGE="https://github.com/ChrisLauinger77/gnome-shell-extension-HeadsetControl"
SRC_URI="https://github.com/ChrisLauinger77/gnome-shell-extension-HeadsetControl/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="
app-misc/headsetcontrol
=gnome-base/gnome-shell-45
app-eselect/eselect-gnome-shell-extensions
"
BDEPEND=""

S="${WORKDIR}/gnome-shell-extension-HeadsetControl-${PV}"
extension_uuid="HeadsetControl@lauinger-clan.de"

src_install() {
	default

	cd ${extension_uuid}
	einstalldocs
	insinto /usr/share/glib-2.0/schemas
	doins schemas/*.xml
	rm -rf schemas || die
	insinto /usr/share/gnome-shell/extensions/"${extension_uuid}"
	doins -r *
	dosym ../../../../../usr/share/glib-2.0/schemas /usr/share/gnome-shell/extensions/"${extension_uuid}"/schemas
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}

pkg_postrm() {
	gnome2_schemas_update
}
