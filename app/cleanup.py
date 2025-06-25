from tencentcloud.dnspod.v20210323 import models
from common import CERTBOT_DOMAIN, CERTBOT_AUTH_OUTPUT, DnspodClient
from re import search


def extract_record_id() -> int:
    record_id_regex = r"(?<=RecordId: )\d+"
    record_id_match = search(record_id_regex, CERTBOT_AUTH_OUTPUT)
    if not record_id_match:
        raise ValueError("RecordId was not found in the stdout of auth hook.")
    return int(record_id_match.group(0))


def cleanup():
    record_id = extract_record_id()
    req = models.DeleteRecordRequest()
    req.Domain = CERTBOT_DOMAIN
    req.RecordId = record_id
    DnspodClient().DeleteRecord(req)
    print(f"Successfully deleted DNS record, RecordId: {record_id}")


if __name__ == "__main__":
    cleanup()
