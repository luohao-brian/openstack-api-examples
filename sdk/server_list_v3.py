#!/usr/bin/env python
from keystoneauth1.identity import v3
from keystoneauth1 import session
from novaclient import client
from credentials import get_nova_credentials_v3

credentials = get_nova_credentials_v3()
auth = v3.Password(**credentials)
sess = session.Session(auth=auth, verify=False)
nova = client.Client("2.1", session=sess)
print nova.servers.list()
