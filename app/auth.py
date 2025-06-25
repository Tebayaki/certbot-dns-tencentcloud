from tencentcloud.dnspod.v20210323 import models
from common import (
    CERTBOT_DOMAIN,
    CERTBOT_VALIDATION,
    CERTBOT_REMAINING_CHALLENGES,
    DnspodClient,
)
from time import sleep


def auth():
    req = models.CreateTXTRecordRequest()
    req.Domain = CERTBOT_DOMAIN
    req.RecordLine = "默认"
    req.Value = CERTBOT_VALIDATION
    req.SubDomain = "_acme-challenge"

    resp = DnspodClient().CreateTXTRecord(req)
    print(f"Successfully created DNS record, RecordId: {resp.RecordId}. {CERTBOT_REMAINING_CHALLENGES} challenges remaining. Wait 30 seconds for the DNS record to take effect...")
    sleep(30)


if __name__ == "__main__":
    auth()
