import requests
import hashlib
import hmac
from datetime import datetime, timezone

CONNECT_ID = "babenbeyond_peakapi_uat"
CONNECT_KEY = "pXiWTRSsZEHxWMnYJ9A5"
BASE_URL = "http://peakengineapidev.azurewebsites.net/api/v1"
timestamp = datetime.now(timezone.utc).strftime("%Y%m%d%H%M%S")

# เอกสารบอกว่า Time-Signature คือ HMAC-SHA1 ของ Time-Stamp โดยใช้ secret key เป็น connectID
signature = hmac.new(
    CONNECT_ID.encode("utf-8"),
    timestamp.encode("utf-8"),
    hashlib.sha1
).hexdigest()

url = f"{BASE_URL}/clienttoken"

headers = {
    "Content-Type": "application/json",
    "Time-Stamp": timestamp,
    "Time-Signature": signature,
}

payload = {
    "PeakClientToken": {
        "connectId": CONNECT_ID,
        "password": CONNECT_KEY
    }
}

resp = requests.post(url, json=payload, headers=headers, timeout=30)

print("status_code =", resp.status_code)
print(resp.text)