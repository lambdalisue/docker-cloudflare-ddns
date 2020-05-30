# cloudflare-ddns

A docker image to periodically update DNS A record on CloudFlare DNS Service.

## Usage

```
docker run \
    -e API_KEY=xxxxxx \
    -e ZONE=example.com \
    -e SUBDOMAIN=subdomain \
    -e SCHEDULE="* * * * *" \
    lambdalisue/cloudflare-ddns
```

## Environment variables

| Name        | Description                                                                                            |
| ----------- | ------------------------------------------------------------------------------------------------------ |
| `API_KEY`   | Your CloudFlare scoped API token. **Required**                                                         |
| `ZONE`      | The DNS zone that DDNS update should be applied to. **Required**                                       |
| `SUBDOMAIN` | A subdomain of the `ZONE` to write DNS changes to. If this is not supplied the root zone will be used. |
| `SCHEDULE`  | A cron schedule expression (e.g. `* * * * *`) to execute DDNS updates                                  |

## Differences

- DNS record creation is not supported
- AAAA record (IPv6) is not supported
- Pulling IPs from iface is not supported

# Thanks

Originally the idea comes from
https://gist.github.com/Tras2/cba88201b17d765ec065ccbedfb16d9a.
And then I found
https://github.com/oznu/docker-cloudflare-ddns
but that's a bit too complicated for my case so manually forked to make simplified version.
