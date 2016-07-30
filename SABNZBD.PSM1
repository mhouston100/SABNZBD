Function Get-SABRawQueue ($hostname, $apikey){
  $curError = $null
  $URI = "http://$hostName/api?mode=qstatus&output=xml&apikey=$apiKey"

  $properties=[ordered]@{
    "Data"="";
    "Error"=$curError
  } # End Object Properties
  
  $rawQueueDetails = New-Object -TypeName psobject -Property $properties

  try {

    $rawQueueDetails.Data = Invoke-RestMethod -URI $URI -ErrorVariable $curError

  } # End Try
  catch 
  {

    $rawQueueDetails.Error = $curError
    
  } # End Catch
  finally
  {

    if ($rawQueueDetails.result.error){$curError = $($rawQueueDetails.result.error)}

  } # End Finally

  $rawQueueDetails
}

function Get-SABQueueList ([string]$hostname, [string]$apikey, [switch]$ExcludeCompleted) {
  
  $Queue = @()
  
  Foreach ($job in (Get-SABRawQueue $hostname $apikey).Data.queue.jobs.job)
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
  $rawQueueDetails = (Get-SABRawQueue $hostname $apikey).Data
  $properties=[ordered]@{
    "No. Downloads"=[math]::Round($rawQueueDetails.queue.noofslots_total);
    "Speed (KB/s)"=[math]::Round($rawQueueDetails.queue.kbpersec);
    "Total (MB)"=[math]::Round($rawQueueDetails.queue.mb);
    "Total Remaining (MB)"=[math]::Round($rawQueueDetails.queue.mbleft);
    "Completed (%)"=[math]::Round(100 - (($rawQueueDetails.queue.mbleft / $rawQueueDetails.queue.mb) * 100))
  }
  $totals = New-Object -TypeName psobject -Property $properties

  $totals
}

Export-ModuleMember -Function 'Get-*'