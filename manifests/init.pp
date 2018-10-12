# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   puppet_mountpoint { 'namevar': }
#
# @param mountpoints
#   The name of the mountpoint being managed, used as $title in all managed resources to provide unique names.
# @param legacy_auth
#   Boolean value as weather to manage legacy auth false by default.
# @param path
#   valid path to the mountpoint directory, ensure mountpoint directory is accessable to pe-puppet user.
# @param auth_allow
#   Auth_allow setting for LEGACY auth
# @param auth_allow_ip
#   Auth_allow_ip setting for LEGACY auth
# @param hocon_allow
#   Hocon allow settings String or Array[String] Type
define puppet_mountpoint(
  String                          $mountpoint     = $title,
  Boolean                         $legacy_auth    = false,
  Stdlib::Absolutepath            $path,
  Optional                        $auth_allow     =  '*',
  Optional[Stdlib::IP::Address]   $auth_allow_ip  =  undef,
  Optional[Variant[String,Array]] $hocon_allow    =  '*',
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
    ensure       => present,
    path         => $fileserverconfig,
    section      => $mountpoint,
    setting      => 'path',
    value        => $path,
    indent_char  => "\t",
    indent_width => 1,
  }
  ini_setting { "File server setting ${mountpoint} allow":
    ensure       => present,
    path         => $fileserverconfig,
    section      => $mountpoint,
    setting      => 'allow',
    value        => '*',
    indent_char  => "\t",
    indent_width => 1,
    require      => Ini_setting["File server setting ${mountpoint} path"],
  }

}
