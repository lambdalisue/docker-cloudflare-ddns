# docker-update-cloudflare-dns

A docker image to update DNS record in Cloudflare.

Use the following environment variables to regulate the behavior.

```
ZONE=example.com
DNSRECORD=www.example.com
AUTH_EMAIL=johndoe@example.com
AUTH_KEY=...
```

# Thanks

The main script has copied from the following
https://gist.github.com/Tras2/cba88201b17d765ec065ccbedfb16d9a
