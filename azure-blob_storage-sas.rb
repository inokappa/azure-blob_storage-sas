#!/usr/bin/env ruby

require "azure"
require "base64"
require "openssl"
require "addressable/uri"
require 'open-uri'

Azure.config.storage_access_key = ENV['STORAGE_ACCOUNT_KEY']
Azure.config.storage_account_name = ENV["STORAGE_ACCOUNT_NAME"]
$storage_uri = "https://" + Azure.config.storage_account_name + ".blob.core.windows.net"
$container_name  = ENV["STORAGE_CONTAINER_NAME"]
start_time = Time.now.utc.iso8601
end_time = (Time.now + ENV['EXPIRE_TIME'].to_i).utc.iso8601
content = ENV['CONTENT']

#
# Create Signature
#
def create_signature(path, resource, permissions, start, expiry, identifier = '')
  canonicalizedResource = "/" + Azure.config.storage_account_name + "/#{path}"

  stringToSign  = []
  stringToSign << permissions
  stringToSign << start
  stringToSign << expiry
  stringToSign << canonicalizedResource
  stringToSign << identifier
  stringToSign = stringToSign.join("\n")

  signature    = OpenSSL::HMAC.digest('sha256', Base64.strict_decode64(Azure.config.storage_access_key), stringToSign.encode(Encoding::UTF_8))
  signature    = Base64.strict_encode64(signature)

  return signature
end

#
# Create URL + Signed Query String
#
def createSignedQueryString(path, query_string, resource, permissions, start, expiry, identifier = '')
  base = $storage_uri
  uri  = Addressable::URI.new

  parts       = {}
  parts[:st]  = URI.unescape(start) unless start == ''
  parts[:se]  = URI.unescape(expiry)
  parts[:sr]  = URI.unescape(resource)
  parts[:sp]  = URI.unescape(permissions)
  parts[:si]  = URI.unescape(identifier) unless identifier == ''
  parts[:sig] = URI.unescape( create_signature(path, resource, permissions, start, expiry) )

  uri.query_values = parts
  return "#{base}/#{path}?#{uri.query}"
end

#
# Create Instance
#
blob_service = Azure::BlobService.new

#
# Upload blob
#
blob = blob_service.create_block_blob($container_name,"bar", content)

#
# Output signed queriy and url
#
sas_uri = createSignedQueryString($container_name + "/#{blob.name}", nil, 'b', 'r', start_time, end_time)

#
# Access to SAS URI
#
res = open(sas_uri, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})
puts "SAS URI              : " + sas_uri
puts "Start Time           : " + start_time
puts "End Time             : " + end_time
puts "Response Status Code : " + res.status[0]
puts "Response Body        : " + res.read
