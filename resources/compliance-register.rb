default_action :register

resource_name 'compliance_register'

require 'json'
require 'uri'
require 'net/http'
require 'openssl'

property :compliance_url, :name_attribute => true, :required => true, :kind_of => String
property :compliance_user, :required => true, :kind_of => String
property :compliance_password, :required => true, :kind_of => String
property :compliance_environment, :required => true, :kind_of => String, :default => 'default'
property :node_name, :kind_of => String, :default => node['fqdn']
property :node_user, :required => true, :kind_of => String
property :node_password, :kind_of => String
property :node_key, :kind_of => String
property :login_method, :kind_of => String, :required => true, :default => 'ssh'




action :register do
  node_array = [ id: new_resource.node_name,
                 name: new_resource.node_name,
                 hostname: new_resource.node_name,
                 environment: new_resource.compliance_environment,
                 loginUser: new_resource.node_user,
                 loginMethod: new_resource.login_method,
                 loginKey: new_resource.node_key
               ]

  api_url = "https://#{new_resource.compliance_url}"
  api_user = new_resource.compliance_user
  api_pass = new_resource.compliance_password
  uri = URI.parse(api_url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  # Get the API token first
  request = Net::HTTP::Post.new('/api/oauth/token')
  request.add_field('grant_type', 'client_credentials')
  request.basic_auth api_user, api_pass
  response = http.request(request)
  response = JSON.parse(response.body)

  # Post the nodes to the Compliance Server
  request = Net::HTTP::Post.new("/api/owners/#{api_user}/nodes")
  request.add_field('Content-Type', 'application/json')
  request.basic_auth response['access_token'], ''
  request.body = node_array.to_json
  response = http.request(request)

  if response.code == '200'
    log '*** Successfully imported the nodes in Chef Compliance'
  else
    log "*** Failed to import, reason: #{response.body} code: #{response.code}"
  end

end
