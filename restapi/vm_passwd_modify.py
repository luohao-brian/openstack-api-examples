#!/usr/bin/python

import os
import pycurl,StringIO
import json
import time
import paramiko  

SERVER_ID = ''
PASSWD_SERVER_ID = ''
PASSWD_SERVER_IP = ''
PASSWD_SERVER_PW = ''
NAME = ''
PASSWD = ''
CHANGE_PASSWD = ''

AUTH_PARAMS = {
  "auth": {
    "identity": {
      "methods": [
        "password"
      ],
      "password": {
        "user": {
          "name": NAME,
          "password": PASSWD,
          "domain": {
            "name": NAME
          }
        }
      }
    },
   "scope": {
      "project": {
        "name": "cn-north-1"
      }
    }
  }
}

VOLUME_ATTACH_BODY =''' {
    "volumeAttachment": {
         "volumeId": "{volumeId}",
         "device": "{device}"
    }
}'''

def get_token(inf):
    inf_list = inf.split('\n')
    for temp in inf_list:
        if 'X-Subject-Token' in temp: 
            return temp.split(': ')[1].strip()


def get_project_id(inf):
    data = json.loads(inf)
    return data['token']['project']['id']


def get_system_volume(inf):
    data = json.loads(inf)
    for temp in data['volumeAttachments']:
        if temp['device'] == '/dev/sda':
            return temp['id']


def curl_post_function(b, head, url, post_fields, header=[]):
    default_header = ['Content-Type: application/json']
    header_list = default_header + header
    c = pycurl.Curl()
    c.setopt(pycurl.URL, url)
    c.setopt(pycurl.WRITEFUNCTION, b.write)
    c.setopt(pycurl.HTTPHEADER, header_list)
    c.setopt(pycurl.CUSTOMREQUEST, "POST")
    c.setopt(pycurl.POSTFIELDS, post_fields)
    c.setopt(pycurl.HEADERFUNCTION, head.write)
    c.perform()
    c.close()
    return head.getvalue(), b.getvalue()


def curl_get_function(b, url, token):
    c = pycurl.Curl()
    c.setopt(pycurl.URL, url)
    c.setopt(pycurl.WRITEFUNCTION,b.write)
    c.setopt(pycurl.HTTPHEADER,['X-Auth-Token: {0}'.format(token)])
    c.setopt(pycurl.CUSTOMREQUEST,"GET")
    c.perform()
    c.close()
    return b.getvalue()


def curl_delete_function(b, url, header=[]):
    default_header = ['Content-Type: application/json']
    header_list = default_header + header
    c = pycurl.Curl()
    c.setopt(pycurl.URL, url)
    c.setopt(pycurl.WRITEFUNCTION, b.write)
    c.setopt(pycurl.HTTPHEADER, header_list)
    c.setopt(pycurl.CUSTOMREQUEST, "DELETE")
    c.perform()
    return b.getvalue()


def get_job_status(token, project_id, job_id):
    b = StringIO.StringIO()
    url = 'https://ecs.cn-north-1.myhwclouds.com/v1/{project_id}/jobs/{job_id}'.format(project_id=project_id, job_id=job_id)
    header = ['X-Auth-Token: {0}'.format(token)]
    body_inf = curl_get_function(b, url, token)
    b.close()
    return body_inf


def get_job_finish(token, project_id, job_id):
    result = get_job_status(token, project_id, job_id)
    data = json.loads(result)
    if data['status'] == "SUCCESS":
        return True
    elif data['status'] in ["RUNNING","INIT"]:
        time.sleep(3)
        get_job_finish(token, project_id, job_id)
    elif data['status'] == "FAILED":
        print data
        return False
    else:
        print data
	return False 

def get_token_information():
    b = StringIO.StringIO()
    head = StringIO.StringIO()
    url = 'https://iam.cn-north-1.myhwclouds.com/v3/auth/tokens'
    head_inf, body_inf = curl_post_function(b, head, url, str(AUTH_PARAMS))
    b.close()
    head.close()
    token = get_token(head_inf)
    project_id = get_project_id(body_inf)
    return token, project_id


def get_vm_volume_attachment(token, project_id):
    b = StringIO.StringIO()
    url = 'https://ecs.cn-north-1.myhwclouds.com/v2/{project_id}/servers/{server_id}/os-volume_attachments'.format(project_id=project_id, server_id=SERVER_ID)
    body_inf = curl_get_function(b, url, token)
    b.close()
    return body_inf


