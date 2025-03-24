import base64, os

with open(".env", "r") as f_in:
    lines = f_in.readlines()

with open(".env_encoded", "w") as f_out:
    for line in lines:
        kv = line.rstrip().split("=")
        bytes_kv = ("SECRET_" + kv[0], kv[1].encode('ascii'))
        f_out.write(bytes_kv[0] + '=' + base64.b64encode(bytes_kv[1]).decode('ascii') + "\n")
    with open(os.path.expanduser("~") + "/.pki/gcp/creds.json", "r") as json_in:
        f_out.write("SECRET_GCP_SERVICE_ACCOUNT=" + base64.b64encode(json_in.read().encode('ascii')).decode('ascii') + "\n")
