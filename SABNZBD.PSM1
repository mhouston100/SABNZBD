Function Get-SABRawQueue ($hostname, $apikey){
  $curError = $null
  $URI = "http://$hostName/api?mode=qstatus&output=xml&apikey=$apiKey"

  $properties=[ordered]@{
    "Data"="";
    "Error"=$curError
  } # End Object Properties
  
  $rawQueue = New-Object -TypeName psobject -Property $properties

  try {

    $rawQueue.Data = Invoke-RestMethod -URI $URI -ErrorVariable $curError -ErrorAction Stop
    if ($rawQueue.Data.result.error){$rawQueue.Error = $($rawQueue.Data.result.error)} 

  } # End Try
  catch {

    $rawQueue.Error = $curError
    
  } # End Catch

  $rawQueue
} # End Function Get-SABRawQueue

function Get-SABQueueList ([string]$hostname, [string]$apikey, [switch]$ExcludeCompleted) {

  $Queue = @()
  
  $rawQueue = Get-SABRawQueue $hostname $apikey
  if ($rawQueue.Error){Write-Output "The following error occured : $($rawQueue.Error)";return} # End If

  Foreach ($job in ($rawQueue).Data.queue.jobs.job)
  {
    $properties=[ordered]@{
      "Size (MB)"=[math]::Round($job.mb);
      "Remaining (MB)"=[math]::Round($job.mbleft);
      "Completed (%)"=[math]::Round(100 - (($job.mbleft / $job.mb) * 100));
      "Time Left"=$job.timeleft;
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
} # End Function Get-SABQueueList

function Get-SABQueueTotals ([string]$hostname, [string]$apikey){

  $rawQueue = Get-SABRawQueue $hostname $apikey
  if ($rawQueue.Error){Write-Output "The following error occured : $($rawQueue.Error)";return} # End If

  $properties=[ordered]@{
    "No. Downloads"=[math]::Round(($rawQueue).Data.queue.noofslots_total);
    "Speed (KB/s)"=[math]::Round(($rawQueue).Data.queue.kbpersec);
    "Total (MB)"=[math]::Round(($rawQueue).Data.queue.mb);
    "Total Remaining (MB)"=[math]::Round(($rawQueue).Data.queue.mbleft);
    "Completed (%)"=[math]::Round(100 - ((($rawQueue).Data.queue.mbleft / ($rawQueue).Data.queue.mb) * 100))
  } # End Properties
  $totals = New-Object -TypeName psobject -Property $properties

  $totals
} # End Function Get-SABQueueTotals

Export-ModuleMember -Function *