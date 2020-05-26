
define abinbev_cis_suid_rem::blacklist_files {

  exec { "remove suid/sgid bit from ${name}":
    command => "/bin/chmod ug-s ${name}",
    onlyif  => "/usr/bin/test -f ${name} -a -u ${name} -o -f ${name} -a -g ${name}",
  }

}

