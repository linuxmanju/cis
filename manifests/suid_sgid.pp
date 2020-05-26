class abinbev_cis_suid_rem::suid_sgid (
  Array   $whitelist           = [],
  Array   $blacklist           = [],
  Boolean $remove_from_unknown = true,
  Boolean $dry_run_on_unknown  = false,

) {


  $system_blacklist = [
    # blacklist as provided by NSA
    '/usr/bin/rcp', '/usr/bin/rlogin', '/usr/bin/rsh', "/usr/bin/abcd",
    # sshd must not use host-based authentication (see ssh cookbook)
    '/usr/libexec/openssh/ssh-keysign',
    '/usr/lib/openssh/ssh-keysign',
    # misc others
    # not normally required for user
    '/sbin/netreport',
    '/usr/sbin/usernetctl',
    '/usr/sbin/userisdnctl',
    '/usr/sbin/pppd',
    '/usr/bin/lockfile',
    '/usr/bin/mail-lock',
    '/usr/bin/mail-unlock',
    '/usr/bin/mail-touchlock',
    '/usr/bin/dotlockfile',
    '/usr/bin/arping',
    '/usr/sbin/uuidd',
    '/usr/bin/mtr',
    '/usr/lib/evolution/camel-lock-helper-1.2',
    '/usr/lib/pt_chown',
    '/usr/lib/eject/dmcrypt-get-device',
    '/usr/lib/mc/cons.saver',
  ]

  # list of suid/sgid entries that can remain untouched
  $system_whitelist = [
    # whitelist as provided by NSA
    '/bin/mount', '/bin/ping', '/bin/su', '/bin/umount',
    '/sbin/pam_timestamp_check','/sbin/unix_chkpwd', '/usr/bin/at',
    '/usr/bin/gpasswd', '/usr/bin/locate', '/usr/bin/newgrp',
    '/usr/bin/passwd', '/usr/bin/ssh-agent', '/usr/libexec/utempter/utempter',
    '/usr/sbin/lockdev', '/usr/sbin/sendmail.sendmail', '/usr/bin/expiry',
    '/bin/ping6','/usr/bin/traceroute6.iputils',
    '/sbin/mount.nfs', '/sbin/umount.nfs',
    '/sbin/mount.nfs4', '/sbin/umount.nfs4',
    '/usr/bin/crontab',
    '/usr/bin/wall', '/usr/bin/write',
    '/usr/bin/screen',
    '/usr/bin/mlocate',
    '/usr/bin/chage', '/usr/bin/chfn', '/usr/bin/chsh',
    '/bin/fusermount',
    '/usr/bin/pkexec',
    '/usr/bin/sudo','/usr/bin/sudoedit',
    '/usr/sbin/postdrop','/usr/sbin/postqueue',
    '/usr/sbin/suexec',
    # whitelist kerberos
    '/usr/kerberos/bin/ksu',
    # whitelist pam_caching
    '/usr/sbin/ccreds_validate',
  ]

  $final_blacklist = combine_sugid_lists($system_blacklist, $whitelist, $blacklist)
  $final_whitelist = combine_sugid_lists($system_whitelist, $blacklist, $whitelist)

  abinbev_cis_suid_rem::blacklist_files { $final_blacklist: }

  if $remove_from_unknown {
    # create a helper script
    # TODO: do without
    file { '/usr/local/sbin/remove_suids':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0500',
      content => template('abinbev_cis_suid_rem/remove_sugid_bits.erb'),
    }
    #remove all bits
    exec { 'remove SUID/SGID bits from unknown':
      command => '/usr/local/sbin/remove_suids',
    }
    File['/usr/local/sbin/remove_suids'] -> Exec['remove SUID/SGID bits from unknown']
  }

}


