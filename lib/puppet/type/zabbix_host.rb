Puppet::Type.newtype(:zabbix_host) do
  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:hostname, namevar: true) do
    desc 'FQDN of the machine.'
  end

  newparam(:ipaddress) do
    desc 'The IP address of the machine running zabbix agent.'
  end

  newparam(:use_ip) do
    desc 'Using ipadress instead of dns to connect. Is used by the zabbix-api command.'
  end

  newparam(:port) do
    desc 'The port that the zabbix agent is listening on.'
  end

  newproperty(:group) do
    desc 'Deprecated! Name of the hostgroup.'

    validate do |_value|
      Puppet.warning('Passing group to zabbix_host is deprecated and will be removed. Use groups instead.')
    end
  end

  newparam(:groups) do
    desc 'Name of the hostgroup.'
  end

  newparam(:group_create) do
    desc 'Create hostgroup if missing.'
  end

  newparam(:templates) do
    desc 'List of templates which should be loaded for this host.'
  end

  newparam(:proxy) do
    desc 'Whether it is monitored by an proxy or not.'
  end

  newparam(:zabbix_url) do
    desc 'The url on which the zabbix-api is available.'
  end

  newparam(:zabbix_user) do
    desc 'Zabbix-api username.'
  end

  newparam(:zabbix_pass) do
    desc 'Zabbix-api password.'
  end

  newparam(:apache_use_ssl) do
    desc 'If apache is uses with ssl'
  end

  newparam(:tls_connect) do
    desc 'If TLS is used from host. 1 = no encryption ; 2 = PSK ; 4 = certificate.'
  end

  newparam(:tls_accept) do
    desc 'If TLS is used to host. 1 = no encryption ; 2 = PSK ; 4 = certificate.'
  end

end