class sympa::config {
  service {
    $sympa::service_name:
      ensure => 'running',
      enable => true;
  }

  $listmasters_txt             = join($exim::listmasters, ',')
  $supported_lang_txt          = join($exim::supported_lang, ',')
  $remove_headers_txt          = join($exim::remove_headers, ',')
  $rfc2369_header_fields_txt   = join($exim::rfc2369_header_fields, ',')
  $use_blacklist_txt           = join($exim::use_blacklist, ',')
  $owner_domain_txt            = join($exim::owner_domain, ' ')
  $parsed_family_files_txt     = join($exim::parsed_family_files, ',')
  $dkim_add_signature_to_txt   = join($exim::dkim_add_signature_to, ',')
  $dkim_signature_apply_on_txt = join($exim::dkim_signature_apply_on, ',')

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
      content   => template('sympa/sympa.conf.erb')
      show_diff => false,
      notify    => $sympa::service_name;
  }
}
