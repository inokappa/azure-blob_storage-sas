## [DEMO] Generating Shared access signature(SAS) on Azure Blob Storage using Ruby

### How to Use

Required following environment variables.

- **STORAGE_ACCOUNT_KEY** Storage Account Key
- **STORAGE_ACCOUNT_NAME** Storage Account Name
- **STORAGE_CONTAINER_NAME** Storage Container Name
- **EXPIRE_TIME** SAS Expire time(sec)
- **CONTENT_KEY** Content Key
- **CONTENT** Content Value

Generating SAS by `docker run`.

```sh
$ docker run \
  --env 'STORAGE_ACCOUNT_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' \
  --env 'STORAGE_ACCOUNT_NAME=example' \
  --env 'STORAGE_CONTAINER_NAME=foo' \
  --env 'EXPIRE_TIME=30' \
  --env 'CONTENT_KEY=foo' \
  --env 'CONTENT=bar' \
inokappa/azure-storage-sas-ruby
```

output.

```sh
$ docker run \
> --env 'STORAGE_ACCOUNT_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' \
> --env 'STORAGE_ACCOUNT_NAME=example' \
> --env 'STORAGE_CONTAINER_NAME=foo' \
> --env 'EXPIRE_TIME=30' \
> --env 'CONTENT_KEY=foo' \
> --env 'CONTENT=bar' \
> inokappa/azure-blob_storage-sas
Unable to find image 'inokappa/azure-blob_storage-sas:latest' locally
latest: Pulling from inokappa/azure-blob_storage-sas
59607fef2cd4: Pull complete ================================================>]     32 B/32 BB
b1be5ad63ef9: Pull complete ================================================>] 9.299 MB/9.299 MBB
f715a8936c56: Pull complete ================================================>] 12.04 kB/12.04 kBB
04900379879d: Pull complete ================================================>] 1.085 kB/1.085 kBB
c90217d952ae: Pull complete ================================================>] 16.33 MB/16.33 MBB
fe85875ee451: Pull complete ================================================>] 194.8 kB/194.8 kBB
3422b4e3854d: Pull complete ================================================>]     32 B/32 BB
2c49f83e0b13: Already exists
4a5e6db8c069: Already exists
f972ade4c9d5: Already exists
a0b6d62d8b49: Already exists
8f45ce3be01e: Already exists
289272cba3d5: Already exists
8e840dd94b78: Already exists
bb92cab4f1d2: Already exists
9492043fccad: Already exists
88c67bfdcf7b: Already exists
6171e245fc5d: Already exists
ab3e12de2e0b: Already exists
f81328f6b62f: Already exists
5f9e00ef4885: Already exists
4d34bce3681f: Already exists
f4e06c3e530e: Already exists
97e3c96f87f8: Already exists
Digest: sha256:ac3e0f3e67ae5e839592b6e89235fab775cb9aaa8d1c9bfb356734aa6041ffa8
Status: Downloaded newer image for inokappa/azure-blob_storage-sas:latest
SAS URI              : https://example.blob.core.windows.net/foo/foo?se=2015-09-10T01%3A57%3A17Z&sig=0gSuqpGu0Qz6jOVKePOPRn98LZU88RShEqIbd2dJ6LU%3D&sp=r&sr=b&st=2015-09-10T01%3A56%3A47Z
Start Time           : 2015-09-10T01:56:47Z
End Time             : 2015-09-10T01:57:17Z
Response Status Code : 200
Response Body        : bar

$ curl "https://example.blob.core.windows.net/foo/foo?se=2015-09-10T01%3A57%3A17Z&sig=0gSuqpGu0Qz6jOVKePOPRn98LZU88RShEqIbd2dJ6LU%3D&sp=r&sr=b&st=2015-09-10T01%3A56%3A47Z"
bar
$ curl "https://example.blob.core.windows.net/foo/foo?se=2015-09-10T01%3A57%3A17Z&sig=0gSuqpGu0Qz6jOVKePOPRn98LZU88RShEqIbd2dJ6LU%3D&sp=r&sr=b&st=2015-09-10T01%3A56%3A47Z"
bar
$ curl "https://example.blob.core.windows.net/foo/foo?se=2015-09-10T01%3A57%3A17Z&sig=0gSuqpGu0Qz6jOVKePOPRn98LZU88RShEqIbd2dJ6LU%3D&sp=r&sr=b&st=2015-09-10T01%3A56%3A47Z"
・ｿ<?xml version="1.0" encoding="utf-8"?><Error><Code>AuthenticationFailed</Code><Message>Server failed to authenticate the request. Make sure the value of Authorization header is formed correctly including the signa ture.
RequestId:23fecd3f-0001-0043-286c-ebbefd000000
Time:2015-09-10T01:57:20.3584379Z</Message><AuthenticationErrorDetail>Signature not valid in the specified time frame: Start [Thu, 10 Sep 2015 01:56:47 GMT] - Expiry [Thu, 10 Sep 2015 01:57:17 GMT] - Current [Thu, 10 Sep 2015 01:57:20 GMT]</AuthenticationErrorDetail></Error>
```

