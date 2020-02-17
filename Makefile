all:
	imagefactory --debug base_image --file-parameter install_script fedora-arm-minimal-flat.ks template.xml --parameter offline_icicle true

deps:
	dnf install -y imagefactory imagefactory-plugins* libvirt
	modprobe fuse
	sysmtectl enable libvirt && systemctl start libvirt
	sed -i -e 's/# memory = 1024/memory = 4096/' /etc/oz/oz.cfg

