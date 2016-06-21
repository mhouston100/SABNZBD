function Get-SABQueueList ($hostname, $apikey, [switch]$ExcludeCompleted) {
  $rawQueueDetails = $null
  $Queue = @()
  $rawQueueDetails = Invoke-RestMethod -URI "http://$hostName/api?mode=qstatus&output=xml&apikey=$apiKey"

  Foreach ($job in $rawQueueDetails.queue.jobs.job)
  {
    $properties=@{
      "FileName"=$job.filename;
      "Size (MB)"=[math]::Round($job.mb);
      "Remaining (MB)"=[math]::Round($job.mbleft);
      "Completed (%)"=[math]::Round(($job.mbleft / $job.mb) * 100)
    }
    $object = New-Object -TypeName psobject -Property $properties

    $Queue += $object
  }

  if ($ExcludeCompleted){
    $Queue | Where-Object -Property 'Completed (%)' -NE -Value 100
  }
  else {
    $Queue
  }
}

Export-ModuleMember -Function 'Get-*'