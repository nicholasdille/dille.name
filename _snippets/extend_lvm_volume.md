---
title: 'Extend LVM volume'
layout: snippet
tags:
- Docker
---
How to extend a LVM volume:

1. Rescan if disk not found:

    ```bash
    echo 1 >/sys/class/block/sda/device/rescan
    ```

2. Create primary partition sda2 of type 8e (Linux LVM):

    ```bash
    fdisk /dev/sda
    ```

3. Create physical volume:

    ```bash
    pvcreate /dev/sda2
    ```

4. Note name of existing volume group:

    ```bash
    vgdisplay
    ```

5. Extend volume group

    ```bash
    vgextend ubuntu-vg /dev/sda2
    ```

6. Scan for physical volumes

    ```bash
    pvscan
    ```

7. Note name of logical volume

    ```bash
    lvdisplay
    ```

8. Extend logical volume

    ```bash
    lvextend /dev/ubuntu-vg/root /dev/sda2
    ```

9. Resize filesystem

    a. extN:

    ```bash
    resize2fs /dev/ubuntu-vg/root
    ```


    b. xfs:

    ```bash
    xfs_growfs /dev/centos/root
    ```

