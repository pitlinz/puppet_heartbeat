class pitlinz_heartbeat::drbd::disk0(
    $name		= "disk0",
	$disk		= undef,
    $mastername = "${::heartbeat::mastername}",
	$masterip	= "${::heartbeat::masterip}",
	$slavename	= "${::heartbeat::slavename}",
	$slaveip	= "${::heartbeat::slaveip}",
) {
    pitlinz_heartbeat::drbd::discdevice{"${name}":
        minor		=> 0,
        portnbr		=> 7700,
        disk		=> $disk,
        mastername	=> $mastername,
        masterip	=> $masterip,
        slavename	=> $slavename,
        slaveip		=> $slaveip,
    }
}
