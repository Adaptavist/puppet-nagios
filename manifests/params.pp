# Class: nagios::params
#
# Parameters for and from the nagios module.
#
class nagios::params {

  $libdir = $::architecture ? {
    'x86_64' => 'lib64',
    'amd64'  => 'lib64',
    default  => 'lib',
  }


  $nrpe_command   = '$USER1$/check_nrpe -H $HOSTADDRESS$'
  $nrpe_options   = '-t 15'


  $nagios_user    = 'nagios'
  $nagios_group   = 'nagios'
  $nrpe_user      = 'nrpe'
  $nrpe_group     = 'nrpe'

  # Optional plugin packages, to be realized by tag where needed
  # Note: We use tag, because we can't use alias for 2 reasons :
  # * http://projects.puppetlabs.com/issues/4459
  # * The value of $alias can't be the same as $name
  $nagios_plugins_packages = [
    'nagios-plugins-disk',
    'nagios-plugins-file_age',
    'nagios-plugins-http',
    'nagios-plugins-ide_smart',
    'nagios-plugins-ifstatus',
    'nagios-plugins-linux_raid',
    'nagios-plugins-load',
    'nagios-plugins-log',
    'nagios-plugins-mailq',
    'nagios-plugins-mysql',
    'nagios-plugins-ntp',
    'nagios-plugins-perl',
    'nagios-plugins-pgsql',
    'nagios-plugins-procs',
    'nagios-plugins-sensors',
    'nagios-plugins-swap',
    'nagios-plugins-users',
  ]

