ssh -l ec2-user -i "myssh.pem" PUBLICIP
sudo passwd ec2-user 
sudo apt-get update
sudo apt-get install xrdp lxde-core lxde tigervnc-standalone-server -y
sudo nano /etc/xrdp/xrdp.ini
    max_bpp=16
sudo nano /etc/X11/Xwrapper.config
        allowed_users=ec2-user
service xrdp start

Use RDP to connect to PUBLICIP

sudo apt-get update && apt-get upgrade