#!/usr/bin/env python

from keystoneauth1.identity import v3
from keystoneauth1 import session
from novaclient import client

auth = v3.Password(
    	username='HEC_USER_NAME',
    	password='HEC_USER_PASSWD',
    	auth_url='https://iam.cn-north-1.myhwclouds.com/v3',
    	user_domain_name='HEC_USER_NAME',
    	project_domain_name='HEC_USER_NAME'
)
sess = session.Session(auth=auth, verify=False)
nova = client.Client("2.1", session=sess)
print nova.servers.list()
