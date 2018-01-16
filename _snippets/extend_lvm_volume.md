---
title: 'Extend LVM volume'
layout: snippet
tags:
- Docker
---
How to extend a LVM volume:

1. Rescan if disk not found:

    ```bash
    echo "- - -" > /sys/class/scsi_host/host0/scan
    ```

2. Create primary partition of type 8e (Linux LVM)

3. Create physical volume:

    ```bash
    pvcreate /dev/sdc1
    ```

4. Note name of existing volume group:

    ```bash
    vgdisplay
    ```

5. Extend volume group

    ```bash
    vgextend centos /dev/sdc1
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
    lvextend /dev/centos/root /dev/sdc1
    ```

9. Resize filesystem

    a. extN:

        ```bash
        resize2fs /dev/centos/root
        ```


    b. xfs:

        ```bash
        xfs_grow /dev/centos/root
        ```

