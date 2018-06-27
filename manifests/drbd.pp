/*
 * install drbd network raid
 */
class pitlinz_heartbeat::drbd(

) {

    if $::operatingsystemrelease == '12.04' {
        if !defined(Package['python-software-properties']) {
            package{'python-software-properties':
                ensure=>latest,
            }
        }

        include apt
        ::apt::ppa{'ppa:icamargo/drbd':
            require => Package['python-software-properties'],
        }

        if !defined(Package['drbd8-module-source']) {
            package{'drbd8-module-source':
                ensure  => latest,
                require => Apt::Ppa['ppa:icamargo/drbd'],
                notify  => Exec['module_assistant_drbd'],
            }
        }

        if !defined(Exec['module_assistant_drbd']) {
            exec {'module_assistant_drbd':
                command => '/usr/bin/module-assistant auto-install drbd8',
                require => Package['drbd8-module-source'],
                #refreshonly => true,
                creates => "/lib/modules/${::kernelrelease}/kernel/drivers/block/drbd/drbd.ko",
            }
        }

        if !defined(Package['drbd8-utils']) {
            package{'drbd8-utils':
                ensure  => latest,
                require => [Apt::Ppa['ppa:icamargo/drbd'],Exec['module_assistant_drbd']],
            }
        }
    } else {
        if !defined(Package['drbd8-utils']) {
            package{'drbd8-utils':
                ensure => latest,
            }
        }
    }

    if !defined(Service['drbd']) {
        service{'drbd':
            ensure  => running,
            require => Package['drbd8-utils'],
        }
    }
}
