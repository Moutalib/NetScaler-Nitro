#!/usr/bin/env ruby

# This script is an example for using a session cookie as an authentication token for further NetScaler Nitro requests

require 'rest-client'
$ns_box = '<netscaler ip'>

url_login = 'http://192.168.1.51/nitro/v1/config/login/'
url_ns_features = "http://192.168.1.51/nitro/v1/config/nsfeature?action=enable"

payload_ns_feature = '{"nsfeature":{"feature":["SSL","SSLVPN","IC","LB","REWRITE","CS"]}}'
payload_login = '{"login":{"username":"nsroot","password":"nsroot"}}'

headers_login =
	{
	'Content-Type' => 'application/vnd.com.citrix.netscaler.login+json',
	'Accept' => 'json'
	}

#catpure the cookie and pass the session cookie to the cookies variable.
login = RestClient.post(url_login,payload_login,headers_login)
cookies = login.cookies['NITRO_AUTH_TOKEN']


nitro_session_cookie = {} # create a empty hash
nitro_session_cookie['NITRO_AUTH_TOKEN'] = cookies

headers_ns_features =
   {
   'Content-Type' => 'application/vnd.com.citrix.netscaler.nsfeature+json',
   #'X-NITRO-USER' => 'nsroot', (only required when there is no session cookie to resend)
   #'X-NITRO-PASS' => 'secret_password',
   'Accept' => 'json'
}

#add_ns_features = RestClient.post(uri_ns_feautres,payload_ns_feature,headers_ns_feautres)
RestClient::Request.execute
(
   :method => :post,
   :url => url_ns_features,
   :payload => payload_ns_feature,
   :headers => headers_ns_features,
   :cookies => nitro_session_cookie
)
