#version=DEVEL
# System language
lang en_US.UTF-8
# System authorization information
auth --useshadow --passalgo=sha512
# Firewall configuration
firewall --enabled --service=mdns,ssh
repo --name="fedora" --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
repo --name="updates" --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f$releasever&arch=$basearch
# Use network installation
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch"
# Run the Setup Agent on first boot
firstboot --reconfig
# SELinux configuration
selinux --enforcing

# System services
services --enabled="sshd,NetworkManager,avahi-daemon,chronyd,initial-setup,zram-swap"
# System bootloader configuration
bootloader --location=mbr
# Disk partitioning information
clearpart --all
zerombr
autopart
#part /boot/efi --asprimary --fstype="vfat" --size=80
#part /boot --asprimary --fstype="ext4" --size=512
#part / --fstype="ext4" --size=1400

%post

# Setup Raspberry Pi firmware
cp -P /usr/share/uboot/rpi_2/u-boot.bin /boot/efi/rpi2-u-boot.bin
cp -P /usr/share/uboot/rpi_3_32b/u-boot.bin /boot/efi/rpi3-u-boot.bin

# work around for poor key import UI in PackageKit
rm -f /var/lib/rpm/__db*
releasever=$(rpm -q --qf '%{version}\n' fedora-release)
basearch=armhfp
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
echo "Packages within this ARM disk image"
rpm -qa
# Note that running rpm recreates the rpm db files which aren't needed or wanted
rm -f /var/lib/rpm/__db*

# remove random seed, the newly installed instance should make it's own
rm -f /var/lib/systemd/random-seed

# Because memory is scarce resource in most arm systems we are differing from the Fedora
# default of having /tmp on tmpfs.
echo "Disabling tmpfs for /tmp."
systemctl mask tmp.mount

dnf -y remove dracut-config-generic

# Disable network service here, as doing it in the services line
# fails due to RHBZ #1369794
/sbin/chkconfig network off

# Remove machine-id on pre generated images
rm -f /etc/machine-id
touch /etc/machine-id

%end

%post

# setup systemd to boot to the right runlevel
echo -n "Setting default runlevel to multiuser text mode"
rm -f /etc/systemd/system/default.target
ln -s /lib/systemd/system/multi-user.target /etc/systemd/system/default.target
echo .

%end

%packages
@arm-tools
@core
@hardware-support
NetworkManager-wifi
bcm283x-firmware
chkconfig
chrony
dracut-config-generic
extlinux-bootloader
glibc-langpack-en
initial-setup
iw
kernel
rng-tools
zram
-@standard
-dracut-config-rescue
-generic-release*
-glibc-all-langpacks
-initial-setup-gui
-iproute-tc
-ipw*
-iwl*
-trousers
-uboot-images-armv8
-usb_modeswitch
-xkeyboard-config

%end
