class sympa::config {
  service {
    $sympa::service_name:
      ensure => 'running',
      enable => true;
  }

  $listmaster_txt              = join($sympa::listmaster, ',')
  $supported_lang_txt          = join($sympa::supported_lang, ',')
  $remove_headers_txt          = join($sympa::remove_headers, ',')
  $rfc2369_header_fields_txt   = join($sympa::rfc2369_header_fields, ',')
  $use_blacklist_txt           = join($sympa::use_blacklist, ',')
  $owner_domain_txt            = join($sympa::owner_domain, ' ')
  $parsed_family_files_txt     = join($sympa::parsed_family_files, ',')
  $dkim_add_signature_to_txt   = join($sympa::dkim_add_signature_to, ',')
  $dkim_signature_apply_on_txt = join($sympa::dkim_signature_apply_on, ',')

  file {
    [$sympa::etc, $sympa::home]:
      ensure => 'directory',
      owner  => 'root',
      group  => 'sympa',
      mode   => '0750';

    [$sympa::spool, $sympa::var_dir]:
      ensure => 'directory',
      owner  => 'root',
      group  => 'sympa',
      mode   => '0751';

    [$sympa::queue]:
      ensure => 'directory',
      owner  => 'sympa',
      group  => 'sympa',
      mode   => '0751';

    $sympa::config_file:
      ensure    => 'present',
      owner     => 'root',
      group     => 'sympa',
      mode      => '0640',
      content   => template('sympa/sympa.conf.erb'),
      show_diff => false,
      notify    => Service[$sympa::service_name];
  }

  if $sympa::manage_db and $sympa::db_type == 'mysql' {
    mysql::db {
      $sympa::db_name:
        host     => $sympa::db_host,
        user     => $sympa::db_user,
        password => $sympa::db_passwd,
        grant    => ['ALL'],
        notify   => Exec['Initialise Sympa database'];
    }

    exec {
      'Initialise Sympa database':
        user        => 'root',
        command     => '/usr/bin/sympa --health_check',
        refreshonly => true;
    }
  }
}
