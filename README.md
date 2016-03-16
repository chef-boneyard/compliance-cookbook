compliance-cookbook
========================

The compliance-cookbook is a library cookbook which provides a resource for self-registering
nodes to Chef Compliance.

Usage
-----
Place a dependency on the compliance-cookbook in your cookbook's metadata.rb
```ruby
depends 'compliance-cookbook'
```
Then, in a recipe:

```ruby
compliance_register "IP_OR_HOSTNAME" do
  compliance_user "COMP_USER"
  compliance_password "COMP_PASSWORD"
  node_user "NODE_USER"
end
```
Resource Overview
------------------
The `compliance_register` resource abstracts the tasks required to register the node via the compliance api.

#### Parameters

- `compliance_url`(*Required*) - The IP address or Hostname of the Chef Compliance server the node will be registered to. Defaults to the name of the resource.

- `compliance_user`(*Required*) - The user account required to log into the Chef Compliance server.

- `compliance_password`(*Required*) - The password associated with the *compliance_user* account.

- `node_user`(*Required*) - The node's user account to be used by Chef Compliance to connect to the node.

- `node_password`(*Either node_password, or node_key is required for the Chef Compliance Server to connect*) - The node's user account's password to be used by Chef Compliance to authenticate to the node.

- `node_key`(*Either node_password, or node_key is required for the Chef Compliance Server to connect*) - The key to be used by the Chef Compliance server to authenticate to the node. This should be pre-generated on the Chef Compliance server beforehand.

- `compliance_environment` - The Chef Compliance environment to associate this node to. Default value is: "*default*"

- `node_name` - The name the node should be registered as. Default is the FQDN of the node.

- `login_method` - The method used to by the Chef Compliance server to connect to the node, either ***ssh***, or ***winrm*** Default is ***ssh***.
