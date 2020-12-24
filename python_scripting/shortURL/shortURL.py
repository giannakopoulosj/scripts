import requests
import json

query_params = {'access_token': 'XXXXXXXXXXXXXXXXXXXXXXXXX',
                'longUrl': 'http://noc.tesyd.teimes.gr/eclas'} 

endpoint = 'https://api-ssl.bitly.com/v3/shorten'
response = requests.get(endpoint, params = query_params)

data = json.loads(response.content)
print type(data)
print data["data"]["url"]
