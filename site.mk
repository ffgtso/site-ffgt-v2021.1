##	gluon site.mk makefile example

##	GLUON_FEATURES
#		Specify Gluon features/packages to enable;
#		Gluon will automatically enable a set of packages
#		depending on the combination of features listed

GLUON_FEATURES := \
	autoupdater \
	ebtables-filter-multicast \
	ebtables-filter-ra-dhcp \
	ebtables-limit-arp \
	mesh-batman-adv-15 \
	mesh-vpn-tunneldigger \
	tunneldigger-watchdog \
	migrate-vpn \
	radvd \
	respondd \
	status-page \
	web-advanced \
	web-wizard \
	web-private-wifi \
	config-mode-domain-select

##	GLUON_SITE_PACKAGES
#		Specify additional Gluon/OpenWrt packages to include here;
#		A minus sign may be prepended to remove a packages from the
#		selection that would be enabled by default or due to the
#		chosen feature flags

GLUON_SITE_PACKAGES := iwinfo \
    tecff-autoupdater-wifi-fallback \
    gluon-radv-filterd \
    tecff-ssid-changer \
    ffgt-banner \
    ffgt-geolocate \
    ffgt-setup-mode \
    ffgt-location \
    ffgt-geolocator \
    ffda-domain-director \
    respondd-module-airtime \
    ffgt-preserve-mods \
    ffda-name-conformizer \
    ffho-ap-timer \
    ffgt-nachtruhe \
    gluon-web-logging \
    gluon-migrate-ffbiv2 \
    fflg-migrate-to-multidomain \
    ffue-migrate-to-multidomain \
    ffgt-speedtest \
    ffda-geolocator \
    ffda-location \
    ffda-migrate-update-branch \
    gluon-alfred

# gluon-alfred because of Hegoland ...

GLUON_FEATURES_standard := wireless-encryption-wpa3

GLUON_SITE_PACKAGES_standard := \
    tcpdump \
    mtr \
    ip-full \

ifeq ($(GLUON_TARGET),ar71xx-tiny)
	GLUON_SITE_PACKAGES += wpa-supplicant-dummy
else
	GLUON_SITE_PACKAGES += wpa-supplicant-openssl
endif

##	DEFAULT_GLUON_RELEASE
#		version string to use for images
#		gluon relies on
#			opkg compare-versions "$1" '>>' "$2"
#		to decide if a version is newer or not.

DEFAULT_GLUON_RELEASE := 1.4.0

# Variables set with ?= can be overwritten from the command line

##	GLUON_RELEASE
#		call make with custom GLUON_RELEASE flag, to use your own release version scheme.
#		e.g.:
#			$ make images GLUON_RELEASE=23.42+5
#		would generate images named like this:
#			gluon-ff%site_code%-23.42+5-%router_model%.bin

GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

# Default priority for updates.
GLUON_PRIORITY ?= 0

# Region code required for some images; supported values: us eu
GLUON_REGION ?= eu

# Languages to include
GLUON_LANGS ?= en de

# Do not build images for deprecated devices
#GLUON_DEPRECATED ?= 0
GLUON_DEPRECATED=upgrade

GLUON_MULTIDOMAIN=1

GLUON_VERSION = v2021.1.2-ffgt

# support for USB UMTS/3G devices
USB_PACKAGES_3G := \
	kmod-usb-serial \
	kmod-usb-serial-wwan \
	kmod-usb-serial-option \
	chat \
	ppp \
	kmod-usb-net-cdc-ether \
	kmod-usb-net-cdc-mbim \
	kmod-usb-net-hso \
	kmod-usb-net-huawei-cdc-ncm \
	kmod-usb-net-qmi-wwan

# support for USB GPS devices
USB_PACKAGES_GPS := \
	kmod-usb-acm \
	ugps

# support for HID devices (keyboard, mouse, ...)
USB_PACKAGES_HID := \
	kmod-usb-hid \
	kmod-hid-generic

# support for USB tethering
USB_PACKAGES_TETHERING := \
	kmod-usb-net \
	kmod-usb-net-asix \
	kmod-usb-net-asix-ax88179 \
	kmod-usb-net-dm9601-ether

