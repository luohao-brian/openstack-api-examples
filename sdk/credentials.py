#!/usr/bin/env python

import os
def get_nova_credentials_v3():
    d = {}
    d['username'] = os.environ['OS_USERNAME']
    d['password'] = os.environ['OS_PASSWORD']
    d['auth_url'] = os.environ['OS_AUTH_URL']
    d['project_name'] = os.environ['OS_TENANT_NAME']
    d['user_domain_name'] = os.environ['OS_USERNAME']
    return d
