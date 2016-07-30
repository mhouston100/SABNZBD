Function Get-SABRawQueue ($hostname, $apikey){
  $rawQueueDetails = $null
  $URI = "http://$hostName/api?mode=qstatus&output=xml&apikey=$apiKey"

  $rawQueueDetails = Invoke-RestMethod -URI $URI

  if ($rawQueueDetails.result.error){Write-output "The following error occured : $($rawQueueDetails.result.error)";return}

  $rawQueueDetails
}

function Get-SABQueueList ([string]$hostname, [string]$apikey, [switch]$ExcludeCompleted) {
  
  $Queue = @()
  
  Foreach ($job in (Get-SABRawQueue $hostname $apikey).queue.jobs.job)
  {
    $properties=[ordered]@{
      "Size (MB)"=[math]::Round($job.mb);
      "Remaining (MB)"=[math]::Round($job.mbleft);
      "Completed (%)"=[math]::Round(100 - (($job.mbleft / $job.mb) * 100)) 
      "FileName"=$job.filename;
    }

    $Queue += New-Object -TypeName psobject -Property $properties

  }

  if ($ExcludeCompleted){
    $Queue | Where-Object -Property 'Completed (%)' -NE -Value 100
  }
  else {
    $Queue
  }
}

function Get-SABQueueTotals ([string]$hostname, [string]$apikey){
  $rawQueueDetails = Get-SABRawQueue $hostname $apikey
  $properties=[ordered]@{
    "Total (MB)"=[math]::Round($rawQueueDetails.queue.mb);
    "Total Remaining (MB)"=[math]::Round($rawQueueDetails.queue.mbleft);
    "Speed (KB/s)"=[math]::Round($rawQueueDetails.queue.kbpersec)
  }
  $totals = New-Object -TypeName psobject -Property $properties

  $totals
}

Export-ModuleMember -Function 'Get-*'