Puppet::Type.newtype(:zabbix_host) do
  ensurable do
    defaultvalues
    defaultto :present
  end

  def initialize(*args)
    super

    # Migrate group to groups
    return if self[:group].nil?
    self[:groups] = self[:group]
    delete(:group)
  end

  def munge_boolean(value)
    case value
    when true, 'true', :true
      true
    when false, 'false', :false
      false
    else
      raise(Puppet::Error, 'munge_boolean only takes booleans')
    end
  end

  newparam(:hostname, namevar: true) do
    desc 'FQDN of the machine.'
  end

  newproperty(:id) do
    desc 'Internally used hostid'

    validate do |_value|
      raise(Puppet::Error, 'id is read-only and is only available via puppet resource.')
    end
  end

  newproperty(:interfaceid) do
    desc 'Internally used identifier for the host interface'

    validate do |_value|
      raise(Puppet::Error, 'interfaceid is read-only and is only available via puppet resource.')
    end
  end

  newproperty(:ipaddress) do
    desc 'The IP address of the machine running zabbix agent.'
  end

  newproperty(:use_ip, boolean: true) do
    desc 'Using ipadress instead of dns to connect.'

    newvalues(true, false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:port) do
    desc 'The port that the zabbix agent is listening on.'
    def insync?(is)
      is.to_i == should.to_i
    end
  end

  newproperty(:group) do
    desc 'Deprecated! Name of the hostgroup.'

    validate do |_value|
      Puppet.warning('Passing group to zabbix_host is deprecated and will be removed. Use groups instead.')
    end
  end

  newproperty(:groups, array_matching: :all) do
    desc 'An array of groups the host belongs to.'
    def insync?(is)
      is.sort == should.sort
    end
  end

  newparam(:group_create, boolean: true) do
    desc 'Create hostgroup if missing.'

    newvalues(true, false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:templates, array_matching: :all) do
    desc 'List of templates which should be loaded for this host.'
    def insync?(is)
      is.sort == should.sort
    end
  end

  newproperty(:proxy) do
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

  autorequire(:file) { '/etc/zabbix/api.conf' }

  validate do
    raise(_('The properties group and groups are mutually exclusive.')) if self[:group] && self[:groups]
  end

  newparam(:tls_connect) do
    desc 'If TLS is used from host. 1 = no encryption ; 2 = PSK ; 4 = certificate.'
  end

  newparam(:tls_accept) do
    desc 'If TLS is used to host. 1 = no encryption ; 2 = PSK ; 4 = certificate.'
  end

end