function Get-SABQueueList ([string]$hostname, [string]$apikey, [switch]$ExcludeCompleted) {
  $rawQueueDetails = $null
  $Queue = @()

  $rawQueueDetails = Invoke-RestMethod -URI "http://$hostName/api?mode=qstatus&output=xml&apikey=$apiKey"

  if ($rawQueueDetails.result.error){Write-output "The following error occured : $($rawQueueDetails.result.error)";return}

  Foreach ($job in $rawQueueDetails.queue.jobs.job)
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

Export-ModuleMember -Function 'Get-*'