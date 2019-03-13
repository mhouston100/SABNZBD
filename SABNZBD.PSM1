Function Get-SABRawQueue ($hostname, $apikey) {
    $curError = $null
    $URI = "http://$hostName/api?mode=queue&output=json&apikey=$apiKey" 
    (Invoke-RestMethod -URI $URI -ErrorVariable $curError -ErrorAction Stop).queue

} # End Function Get-SABRawQueue

function Get-SABQueueList ([string]$hostname, [string]$apikey, [switch]$ExcludeCompleted) {

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

function Get-SABQueueTotals ([string]$hostname, [string]$apikey) {

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

Export-ModuleMember -Function *

