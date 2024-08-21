# Add new raid1 btrfs filesystem

Assuming you have two btrfs-partitions

1. Check btrfs filesystem

       btrfs filesystem show

2. Create folder

       mkdir /data

3. Mount one of drives to folder

       mount /dev/sda1 /data

4. Add the second drive to forder >> storage capacity is combination of both drives

       btrfs device add /dev/nvme0n1p3 /data -f

5. Start balancing data and metadata in raid1 mode

       btrfs balance start -dconvert=raid1 -mconvert=raid1 /data

6. Check that there is now warnings

       btrfs filesystem df /data

7. Check how filesystems look like

       btrfs filesystem show

### Another way

Replaces steps 3 - 5

1. Before mounting 

       mkfs.btrfs --data raid1 --metadata raid1 /dev/sda1 /dev/nvme0n1p3

2. Mount to folder

       mount /dev/sda1 /data
