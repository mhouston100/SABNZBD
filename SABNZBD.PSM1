
function Get-SABQueueList ($hostname, $apikey) {
  $rawQueueDetails = $null

  $rawQueueDetails = Invoke-RestMethod -URI "http://$hostName/api?mode=qstatus&output=xml&apikey=$apiKey"

  Foreach ($job in $rawQueueDetails.queue.jobs.job)
  {
    $job
  }
}