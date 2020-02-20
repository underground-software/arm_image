all:
	imagefactory --debug base_image --file-parameter install_script fedora-arm-minimal-flat.ks template.xml --parameter offline_icicle true

short:
	imagefactory --timeout 60 --debug base_image --file-parameter install_script fedora-arm-minimal-flat.ks template.xml --parameter offline_icicle true

deps:
	dnf install -y imagefactory imagefactory-plugins* libvirt
	modprobe fuse
	systemctl enable libvirtd && systemctl start libvirtd
	sed -i -e 's/# memory = 1024/memory = 4096/' /etc/oz/oz.cfg

