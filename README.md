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

# VPN

### Modem setting (ZTE MC801A)

e.g. After reset

1. Go to http://192.168.100.1
2. Set
    1. Nykyinen tila: "Siltaava tila"
4. Go to "...\Wi-Fi asetukset\
5. Set
    1. WLAN-kytkin: "Pois käytöstä"
7. Go to "...\5G asetukset\Yhteyspiste"
8. Set
   1. PDP-tyyppi: "IPv4"
   2. Yhteyspiste: "internet4" (default: "internet")
9. Go to "...\Lisäasetukset\Reititin"
10. Set
    1. DHCP-palvelin: "Ei käytössä"

### Router settings (Deco)
1. Management page: app
4. Go to "\Lisää\Lisäasetukset\NAT-siirto\Portin edelleenlähetys"
5. Add port forwarding for ports
   1. 80
   2. 443
   3. 943
   4. 945
   5. 1194
  
### NGINX 

    http {
        server {
            listen 80;
            listen [::]:80;
        
            server_name xxxxxx;
            server_tokens off;
        
            location / {
                return 301 https://$host$request_uri;
            }
        }


### Open VPN Access server

If Raspberry Pi, OS has to be Ubuntu 20.04 LTS.

Instructions: https://openvpn.net/vpn-server-resources/install-openvpn-access-server-on-raspberry-pi/

Status of Access Server

    sudo systemctl status openvpnas

Update host's privkey to OpenVPS

    sudo /usr/local/openvpn_as/scripts/sacli --key "cs.priv_key" --value_file "/etc/letsencrypt/live/truhponen.duckdns.org/privkey.pem" ConfigPut

Update host's fullchain to OpenVPS

    sudo /usr/local/openvpn_as/scripts/sacli --key "cs.cert" --value_file "/etc/letsencrypt/live/truhponen.duckdns.org/fullchain.pem" ConfigPut

Restart Access Server

    sudo /usr/local/openvpn_as/scripts/sacli start

OR
    
    sudo systemctl restart openvpnas

#### Restart on failure

Instructions based on: https://www.digitalocean.com/community/tutorials/how-to-configure-a-linux-service-to-start-automatically-after-a-crash-or-reboot-part-2-reference

    sudo nano /etc/systemd/system/multi-user.target.wants/openvpnas.service

set in "Service"-section

    Restart=on-failure

To test setup find main PID

    sudo systemctl status openvpnas.service

Kill main process

    sudo kill -9 [add PID number here]

Check if process comes back alive

    sudo systemctl status openvpnas.service
