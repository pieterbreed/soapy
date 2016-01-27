# how to render the letsencrypt certs

SSH onto the remote machine
Get the letsencrypt client, when I did it it was something like this:
```
cd ~
git clone <letsencrypt-url> ~/letsencrypt

```

So once that is done, I still needed to actually get the certs. this is how.

```
cd ~/letsencrypt
./letsencrypt-auto certonly --webroot -w /usr/share/nginx/html/ -d webserver.pb.co.za 
```
