class sympa::install {
  package {
    $sympa::package_name:
      ensure => 'present';
  }
}
