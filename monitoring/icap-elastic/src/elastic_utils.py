from elasticsearch import Elasticsearch
import requests
import logging
import sys

log = logging.getLogger("icap:monitor")
log.setLevel(logging.INFO)
logging.basicConfig( stream=sys.stdout )


class ElasticService():

    def __init__(self, host, port, username, password):
        super().__init__()
        requests.packages.urllib3.disable_warnings()
        try:
            log.info(f"connecting to elastic on host: {host}")
            self.es = Elasticsearch(f"{host}:{port}", http_auth=(username, password), verify_certs=False)
            self.es.info()
        except Exception as e:
            log.error(e)
            raise

    def create_index(self, index_name):
        try:
            print("creating index if not exists")
            self.es.indices.create(index=index_name, ignore=400)
        except Exception as e:
            log.error(e)

    def create_doc(self, index_name, id, body):
        try:
            log.info("creating doc in elastic")
            self.es.create(index=index_name,id=id, body=body)
        except Exception as e:
            log.error(e)

    def delete_doc(self, index_name, id):
        try:
            log.info("deleting doc from elastic")
            self.es.delete(index=index_name,id=id)
        except Exception as e:
            log.error(e)

