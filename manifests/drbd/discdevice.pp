# A puppet module to configure a drbd for heartbeat
#
# author pitlinz@sourceforge.net
# (c) 2014 by w4c.at
#
#
# To set any of the following, simply set them as variables in your manifests
# before the class is included, for example:
#

define pitlinz_heartbeat::drbd::discdevice (
  $ensure     		= present,
  $minor      		= undef,
  $portnbr	  		= undef,
  $disk       		= undef,
  $mastername	 	= undef,
  $masterip			= undef,
  $slavename	  	= undef,
  $slaveip	    	= undef,
  $createmd			= true,
) {

	include ::heartbeat::drbd

   	if !$portnbr {
   	    $port = "77${minor}"
   	} else {
   	    $port = $portnbr
   	}

    if !defined(Host[$mastername]) {
        host{"${mastername}":
            ip => $masterip
		}
    }

    if !defined(Host[$slavename]) {
        host{"${slavename}":
            ip => $slaveip
		}
    }

	file {"/etc/drbd.d/$name.res":
		ensure  => $ensure,
		owner   => "root",
		group   => "root",
		mode    => "0550",
		content => template("pitlinz_heartbeat/drbd/resource.res.erb"),
	}

	if $createmd {
		exec { "create_drbd_${name}":
			command => "/sbin/drbdadm create-md ${name}; /sbin/drbdadm up ${name}",
			creates => "/dev/drbd/by-res/${name}",
			require => File["/etc/drbd.d/$name.res"]
	    }
    }

}

