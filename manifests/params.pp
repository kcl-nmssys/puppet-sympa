class sympa::params {
  case $facts['os']['family'] {
    'Debian': {
      $package_name          = 'sympa'
      $tls_certificate_path  = '/etc/ssl/sympa.pem'
      $tls_privatekey_path   = '/etc/ssl/sympa.key'
      $cafile                = '/etc/ssl/certs/ca-certificates.crt'
      $dkim_private_key_path = '/etc/ssl/private/dkim.key'
    }
    default: {
      fail('Sorry, your OS is not currently supported by this module.')
    }
  }
}
