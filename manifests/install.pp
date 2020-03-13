class sympa::install {
  package {
    $sympa::package_name:
      ensure => 'present';
  }

  if $sympa::manage_db {
    if $db_host != 'localhost' {
      fail('Cannot manage a remote database.'
    }

    if $sympa::db_type != 'mysql' {
      fail('This module only supports management of mysql databases.')
    }

    class {
      'mysql': ;
    }
  }
}
