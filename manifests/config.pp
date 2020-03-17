class sympa::config {
  $all_services = [$sympa::service_name, $sympa::wwservice_name]
  service {
    $all_services:
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

    [$sympa::queue, $sympa::queuemod, $sympa::queuedigest, $sympa::queueauth, $sympa::queueoutgoing, $sympa::queuesubscribe, $sympa::queuetopic, $sympa::queuebounce, $sympa::queuetask, $sympa::queueautomatic, $sympa::queuebulk, $sympa::viewmail_dir, $sympa::bounce_path, $sympa::arc_path]:
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
      notify    => Service[$all_services];

    '/etc/sysconfig/sympa':
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0444',
      source => 'puppet:///modules/sympa/sysconfig-sympa',
      notify => Service[$sympa::wwservice_name];

    '/etc/httpd/conf.d/sympa.conf':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      content => template('sympa/httpd-sympa.conf.erb');
  }

  if $sympa::aliases_program == 'postalias' {
    file {
      "${sympa::etc}/aliases.sympa.postfix":
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        content => template('sympa/aliases.sympa.postfix.erb'),
        notify  => Exec['Setup Sympa postfix aliases'];
    }

    exec {
      'Setup Sympa postfix aliases':
        user        => 'root',
        command     => "postalias hash:${sympa::etc}/aliases.sympa.postfix",
        path        => ['/sbin', '/usr/sbin'],
        refreshonly => true;
    }
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
        command     => 'sympa --health_check',
        path        => ['/bin', '/usr/bin'],
        refreshonly => true;
    }
  }
}