USB_X86_GENERIC_NETWORK_MODULES := \
	kmod-usb-ohci-pci \
	kmod-sky2 \
	kmod-atl2 \
	kmod-igb \
	kmod-3c59x \
	kmod-e100 \
	kmod-e1000 \
	kmod-e1000e \
	kmod-natsemi \
	kmod-ne2k-pci \
	kmod-pcnet32 \
	kmod-8139too \
	kmod-r8169 \
	kmod-sis900 \
	kmod-tg3 \
	kmod-via-rhine \
	kmod-via-velocity \
	kmod-forcedeth \
	kmod-wireguard \
    kmod-bnx2

# storage support for USB
USB_PACKAGES_STORAGE := \
	block-mount \
	kmod-fs-ext4 \
	kmod-fs-vfat \
	kmod-usb-storage \
	kmod-usb-storage-extras \
	blkid \
	swap-utils \
	kmod-nls-cp1250 \
	kmod-nls-cp1251 \
	kmod-nls-cp437 \
	kmod-nls-cp775 \
	kmod-nls-cp850 \
	kmod-nls-cp852 \
	kmod-nls-cp866 \
	kmod-nls-iso8859-1 \
	kmod-nls-iso8859-13 \
	kmod-nls-iso8859-15 \
	kmod-nls-iso8859-2 \
	kmod-nls-koi8r \
	kmod-nls-utf8

USB_PACKAGES_WIREGUARD := \
	kmod-wireguard \
	wireguard-tools \
	wireguard

# add addition network drivers and usb stuff only to targets where disk space does not matter
ifeq ($(GLUON_TARGET),x86-generic)
	# support the USB stack on x86 devices
	# and add a few common USB NICs
	GLUON_SITE_PACKAGES += \
		$(USB_PACKAGES_STORAGE) \
		$(USB_PACKAGES_HID) \
		$(USB_PACKAGES_TETHERING) \
		$(USB_PACKAGES_3G) \
		$(USB_PACKAGES_GPS) \
		$(USB_X86_GENERIC_NETWORK_MODULES)
endif

USB_PACKAGES_MOST := $(USB_PACKAGES_STORAGE)
USB_PACKAGES_MOST += $(USB_PACKAGES_HID) \
		$(USB_PACKAGES_TETHERING) \
		$(USB_PACKAGES_3G) \
		$(USB_PACKAGES_GPS)\
		$(USB_PACKAGES_MEDIA) \
		$(USB_PACKAGES_WIREGUARD)



# Additional package list generated by contrib/genpkglist.py
# (script from ffda - https://git.darmstadt.ccc.de/ffda/firmware/site/-/blob/master/contrib/genpkglist.py)

INCLUDE_USB := \
    usbutils

EXCLUDE_USB := \
    -usbutils

INCLUDE_USB_HID := \
    kmod-usb-hid \
    kmod-hid-generic

EXCLUDE_USB_HID := \
    -kmod-usb-hid \
    -kmod-hid-generic

INCLUDE_USB_SERIAL := \
    kmod-usb-serial \
    kmod-usb-serial-ftdi \
    kmod-usb-serial-pl2303

EXCLUDE_USB_SERIAL := \
    -kmod-usb-serial \
    -kmod-usb-serial-ftdi \
    -kmod-usb-serial-pl2303

INCLUDE_USB_STORAGE := \
    block-mount \
    blkid \
    kmod-fs-ext4 \
    kmod-fs-ntfs \
    kmod-fs-vfat \
    kmod-usb-storage \
    kmod-usb-storage-extras \
    kmod-usb-storage-uas \
    kmod-nls-base \
    kmod-nls-cp1250 \
    kmod-nls-cp437 \
    kmod-nls-cp850 \
    kmod-nls-cp852 \
    kmod-nls-iso8859-1 \
    kmod-nls-iso8859-13 \
    kmod-nls-iso8859-15 \
    kmod-nls-iso8859-2 \
    kmod-nls-utf8

EXCLUDE_USB_STORAGE := \
    -block-mount \
    -blkid \
    -kmod-fs-ext4 \
    -kmod-fs-ntfs \
    -kmod-fs-vfat \
    -kmod-usb-storage \
    -kmod-usb-storage-extras \
    -kmod-usb-storage-uas \
    -kmod-nls-base \
    -kmod-nls-cp1250 \
    -kmod-nls-cp437 \
    -kmod-nls-cp850 \
    -kmod-nls-cp852 \
    -kmod-nls-iso8859-1 \
    -kmod-nls-iso8859-13 \
    -kmod-nls-iso8859-15 \
    -kmod-nls-iso8859-2 \
    -kmod-nls-utf8

