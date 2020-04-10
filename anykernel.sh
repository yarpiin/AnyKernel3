# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=starlte
device.name2=star2lte
device.name3=crownlte
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/platform/11120000.ufs/by-name/BOOT;
is_slot_device=auto;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

## AnyKernel install
dump_boot;

# Patch fstab
mount -o remount,rw /vendor;

if [ ! -e /vendor/etc/fstab.samsungexynos9810~ ]; then
	backup_file /vendor/etc/fstab.samsungexynos9810;
fi;

patch_fstab /vendor/etc/fstab.samsungexynos9810 /data ext4 flags "forceencrypt=footer" "encryptable=footer";

# Move device dtb
mv -f $home/dtb.img $split_img/extra;

write_boot;
## end install

