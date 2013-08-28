#
# Albert, first monkey shot into space
#


Ironfan.cluster 'albert' do
  cloud(:ec2) do
    availability_zones ['us-east-1c']
    flavor              't1.micro'
    backing             'ebs'
    image_name          'ironfan-precise'
    bootstrap_distro    'ubuntu12.04-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals
  end

  environment           :development

  role                  :systemwide,    :first
  cloud(:ec2).security_group :systemwide
  role                  :ssh
  cloud(:ec2).security_group(:ssh).authorize_port_range 22..22
  role                  :set_hostname

  recipe                'log_integration::logrotate'

  role                  :volumes
  role                  :package_set,   :last
  role                  :minidash,      :last

  role                  :org_base
  role                  :org_users
  role                  :org_final,     :last

  facet :test do
    cloud(:ec2).elastic_ip '107.20.185.157'
  end
end