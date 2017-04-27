<#
    Antonio Abella - 4/02/17
    Get local user sessions and their idle times, and reboot on logout accordingly
#>

$queryOut = @(quser 2>$null | findstr ":" | findstr /V ">")
if (!$queryOut) {
    exit
} else {
    $idleTimes = @()
    Foreach ($session in $queryOut) {
        $hour = ""
        $session = $session -split "\s+"
        if ($session.length -gt 8) {
            if ($($session[5].contains(":"))) {
                $timeSplit = $session[5].split(":+")
                if ($session[5].contains("+")) {
                    $hour = (24 * [int]$timeSplit[0]) + [int]$timeSplit[1]
                } else {
                    $hour = [int]$timeSplit[0]
                }
            } else {
                exit
            }
        } else {
            if ($($session[4].contains(":"))) {
                $timeSplit = $session[4].split(":+")
                if ($session[4].contains("+")) {
                    $hour = (24 * [int]$timeSplit[0]) + [int]$timeSplit[1]
                } else {
                    $hour = [int]$timeSplit[0]
                }
            } else {
                exit
            }
        }
        $idleTimes += ,$hour
    }
    Foreach ($time in $idleTimes){
        if ($time -lt 3) {
            exit
        }
    }
    shutdown.exe /r /t 0
}