def excute_vm_stop(token, project_id):
    b = StringIO.StringIO()
    head = StringIO.StringIO()
    url = 'https://ecs.cn-north-1.myhwclouds.com/v2/{project_id}/servers/{server_id}/action'.format(project_id=project_id, server_id=SERVER_ID)
    header = ['X-Auth-Token: {0}'.format(token)]
    head_inf, body_inf = curl_post_function(b, head, url, '{ "os-stop": {}}', header)
    b.close()
    head.close()


def excute_vm_volume_detach(token, project_id, volume_id, server_id):
    b = StringIO.StringIO()
    url = 'https://ecs.cn-north-1.myhwclouds.com/v1/{project_id}/cloudservers/{server_id}/detachvolume/{volume_id}'.format(project_id=project_id, server_id=server_id, volume_id=volume_id)
    header = ['X-Auth-Token: {0}'.format(token)]
    body_inf = curl_delete_function(b, url, header)
    b.close()
    print body_inf
    return body_inf


def excute_vm_volume_attach(token, project, volume_id, server_id, device):
    b = StringIO.StringIO()
    head = StringIO.StringIO()
    url = 'https://ecs.cn-north-1.myhwclouds.com/v1/{project_id}/cloudservers/{server_id}/attachvolume'.format(project_id=project_id, server_id=server_id)
    header = ['X-Auth-Token: {0}'.format(token)]
    post_body = VOLUME_ATTACH_BODY.replace('{device}', device).replace('{volumeId}', str(volume_id))
    head_inf, body_inf = curl_post_function(b, head, url, post_body, header)
    b.close()
    head.close()
    print body_inf
    return body_inf


def sshclient_execmd(hostname, port, username, password, execmd):   
    s = paramiko.SSHClient()  
    s.set_missing_host_key_policy(paramiko.AutoAddPolicy())  
    s.connect(hostname=hostname, port=port, username=username, password=password)  
    stdin, stdout, stderr = s.exec_command (execmd)  
    stdin.write("Y")  # Generally speaking, the first connection, need a simple interaction.  
    print stdout.read()  
    s.close() 


if __name__ == "__main__":
    print "step1: get token and project id"
    token, project_id = get_token_information()
    #print "token:{0}".format(token)
    #print "project_id:{0}".format(project_id)

    print "step2: stop vm"
    excute_vm_stop(token, project_id)

    print "step3: get vm system volume id"
    inf = get_vm_volume_attachment(token, project_id)
    system_volume_id = get_system_volume(inf)
    print "system_volume_id: {0}".format(system_volume_id)    

    print "step4: detach system volume"
    inf = excute_vm_volume_detach(token, project_id, system_volume_id, SERVER_ID)
    data = json.loads(inf)
    job_id = data['job_id']

    print "waiting for job {0} finish...".format(job_id)
    get_job_finish(token, project_id, job_id)

    print "step5: attach volume to passwd server"
    inf = excute_vm_volume_attach(token, project_id, system_volume_id, PASSWD_SERVER_ID, '/dev/sdb')
    data = json.loads(inf)
    job_id = data['job_id']

    print "waiting for job {0} finish...".format(job_id)
    get_job_finish(token, project_id, job_id)

    print "step6: change passwd"
    time.sleep(10)
    sshclient_execmd(PASSWD_SERVER_IP, 22, 'root', PASSWD_SERVER_PW, "/root/changepasswd.sh {0} /dev/xvdb".format(CHANGE_PASSWD))

    print "step7: detach volume from password server"
    time.sleep(10)
    inf = excute_vm_volume_detach(token, project_id, system_volume_id, PASSWD_SERVER_ID)
    data = json.loads(inf)
    job_id = data['job_id']

    print "waiting for job {0} finish...".format(job_id)
    get_job_finish(token, project_id, job_id)

    print "step8: attach volume to server"
    time.sleep(10)
    inf = excute_vm_volume_attach(token, project_id, system_volume_id, SERVER_ID, '/dev/sda')
    data = json.loads(inf)
    job_id = data['job_id']
    
    print "waiting for job {0} finish...".format(job_id)
    get_job_finish(token, project_id, job_id)
    
    print "SUCCESS"
