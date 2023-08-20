This repository contains only random instructions that I need to maintain my Raspberry PI, Portainer, Home Assistant, OpenVPN, DNSMasq ... setup.

My memory is not great.


# Creating container image using Docker

To Docker hub

    docker buildx build -t truhponen/my-departures:latest --platform linux/arm64 --push .
        
To Git hub

    sudo docker buildx build -t ghcr.io/truhponen/my-departures:latest --platform linux/arm64 --push .


* "Docker buildx build" to create Pi + Linux compliant image on Windows
* "-t ghcr.io/truhponen/" to Git hub **OR** "-t truhponen/" to Docker hub
* "my-departures:latest" to add right tag
* "--platform linux/arm64" to make image Pi + Linux compliant
* "--push" image
* "." actions in project folder


# Mounting NFS drive

Followed these instructions: https://cloudinfrastructureservices.co.uk/how-to-install-nfs-on-debian-11-server/

1. Create folder

2. Add to "exports"-file...

       sudo nano /etc/exports

3. ... a statement that allows NFS-connections to folder

        /nfs/postgres 192.168.68.0/24(rw,sync,no_subtree_check,no_root_squash)

4. Restart NFS server

        systemctl restart nfs-server
        
5. Create volume in Docker / Portainer

   Use NFS volume

       TRUE

   Address

       192.168.68.118

   Mount point

       :/nfs/whisper

# Home assistant voice

Links to containers from https://www.home-assistant.io/blog/2023/04/27/year-of-the-voice-chapter-2/

### Piper

container image: https://hub.docker.com/r/rhasspy/wyoming-piper

Run

    docker run -it -p 10200:10200 -v /path/to/local/data:/data rhasspy/wyoming-piper --voice en-us-lessac-low

Compose 

    piper:
      image: "rhasspy/wyoming-piper:latest"
          
      restart: unless-stopped
          
      networks:
        home_automation:
        
      ports:
        "10200:10200"
            
      volumes:
        - piper:/data:rw
            
      command: --voice en_US-lessac-medium

### Whisper

container image: https://hub.docker.com/r/rhasspy/wyoming-whisper

Run

    docker run -it -p 10300:10300 -v /path/to/local/data:/data rhasspy/wyoming-whisper --model tiny-int8 --language en

Compose 

    whisper:
      image: "rhasspy/wyoming-whisper:latest"
          
      restart: unless-stopped
          
      networks:
        home_automation:
        
      ports:
        - "10300:10300"
            
      volumes:
        - whisper:/data:rw
            
      command: --model tiny-int8 --language en

### Open VPN Access server

Status

    sudo systemctl status openvpnas

privkey

    sudo /usr/local/openvpn_as/scripts/sacli --key "cs.priv_key" --value_file "/etc/letsencrypt/live/truhponen.duckdns.org/privkey.pem" ConfigPut

fullchain

    sudo /usr/local/openvpn_as/scripts/sacli --key "cs.cert" --value_file "/etc/letsencrypt/live/truhponen.duckdns.org/fullchain.pem" ConfigPut

start

    /usr/local/openvpn_as/scripts/sacli start

