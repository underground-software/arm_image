# arm_image

In theory, we should be able to use the contents of this repository to build bootable aarch64 fedora images for devices such as the Raspberry Pi.

In practice, it doesn't actually work and I have no evidence that anyone other than the official fedora maintainers have been able to get it to work.

To reproduce the failed build on a fresh fedora host:

1. `make deps`
2. `make`