  case $::operatingsystem {
    'RedHat', 'Fedora', 'CentOS', 'Scientific', 'Amazon': {
      $nrpe_package       = [ 'nrpe', 'nagios-plugins' ]
      $nrpe_service       = 'nrpe'
      $nrpe_pid_file      = hiera('nagios::params::nrpe_pid_file','/var/run/nrpe.pid')
      $nrpe_cfg_dir       = hiera('nagios::params::nrpe_cfg_dir','/etc/nrpe.d')
      $plugin_dir         = hiera('nagios::params::plugin_dir',"/usr/${libdir}/nagios/plugins")
      $pid_file           = hiera('nagios::params::pid_file','/var/run/nagios.pid')
      $megaclibin         = '/usr/sbin/MegaCli'
      $perl_memcached     = 'perl-Cache-Memcached'
      @package { $nagios_plugins_packages:
        ensure => installed,
        tag    => $name,
      }
      $apache_user = 'apache'
      $nagios_service = 'nagios'
      $nagios_package = 'nagios'
      $nagios_home    = '/etc/nagios'
      $system_service = '/sbin/service'
      # nrpe
      $nrpe_cfg_file  = '/etc/nagios/nrpe.cfg'
      $nagios_plugins = [
        'nagios-plugins-dhcp',
        'nagios-plugins-dns',
        'nagios-plugins-icmp',
        'nagios-plugins-ldap',
        'nagios-plugins-nrpe',
        'nagios-plugins-ping',
        'nagios-plugins-smtp',
        'nagios-plugins-snmp',
        'nagios-plugins-ssh',
        'nagios-plugins-tcp',
      ]
    }
    'Gentoo': {
      $nrpe_package       = [ 'net-analyzer/nrpe' ]
      $nrpe_package_alias = 'nrpe'
      $nrpe_service       = 'nrpe'
      $nrpe_pid_file      = '/run/nrpe.pid'
      $nrpe_cfg_dir       = '/etc/nagios/nrpe.d'
      $plugin_dir         = "/usr/${libdir}/nagios/plugins"
      $pid_file           = '/run/nagios.pid'
      $megaclibin         = '/opt/bin/MegaCli'
      $perl_memcached     = 'dev-perl/Cache-Memcached'
      # No package splitting in Gentoo
      @package { 'net-analyzer/nagios-plugins':
        ensure => installed,
        tag    => $nagios_plugins_packages,
      }
      $nagios_service = 'nagios'
      $nagios_package = 'nagios'
      $nagios_home    = '/etc/nagios'
      $system_service = '/sbin/service'
      $apache_user = 'apache'
      # nrpe
      $nrpe_cfg_file  = '/etc/nagios/nrpe.cfg'
      $nagios_plugins = [
        'nagios-plugins-dhcp',
        'nagios-plugins-dns',
        'nagios-plugins-icmp',
        'nagios-plugins-ldap',
        'nagios-plugins-nrpe',
        'nagios-plugins-ping',
        'nagios-plugins-smtp',
        'nagios-plugins-snmp',
        'nagios-plugins-ssh',
        'nagios-plugins-tcp',
      ]
    }
    'Debian': {
      $nrpe_package       = [ 'nagios-nrpe-server' ]
      $nrpe_package_alias = 'nrpe'
      $nrpe_service       = 'nagios-nrpe-server'
      $nrpe_pid_file      = hiera('nagios::params::nrpe_pid_file','/var/run/nagios/nrpe.pid')
      $nrpe_cfg_dir       = hiera('nagios::params::nrpe_cfg_dir','/etc/nagios/nrpe.d')
      $plugin_dir         = hiera('nagios::params::plugin_dir','/usr/lib/nagios/plugins')
      $pid_file           = hiera('nagios::params::pid_file','/var/run/nagios/nagios.pid')
      $megaclibin         = '/opt/bin/MegaCli'
      $perl_memcached     = 'libcache-memcached-perl'
      # No package splitting in Debian
      @package { 'nagios-plugins':
        ensure => installed,
        tag    => $nagios_plugins_packages,
      }
      $nagios_service = 'nagios'
      $nagios_package = 'nagios'
      $nagios_home    = '/etc/nagios'
      $system_service = '/sbin/service'
      $apache_user = 'www-data'
      # nrpe
      $nrpe_cfg_file  = '/etc/nagios/nrpe.cfg'
      $nagios_plugins = [
        'nagios-plugins-dhcp',
        'nagios-plugins-dns',
        'nagios-plugins-icmp',
        'nagios-plugins-ldap',
        'nagios-plugins-nrpe',
        'nagios-plugins-ping',
        'nagios-plugins-smtp',
        'nagios-plugins-snmp',
        'nagios-plugins-ssh',
        'nagios-plugins-tcp',
      ]
    }
    'Ubuntu': {
      $nrpe_package       = [ 'nagios-nrpe-server' ]
      $nrpe_package_alias = 'nrpe'
      $nrpe_service       = 'nagios-nrpe-server'
      $nrpe_pid_file      = hiera('nagios::params::nrpe_pid_file','/var/run/nagios3/nrpe.pid')
      $nrpe_cfg_dir       = hiera('nagios::params::nrpe_cfg_dir','/etc/nagios3/nrpe.d')
      $plugin_dir         = hiera('nagios::params::plugin_dir','/usr/lib/nagios3/plugins')
      $pid_file           = hiera('nagios::params::pid_file','/var/run/nagios3/nagios.pid')
      $megaclibin         = '/opt/bin/MegaCli'
      $perl_memcached     = 'libcache-memcached-perl'
      # No package splitting in Debian
      @package { 'nagios-plugins':
        ensure => installed,
        tag    => $nagios_plugins_packages,
      }
      $nagios_service = 'nagios3'
      $nagios_package = 'nagios3'
      $nagios_home    = '/etc/nagios3'
      $system_service = '/usr/sbin/service'
      $apache_user = 'www-data'
      # nrpe
      $nrpe_cfg_file  = '/etc/nagios3/nrpe.cfg'
      $nagios_plugins = [
        'nagios-nrpe-plugin',
        'nagios-dhcp-plugins',
        'nagios-dns-plugins',
        'nagios-icmp-plugins',
        'nagios-ldap-plugins',
        'nagios-ping-plugins',
        'nagios-smtp-plugins',
        'nagios-snmp-plugins',
        'nagios-ssh-plugins',
        'nagios-tcp-plugins',
      ]
    }
    default: {
      $nrpe_package       = [ 'nrpe', 'nagios-plugins' ]
      $nrpe_service       = 'nrpe'
      $nrpe_pid_file      = hiera('nagios::params::nrpe_pid_file','/var/run/nrpe.pid')
      $nrpe_cfg_dir       = hiera('nagios::params::nrpe_cfg_dir','/etc/nagios/nrpe.d')
      $plugin_dir         = hiera('nagios::params::plugin_dir','/usr/libexec/nagios/plugins')
      $pid_file           = hiera('nagios::params::pid_file','/var/run/nagios.pid')
      $megaclibin         = hiera('nagios::params::megaclibin','/usr/sbin/MegaCli')
      $perl_memcached     = hiera('nagios::params::perl_memcached','perl-Cache-Memcached')
      @package { $nagios_plugins_packages:
        ensure => installed,
        tag    => $name,
      }
      $nagios_service = 'nagios'
      $nagios_package = 'nagios'
      $nagios_home    = '/etc/nagios'
      $system_service = '/sbin/service'
      $apache_user = 'apache'
      # nrpe
      $nrpe_cfg_file  = '/etc/nagios/nrpe.cfg'
      $nagios_plugins = [
        'nagios-plugins-dhcp',
        'nagios-plugins-dns',
        'nagios-plugins-icmp',
        'nagios-plugins-ldap',
        'nagios-plugins-nrpe',
        'nagios-plugins-ping',
        'nagios-plugins-smtp',
        'nagios-plugins-snmp',
        'nagios-plugins-ssh',
        'nagios-plugins-tcp',
      ]
    }
  }

}
