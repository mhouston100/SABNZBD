Param(
  [string]$hostName,
  [string]$apiKey
)
$rawQueueDetails = $null

$rawQueueDetails = Invoke-RestMethod -URI "http://$hostName/api?mode=qstatus&output=xml&apikey=$apiKey"

Foreach ($job in $rawQueueDetails.queue.jobs.job)
{
  $job
}