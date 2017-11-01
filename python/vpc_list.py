#!/usr/bin/env python

from neutronclient.v2_0 import client

neutroncli = client.Client(
    	username='USERNAME',
    	password='PASSWORD',
    	auth_url='https://iam.cn-north-1.myhwclouds.com/v3',
        tenant_name='hwcloud5967',
)

neutroncli.list_networks()
