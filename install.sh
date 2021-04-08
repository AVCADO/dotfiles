#!/bin/sh
DRIVE="/dev/nvme0n1"
WIFI_SSID="$1" # name of the ssid
WIFI_PSSW="$2" # password of the SSID
WIFI_NET="$3" # wlan0 / wlp1s0
BOOT="grub"

# Just display a help command
if [[ "$1" == "--help" ]]; then
  echo "Argument 1 >> WIFI SSID"
  echo "Argument 2 >> WIFI PASS"
  echo "Argument 3 >> WIFI CARD"
  false
fi

# Connect to wifi
wpa_passphrase "$WIFI_SSID" "$WIFI_PSSW" | tee /etc/wpa_supplicant.conf
wpa_supplicant -B -c /etc/wpa_supplicant.conf -i "$WIFI_NET"
dhcpcd "$WIFI_NET"

echo "===> WIFI CONNECTED"

sleep 3

# Make them partition their disks
cfdisk "$DRIVE"

echo "===> DRIVE PARTITIONED"

# Once they've partitioned their disks
# We can just format partitions
# and then mount

mkfs.fat -F32 -v "/dev/nvme0n1p1" # bad practice
mkfs.ext4 -v "/dev/nvme0n1p2"


sleep 3

echo "===> PARTITIONS FORMATTED"

mount -v /dev/nvme0n1p2 /mnt

echo "===> MOUNTED DRIVES"

pacstrap /mnt base linux linux-firmware

clear
echo "===> INSTALLED BASE"

genfstab -U /mnt >> /mnt/etc/fstab

echo "===> GENERATED FSTAB"

pacstrap /mnt grub efibootmgr

echo "===> INSTALLED BOOTLOADER"

# Mount /dev/nvme0n1p1 to /mnt/boot/efi
mount -v /dev/nvme0n1p1 /mnt/boot/efi

grub-install --target=x86_64-efi --efi-directory=/mnt/boot/efi
grub-mkconfig -o /mnt/boot/grub/grub.cfg

echo "===> INSTALLED BOOTLOADER"
echo "YOU'RE ON YOUR OWN, JUST RUN PASSWD AND REBOOT THE MACHINE"

arch-chroot /mnt

echo "==> END SCRIPT"
