class abinbev_cis_suid_rem (
  String            $system_environment       = 'default',
  Boolean           $pe_environment           = false,
  Array            $whitelist                = [],
  Array            $blacklist                = [],
  Array            $folders_to_restrict      = [],
  Boolean             $remove_from_unknown     = true,
  Boolean             $dry_run_on_unknown      = false,

) {

  # Prepare
  # -------

  # system environment configuration

  # Defaults for specific platforms
  case $::osfamily {
    'Debian','Suse': {
      $def_umask = '027'
      $def_sys_uid_min = 100
      $def_sys_gid_min = 100
      $shadowgroup = 'shadow'
      $shadowmode = '0640'
    }
    'RedHat': {
      $def_umask = '077'
      $def_sys_uid_min = 201
      $def_sys_gid_min = 201
      $shadowgroup = 'root'
      $shadowmode = '0000'
    }
    default: {
      $def_umask = '027'
      $def_sys_uid_min = 100
      $def_sys_gid_min = 100
      $shadowgroup = 'root'
      $shadowmode = '0600'
    }
  }


  # Merge defaults

  # Fix for Puppet Enterprise
  if $pe_environment {
    # Don't redefine directory
    $folders_to_restrict_int = delete($folders_to_restrict, '/usr/local/bin')
  } else {
    $folders_to_restrict_int = $folders_to_restrict
  }


  # Install
  # -------

  class { 'abinbev_cis_suid_rem::suid_sgid':
    whitelist           => $whitelist,
    blacklist           => $blacklist,
    remove_from_unknown => $remove_from_unknown,
    dry_run_on_unknown  => $dry_run_on_unknown,
  }

}
