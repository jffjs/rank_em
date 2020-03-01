Make sure you're up to date
```bash
sudo apt update
sudo apt upgrade
```

This should already be installed, but to be safe
```bash
sudo apt install unattended-upgrades
```

Reboot for the upgrades
```bash
sudo systemctl reboot
```

Install postgres
```bash
sudo bash -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo apt update
sudo apt install postgresql-12
```

Create deploy user and database in PostgreSQL
save the password for later
```bash
sudo -u postgres createuser deploy -P
sudo -u postgres createdb rank_em -O deploy
```

Create a deploy user and grant sudo access
```bash
sudo useradd -m -s /bin/bash deploy
sudo bash -c 'echo "deploy ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/deploy'
sudo -u deploy bash -c 'echo -e "export DATABASE_URL=postgresql://deploy:PASSWORD@localhost/rank_em\n$(cat /home/deploy/.bashrc)" > /home/deploy/.bashrc'
```

Create folder to untar into
```bash
sudo -u deploy mkdir /home/deploy/rank_em
```

Setup a systemd file for your application
Edit and copy in systemd.example (replacing PASSWORD)
```bash
sudo vim /etc/systemd/system/rank_em.service
sudo systemctl daemon-reload
sudo systemctl enable rank_em
```

Copy in your SSH keys to the deploy user
```bash
sudo -u deploy mkdir /home/deploy/.ssh/
sudo -u deploy touch /home/deploy/.ssh/authorized_keys
sudo -u deploy chmod 0600 /home/deploy/.ssh/authorized_keys
```

add your ssh keys to this file
```bash
sudo -u deploy vim /home/deploy/.ssh/authorized_keys
```

Setup nginx and certbot
```bash
sudo apt install nginx certbot python-certbot-nginx -y
sudo rm /etc/nginx/sites-enabled/default
# Copy in the nginx config below and edit for your domain/app
sudo vim /etc/nginx/sites-enabled/rank_em
# Verify the configuration
sudo nginx -t
sudo systemctl reload nginx
# Follow certbot to configure HTTPS, this assumes your DNS is configured
sudo certbot --nginx
```

Enable the firewall
```bash
sudo ufw allow ssh
sudo ufw allow https
sudo ufw allow http
sudo ufw enable
```
