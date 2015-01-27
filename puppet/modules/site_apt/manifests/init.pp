class site_apt {

  $apt_config        = hiera('apt')
  $apt_url           = $apt_config['url']
  $apt_url_basic     = $apt_url['basic']
  $apt_url_security  = $apt_url['security']
  $apt_url_backports = $apt_url['backports']

  class { 'apt':
    custom_key_dir => 'puppet:///modules/site_apt/keys',
    debian_url     => $apt_url_basic,
    security_url   => $apt_url_security,
    backports_url  => $apt_url_backports
  }

  # enable http://deb.leap.se debian package repository
  include site_apt::leap_repo

  apt::apt_conf { '90disable-pdiffs':
    content => 'Acquire::PDiffs "false";';
  }

  include ::site_apt::unattended_upgrades

  apt::sources_list { 'secondary.list.disabled':
    content => template('site_apt/secondary.list');
  }

  apt::preferences_snippet { 'facter':
    release  => "${::lsbdistcodename}-backports",
    priority => 999
  }

  # All packages should be installed _after_ refresh_apt is called,
  # which does an apt-get update.
  # There is one exception:
  # The creation of sources.list depends on the lsb package

  File['/etc/apt/preferences'] ->
    Exec['refresh_apt'] ->
      Package <| ( title != 'lsb' ) |>
}
