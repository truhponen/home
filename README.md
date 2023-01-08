This repository contains only random instructions that I need to maintain my Raspberry PI, Portainer, Home Assistant, OpenVPN, DNSMasq ... setup.

My memory is not great

# Mounting NFS drive


Followed these instructions: https://cloudinfrastructureservices.co.uk/how-to-install-nfs-on-debian-11-server/

1. Create folder

2. Add to "exports"-file...

        sudo nano /etc/exports

3. ... a statement that allows NFS-connections to folder

        /nfs/postgres 192.168.68.0/24(rw,sync,no_subtree_check,no_root_squash)

4. Restart NFS server

        systemctl restart nfs-server
        
5. Create volume in Docker
