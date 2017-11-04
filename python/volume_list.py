#!/usr/bin/env python

from keystoneauth1.identity import v3
from keystoneauth1 import session
from novaclient import client

auth = v3.Password(
    	username='USERNAME',
    	password='PASSWD',
    	auth_url='https://iam.cn-north-1.myhwclouds.com/v3',
    	user_domain_name='hwcloud5967',
    	project_domain_name='hwcloud5967',
        project_name='cn-north-1'
)
sess = session.Session(auth=auth, verify=True)

cinder = client.Client("2.1", session=sess)
print cinder.volumes.list()
