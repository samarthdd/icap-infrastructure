import os
import subprocess
from elastic_utils import ElasticService
from uuid import uuid4
import time
from datetime import datetime, timezone

icap_host = os.getenv("ICAP_HOST" ,"54.155.107.189")
cmd = ["c-icap-client", "-i", icap_host, "-s", "info?view=text", "-req", "any"]

host = os.getenv("ELASTIC_HOST", "elastic.sahith.in")
port = os.getenv("ELASTIC_PORT" ,"9200")
username = os.getenv("ELASTIC_USER", "elastic")
password = os.getenv("ELASTIC_PASSWORD")
es = ElasticService(host, port, username, password)

index_name = "icap_monitor_test5"
es.create_index(index_name)

while(True):
    try:
        
        response = subprocess.check_output(cmd)
        response_list = str(response).split("\\n")

        stats = {}
        time_now = datetime.now(timezone.utc)
        stats['@timestamp'] = time_now
        for i in response_list:
            if "Running Servers Statistics" in i:
                current = "server_stats"
            elif "General Statistics" in i:
                current = "general_stats"
            elif "Service info Statistics" in i:
                current = "info_stats"
            elif "Service echo Statistics" in i:
                current = "echo_stats"
            elif "Service gw_rebuild Statistics" in i:
                current = "gw_rebuild_stats"
            if ":" in i:
                k, v = i.split(":")
                if k.strip() in ("REQUESTS", "REQMODS", "RESPMODS", 'Service gw_rebuild REQUESTS SCANNED', 
                         'Service gw_rebuild REBUILD FAILURES', 'Service gw_rebuild REBUILD ERRORS', 'Service gw_rebuild SCAN REBUILT',
                         'Service gw_rebuild UNPROCESSED', 'Service gw_rebuild UNPROCESSABLE'):
                    stats[k.strip()] = int(v.strip())
                else:
                    stats[k.strip()] = v.strip()

        guid = uuid4()
        es.create_doc(index_name, guid, stats)
    #     break
        time.sleep(3)

    except Exception as e:
        print(e)
