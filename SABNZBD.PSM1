Function Get-SABRawQueue () {
    Param(
        [parameter(Mandatory = $true)]
        [string]$hostname, 
        [parameter(Mandatory = $true)]
        [string]$apikey
    )

    $curError = $null
    $URI = "http://$hostName/api?mode=queue&output=json&apikey=$apiKey" 
    (Invoke-RestMethod -URI $URI -ErrorVariable $curError -ErrorAction Stop).queue
} # End Function Get-SABRawQueue

function Get-SABQueueList () {
    Param(
        [parameter(Mandatory = $true)]
        [string]$hostname, 
        [parameter(Mandatory = $true)]
        [string]$apikey,
        [bool]$ExcludeCompleted
    )

    $Queue = @()
  
    $rawQueue = Get-SABRawQueue $hostname $apikey

    if ($rawQueue.Error) {Write-Output "The following error occured : $($rawQueue.Error)"; return} # End If

    Foreach ($job in ($rawQueue).slots) {
        $properties = [ordered]@{
            "Size (MB)"      = [math]::Round($job.mb);
            "Remaining (MB)" = [math]::Round($job.mbleft);
            "Completed (%)"  = [math]::Round(100 - (($job.mbleft / $job.mb) * 100));
            "Time Left"      = $job.timeleft;
            "FileName"       = $job.filename;
        }

        $Queue += New-Object -TypeName psobject -Property $properties
    }

    if ($ExcludeCompleted) {
        $Queue | Where-Object -Property 'Completed (%)' -NE -Value 100
    }
    else {
        $Queue
    }
} # End Function Get-SABQueueList

function Get-SABQueueTotals () {
    Param(
        [parameter(Mandatory = $true)]
        [string]$hostname, 
        [parameter(Mandatory = $true)]
        [string]$apikey
    )

    $rawQueue = Get-SABRawQueue $hostname $apikey

    if ($rawQueue.Error) {Write-Output "The following error occured : $($rawQueue.Error)"; return} # End If

    $properties = [ordered]@{
        "No. Downloads"        = [math]::Round(($rawQueue).noofslots_total);
        "Speed (KB/s)"         = [math]::Round(($rawQueue).kbpersec);
        "Total (MB)"           = [math]::Round(($rawQueue).mb);
        "Total Remaining (MB)" = [math]::Round(($rawQueue).mbleft);
        "Completed (%)"        = [math]::Round(100 - ((($rawQueue).mbleft / ($rawQueue).mb) * 100))
    } # End Properties
    $totals = New-Object -TypeName psobject -Property $properties

    $totals
} # End Function Get-SABQueueTotals

function Set-SABQueueStatus () {
    Param(
        [parameter(Mandatory = $true)]
        [string]$hostname, 
        [parameter(Mandatory = $true)]
        [string]$apikey,
        [parameter(Mandatory = $true)]
        [ValidateSet("Pause", "Resume")] 
        [string]$status,
        [int]$minutes
    )
    switch ($status) {
        "Pause" {
            If ($minutes) {
                $URI = "http://$hostName/api?mode=config&name=set_pause&value=$minutes&apikey=$apiKey" 
                Invoke-RestMethod -URI $URI -ErrorVariable $curError -ErrorAction Stop

            }
            else {
                $URI = "http://$hostName/api?mode=pause&apikey=$apiKey" 
                Invoke-RestMethod -URI $URI -ErrorVariable $curError -ErrorAction Stop
            } # End If
        }
        "Resume" {
            $URI = "http://$hostName/api?mode=resume&apikey=$apiKey" 
            Invoke-RestMethod -URI $URI -ErrorVariable $curError -ErrorAction Stop
        }
    } # End Switch
} # End Function Set-SABQueueStatus

function Set-SABSlotStatus () {
    Param(
        [parameter(Mandatory = $true)]
        [string]$hostname, 
        [parameter(Mandatory = $true)]
        [string]$apikey
    )
}

Export-ModuleMember -Function *

