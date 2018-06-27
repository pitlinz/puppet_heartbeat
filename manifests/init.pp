/**
 * puppet module to install and configure heartbeat
 *
 * seckey		=> security key for the nodes/hosts
 * mastername	=> name of the master node (equal to uname -n)
 * masterip		=> ip address of the master
 * slavename	=> name of the slave node (equal to uname -n)
 * slaveip		=> ip address of the master
 * interface	=> interface to use for cast messages
 * autofailback	=> auto failback to master if possible
 *
 */
class pitlinz_heartbeat(
    $seckey			= undef,
    $mastername		= undef,
    $masterip		= undef,
    $slavename		= undef,
	$slaveip		= undef,
	$interface		= "eth0",
	$autofailback 	= 'off',
) {
    if !defined(Package["heartbeat"]) {
        package{"heartbeat":
            ensure => latest
        }
    }

    if !defined(Service["heartbeat"]) {
        service{"heartbeat":
            ensure => running,
            require => Package["heartbeat"],
		}
    }

    if has_ip_address($masterip) {
        $ucastdest = $slaveip
    } else {
        $ucastdest = $masterip
    }

	if ($seckey) {
	    $md5key = pw_hash($seckey,'MD5',"${masterip}${slaveip}")
	} else {
	    $md5key = pw_hash($name,'MD5',"${masterip}${slaveip}")
	}

    file {"/etc/ha.d/authkeys":
        mode 	=> '0600',
		content => template("pitlinz_heartbeat/authkeys.erb"),
		require => Package["heartbeat"],
		notify	=> Service["heartbeat"],
    }

    file {"/etc/ha.d/ha.cf":
        mode 	=> '0644',
		content => template("pitlinz_heartbeat/ha.cf.erb"),
		require => Package["heartbeat"],
		notify	=> Service["heartbeat"],
    }


}