INCLUDE_USB_NET := \
    kmod-mii \
    kmod-usb-net \
    kmod-usb-net-asix \
    kmod-usb-net-asix-ax88179 \
    kmod-usb-net-cdc-eem \
    kmod-usb-net-cdc-ether \
    kmod-usb-net-cdc-subset \
    kmod-usb-net-dm9601-ether \
    kmod-usb-net-hso \
    kmod-usb-net-ipheth \
    kmod-usb-net-mcs7830 \
    kmod-usb-net-pegasus \
    kmod-usb-net-rndis \
    kmod-usb-net-rtl8152 \
    kmod-usb-net-smsc95xx \
    ffda-usb-wan-hotplug

EXCLUDE_USB_NET := \
    -kmod-mii \
    -kmod-usb-net \
    -kmod-usb-net-asix \
    -kmod-usb-net-asix-ax88179 \
    -kmod-usb-net-cdc-eem \
    -kmod-usb-net-cdc-ether \
    -kmod-usb-net-cdc-subset \
    -kmod-usb-net-dm9601-ether \
    -kmod-usb-net-hso \
    -kmod-usb-net-ipheth \
    -kmod-usb-net-mcs7830 \
    -kmod-usb-net-pegasus \
    -kmod-usb-net-rndis \
    -kmod-usb-net-rtl8152 \
    -kmod-usb-net-smsc95xx \
    -ffda-usb-wan-hotplug

INCLUDE_PCI := \
    pciutils

EXCLUDE_PCI := \
    -pciutils

INCLUDE_PCI_NET := \
    kmod-bnx2

EXCLUDE_PCI_NET := \
    -kmod-bnx2

ifeq ($(GLUON_TARGET),ath79-generic)
    GLUON_devolo-wifi-pro-1750e_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_gl.inet-gl-ar150_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_gl.inet-gl-ar300m-lite_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_gl.inet-gl-ar750_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_joy-it-jt-or750i_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_netgear-wndr3700-v2_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-a7-v5_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c5-v1_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c7-v2_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c7-v5_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c59-v1_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-tl-wr842n-v3_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-tl-wr1043nd-v4_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-tl-wr1043n-v5_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
endif

# no pkglists for target ath79-nand


ifeq ($(GLUON_TARGET),bcm27xx-bcm2708)
    GLUON_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_HID) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),bcm27xx-bcm2709)
    GLUON_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_HID) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),bcm27xx-bcm2710)
    GLUON_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_HID) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),ipq40xx-generic)
    GLUON_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),ipq806x-generic)
    GLUON_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),lantiq-xrx200)
    GLUON_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

    GLUON_avm-fritz-box-7412_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-td-w8970_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-td-w8980_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
endif

# no pkglists for target lantiq-xway


ifeq ($(GLUON_TARGET),mediatek-mt7622)
    GLUON_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

    GLUON_ubiquiti-unifi-6-lr_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
endif

ifeq ($(GLUON_TARGET),mpc85xx-p1010)
    GLUON_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),mpc85xx-p1020)
    GLUON_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),mvebu-cortexa9)
    GLUON_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

# no pkglists for target ramips-mt7620


ifeq ($(GLUON_TARGET),ramips-mt7621)
    GLUON_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

    GLUON_netgear-ex6150_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-edgerouter-x_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-edgerouter-x-sfp_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
endif

ifeq ($(GLUON_TARGET),ramips-mt76x8)

    GLUON_gl-mt300n-v2_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_gl.inet-microuter-n300_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_netgear-r6120_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_ravpower-rp-wd009_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
endif

ifeq ($(GLUON_TARGET),rockchip-armv8)
    GLUON_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),sunxi-cortexa7)
    GLUON_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),x86-64)
    GLUON_SITE_PACKAGES += $(INCLUDE_PCI) $(USB_X86_GENERIC_NETWORK_MODULES) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),x86-generic)
    GLUON_SITE_PACKAGES += $(INCLUDE_PCI) $(USB_X86_GENERIC_NETWORK_MODULES) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),x86-geode)
    GLUON_SITE_PACKAGES += $(INCLUDE_PCI) $(INCLUDE_PCI_NET) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

# no pkglists for target x86-legacy

