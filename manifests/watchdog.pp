/**
 * install and configure watchdog
 *
 */
class pitlinz_heartbeat::watchdog(

) {
    if !defined(Package["watchdog"]) {
        package{"watchdog":
            ensure => latest
		}
    }

	if !defined(File["/etc/watchdog.conf"]) {
	    file{"/etc/watchdog.conf":
	        content => template("pitlinz_heartbeat/watchdog.conf.erb"),
	        notify 	=> Service["watchdog"],
	        require	=> Package["watchdog"],
		}
	}

	if !defined(Service["watchdog"]) {
	    service{"watchdog":
	        ensure => running
		}
	}
}
