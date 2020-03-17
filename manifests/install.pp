class sympa::install {
  package {
    flatten([$sympa::package_name]):
      ensure => 'present';
  }
}
