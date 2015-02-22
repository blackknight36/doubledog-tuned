# modules/tuned/manifests/init.pp
#
# == Class: tuned
#
# Manages MODULE_NAME on a host.
#
# === Parameters
#
# [*ensure*]
#   Service is to be 'running' (default) or 'stopped'.
#
# [*enable*]
#   Service is to be started at boot; either true (default) or false.
#
# [*profile*]
#   Profile that tuned is to use.  The default is to automatically select the
#   recommended profile.  See tuned-adm(8) for details.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2014-2015 John Florian


class tuned (
        $ensure='running',
        $enable=true,
        $profile=undef,
    ) {

    include 'tuned::params'

    package { $tuned::params::packages:
        ensure => installed,
        notify => Service[$tuned::params::services],
    }

    File {
        owner       => 'root',
        group       => 'root',
        mode        => '0644',
        seluser     => 'system_u',
        selrole     => 'object_r',
        seltype     => 'tuned_rw_etc_t',
        before      => Service[$tuned::params::services],
        notify      => Service[$tuned::params::services],
        subscribe   => Package[$tuned::params::packages],
    }

    file { '/etc/tuned/active_profile':
        content => $profile,
    }

    service { $tuned::params::services:
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => true,
        hasstatus  => true,
    }

}
