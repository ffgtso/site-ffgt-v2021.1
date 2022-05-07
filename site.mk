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
    gluon-ebtables-limit-arp \
    gluon-ebtables-filter-multicast \
    gluon-radv-filterd \
    -gluon-alfred \
    gluon-ssid-changer \
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
	gluon-migrate-ffbi \
	ffgt-speedtest

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

ifneq ($(GLUON_TARGET),ar71xx-tiny)
    GLUON_SITE_PACKAGES += sipcalc bird1-ivp6 bird1c-ipv6 tcpdump wireguard-tools wireguard
endif

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
	kmod-wireguard

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

# use the target names of https://github.com/freifunk-gluon/gluon/blob/master/targets/ar71xx-generic#L163
ifeq ($(GLUON_TARGET),ar71xx-generic)
#	GLUON_tp-link-tl-wr842n-nd-v1_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_tp-link-tl-wr842n-nd-v2_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_tp-link-tl-wr842n-nd-v3_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_tp-link-tl-wr1043n-nd-v2_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_tp-link-tl-wr1043n-nd-v3_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_tp-link-tl-wr1043n-nd-v4_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_tp-link-tl-wdr4300-v1_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_tp-link-tl-wdr3600-v1_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_tp-link-tl-wr2543n-nd-v1_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_linksys-wrt160nl_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_d-link-dir-825-rev-b1_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_d-link-dir-505-rev-a1_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_d-link-dir-505-rev-a2_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_gl-inet-6408a-v1_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_gl-inet-6416a-v1_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_netgear-wndr3700_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_netgear-wndr3700v2_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_netgear-wndr3700v4_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_netgear-wndrmacv2_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_buffalo-wzr-hp-g450h_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_buffalo-wzr-hp-g300nh_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_buffalo-wzr-hp-ag300h-wzr-600dhp_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_buffalo-wzr-hp-ag300h_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_tp-link-archer-c7-v2_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_gl-ar300m_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_gl-inet-6416a-v1_SITE_PACKAGES := $(USB_PACKAGES_MOST)
endif

ifeq ($(GLUON_TARGET),mpc85xx-generic)
#	GLUON_tp-link-tl-wdr4900-v1_SITE_PACKAGES := $(USB_PACKAGES_MOST)
endif

ifeq ($(GLUON_TARGET),ipq40xx)
#	GLUON_avm-fritz-box-4040_SITE_PACKAGES := $(USB_PACKAGES_MOST)
endif

ifeq ($(GLUON_TARGET),ramips-mt76x8)
#	GLUON_gl-mt300n-v2_SITE_PACKAGES := $(USB_PACKAGES_MOST)
endif

ifeq ($(GLUON_TARGET),ramips-mt7620)
#	GLUON_gl-mt300n_SITE_PACKAGES := $(USB_PACKAGES_MOST)
#	GLUON_gl-mt300a_SITE_PACKAGES := $(USB_PACKAGES_MOST)
endif
