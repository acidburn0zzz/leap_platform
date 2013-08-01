class leap_mx {

  $couchdb_admin_user = hiera('couchdb_admin_user')
  $couchdb_host     = 'localhost'
  $couchdb_port     = '4096'
  $couchdb_user     = $couchdb_admin_user['username']
  $couchdb_password = $couchdb_admin_user['password']

  #
  # USER AND GROUP
  #

  group { 'leap-mx':
    ensure    => present,
    allowdupe => false;
  }

  user { 'leap-mx':
    ensure    => present,
    allowdupe => false,
    gid       => 'leap-mx',
    home      => '/etc/leap',
    require   => Group['leap-mx'];
  }

  #
  # LEAP-MX CONFIG
  #

  file { '/etc/leap/mx.conf':
    content => template('leap_mx/mx.conf.erb'),
    owner   => 'leap-mx',
    group   => 'leap-mx',
    mode    => '0600',
    notify  => Service['leap-mx'];
  }

  #
  # LEAP-MX CODE
  #

  package { 'leap-mx':
    ensure => installed;
  }

  #
  # LEAP-MX DAEMON
  #

  service { 'leap-mx':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [ Package['leap-mx'] ];
  }
}
