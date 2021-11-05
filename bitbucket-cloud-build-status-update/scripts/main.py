import json, requests, google.auth, base64, os
from google.cloud.devtools import cloudbuild_v1

def getBuildDesc(eventData):
  credentials, project_id = google.auth.default()
  client = cloudbuild_v1.services.cloud_build.CloudBuildClient()
  build = client.get_build(project_id=eventData['projectId'], id=eventData['buildId'])
  return build

def getStatus(buildData):
  if str(buildData.status).__contains__('FAILURE'):
    return "FAILED"
  elif str(buildData.status).__contains__('WORKING'):
    return "INPROGRESS"
  else:
    return "SUCCESSFUL"
    
def buildStat(event, *content):
  trigger = json.loads(base64.b64decode(event['data']).decode('utf-8'))
  eventData = {
    'timeStamp' : trigger['timestamp'],
    'insertId' : trigger['insertId'],
    'buildId' : trigger['resource']['labels']['build_id'],
    'projectId' : trigger['resource']['labels']['project_id']
  }
  buildData = getBuildDesc(eventData)
  logQuery = 'timestamp="%(timeStamp)s" insertId="%(insertId)s"?project="%(projectId)s"' % eventData
  logURL = 'https://console.cloud.google.com/logs/query;query=' + logQuery.replace('=', '%3D').replace(' ', '%20')
  payload = json.dumps({
    "key": "BUILD",
    "state": getStatus(buildData),
    "url": logURL
  })
  headers = {
    'Content-Type': 'application/json'
  }
  bitbucketData = {
    'owner': os.environ.get('OWNER'),
    'repo_slug': os.environ.get('REPO'),
    'revision': buildData.source.repo_source.commit_sha
  }
  api_url = ('https://api.bitbucket.org/2.0/repositories/%(owner)s/%(repo_slug)s/commit/%(revision)s/statuses/build' % bitbucketData)
  requests.request("post", api_url, auth=(os.environ.get('USERNAME'), os.environ.get('PASSWORD')), headers=headers, data=payload)
