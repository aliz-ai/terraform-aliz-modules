import json, requests, google.auth, base64, os
from google.cloud.devtools import cloudbuild_v1
from google.cloud import secretmanager

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

def getSecret(projectId, secretId, versionId):
  client = secretmanager.SecretManagerServiceClient()
  name = f"projects/{projectId}/secrets/{secretId}/versions/{versionId}"
  response = client.access_secret_version(request={"name": name})
  return response.payload.data.decode("UTF-8")

def getToken(key, secret):
  headers = {
    'Content-Type': 'application/x-www-form-urlencoded'
  }
  data = "grant_type=client_credentials"
  authApiUrl = "https://bitbucket.org/site/oauth2/access_token"
  res = requests.request("post", authApiUrl, auth=(key, secret), headers=headers, data=data)
  auth = json.loads(res.content.decode('UTF-8'))
  return auth['access_token']

def buildStat(event, *content):
  trigger = json.loads(base64.b64decode(event['data']).decode('utf-8'))
  eventData = {
    'buildId' : trigger['resource']['labels']['build_id'],
    'projectId' : trigger['resource']['labels']['project_id']
  }
  buildData = getBuildDesc(eventData)
  buildURL = 'https://console.cloud.google.com/cloud-build/builds?project=%(projectId)s' % eventData
  payload = json.dumps({
    "key": "BUILD",
    "state": getStatus(buildData),
    "url": buildURL
  })
  key = getSecret(eventData['projectId'], os.environ.get('KEY'), 'latest')
  secret = getSecret(eventData['projectId'], os.environ.get('SECRET'), 'latest')
  token = getToken(key, secret)
  headers = {
    'Content-Type': 'application/json',
    'Authorization': "Bearer %s" % token
  }
  bitbucketData = {
    'owner': os.environ.get('OWNER'),
    'repo_slug': os.environ.get('REPO'),
    'revision': buildData.source.repo_source.commit_sha
  }
  api_url = ('https://api.bitbucket.org/2.0/repositories/%(owner)s/%(repo_slug)s/commit/%(revision)s/statuses/build' % bitbucketData)
  requests.request("post", api_url, headers=headers, data=payload)
