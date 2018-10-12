# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   puppet_mountpoint { 'namevar': }
define puppet_mountpoint(
  String                        $mountpoint     = $title,
  Boolean                       $legacy_auth    = false,
  Stdlib::Absolutepath          $path           = ,
  Optional                      $auth_allow     =  '*',
  Optional[Stdlib::IP::Address] $auth_allow_ip  =  undef,
  Optional                      $hocon_allow    =  '*',
) {
  $fileserverconfig = $settings::fileserverconfig #/etc/puppetlabs/puppet/fileserver.conf
  $legacy_rest_auth = $settings::rest_authconfig # /etc/puppetlabs/puppet/auth.conf
  $hocon_auth       = '/etc/puppetlabs/puppetserver/conf.d/auth.conf'
  $hocon_hash  = { 'match-request' => {
                          'path' => "^/puppet/v3/file_(content|metadata)s?/${mountpoint}",
                          'type' => 'regex'
                          },
                        'allow'         => $hocon_allow,
                        'sort-order'    => '400',
                        'name'          => "Auth setting for ${mountpoint}"
            }
  if $legacy_auth {
    file_line { "Legacy Auth Path setting comment for ${mountpoint}":
      ensure             => present,
      path               => $legacy_rest_auth,
      line               => "# Allow limited access to files in ${path}",
      append_on_no_match => true,
    }
    file_line { "Legacy Auth Path setting for ${mountpoint}":
      ensure  => present,
      path    => $legacy_rest_auth,
      line    => "path ~ ^/file_(metadata|content)s?/${mountpoint}/",
      after   => "# Allow limited access to files in ${path}",
      require => file_line["Legacy Auth Path setting comment for ${mountpoint}"],
    }
    file_line { "Legacy Auth setting ${mountpoint}":
      ensure  => present,
      path    => $legacy_rest_auth,
      line    => "auth = yes #${mountpoint}",
      after   => "path ~ ^/file_(metadata|content)s?/${mountpoint}/",
      require => file_line["Legacy Auth Path setting for ${mountpoint}"],
    }
    if $auth_allow {
      file_line { "Legacy Allow setting ${mountpoint}":
        ensure  => present,
        path    => $legacy_rest_auth,
        line    => "allow ${auth_allow} #${mountpoint}",
        after   => "auth = yes #${mountpoint}",
        require => file_line["auth = yes #${mountpoint}"],
      }
    }
    if $auth_allow_ip{
      file_line { "Legacy Allow_IP setting ${mountpoint}":
        ensure  => present,
        path    => $legacy_rest_auth,
        line    => "allow ${auth_allow} #${mountpoint}",
        after   => "auth = yes #${mountpoint}",
        require => file_line["auth = yes #${mountpoint}"],
      }
    }
  }
  else {
    hocon_setting { "Auth setting for ${mountpoint}":
      ensure  => present,
      path    => $hocon_auth,
      setting => 'hash_setting',
      value   => $hocon_hash,
    }
  }
  ini_setting { "File server setting ${mountpoint} path":
    ensure  => present,
    path    => $fileserverconfig,
    section => $mountpoint,
    setting => 'path',
    value   => $path,
  }
  ini_setting { "File server setting ${mountpoint} allow":
    ensure  => present,
    path    => $fileserverconfig,
    section => $mountpoint,
    setting => 'allow',
    value   => '*',
    require => Ini_setting["File server setting ${mountpoint} path"]
  }

}
