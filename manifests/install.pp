class sympa::install {
  package {
    flatten([$sympa::package_name]):
      ensure => 'present';
  }

  ensure_packages($sympa::package_deps)
}
