Function Get-SABRawQueue () {
    <#
       .Description
       The Get-SABRawQueue pulls the raw queue data from the SABNZBD rest interface.
       You can call this function directly but it is used by other functions to pull data.
    #>

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
    <#
       .Description
       The Get-SABQueueList returns a formatted list of slots currently in the queue. Use the ExcludeCompleted switch to only show active slots.
    #>
    Param(
        [parameter(Mandatory = $true)]
        [string]$hostname, 
        [parameter(Mandatory = $true)]
        [string]$apikey,
        [switch]$ExcludeCompleted
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
    <#
       .Description
       The Get-SABQueueTotals returns statistics for the entire queue.
    #>
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
    <#
       .Description
       The Get-SABQueueStatus function is used to control the status of the queue as a whole.
       Use this function to pause or resume the queue. If Pausing, you can set a time (in minutes) that the queue should be paused for.
    #>
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

    # Not Implemented Yet
}

function Set-SABSpeedLimit () {
  Param(
      [parameter(Mandatory = $true)]
      [string]$hostname, 
      [parameter(Mandatory = $true)]
      [string]$apikey,
      [parameter(Mandatory=$true,
      ParameterSetName="ByPercentage")]
      [int]$percentage,
      [parameter(Mandatory=$true,
      ParameterSetName="ByValue")]
      [ValidatePattern("^[1-9][0-9]*[mkMK]$")] 
      [string]$value
  )

  switch ($psCmdlet.ParameterSetName) {
"ByPercentage" {
    $URI = "http://$hostName/api?mode=config&name=speedlimit&value=$percentage&apikey=$apiKey" 
    (Invoke-RestMethod -URI $URI -ErrorVariable $curError -ErrorAction Stop).queue
  }
  "ByValue" {
    $URI = "http://$hostName/api?mode=config&name=speedlimit&value=$value&apikey=$apiKey" 
    (Invoke-RestMethod -URI $URI -ErrorVariable $curError -ErrorAction Stop).queue
  }


}

Export-ModuleMember -Function *

