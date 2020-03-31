class sympa::params {
  case $facts['os']['family'] {
    'RedHat': {
      $package_name          = ['sympa', 'sympa-httpd']
      $package_deps          = ['perl-IO-Socket-INET6']
      $tls_certificate_path  = '/etc/pki/tls/certs/sympa.pem'
      $tls_privatekey_path   = '/etc/pki/tls/private/sympa.key'
      $cafile                = '/etc/pki/tls/certs/ca-bundle.trust.crt'
      $dkim_private_key_path = '/etc/pki/tls/private/dkim.key'
    }
    default: {
      fail('Sorry, your OS is not currently supported by this module.')
    }
  }
}
