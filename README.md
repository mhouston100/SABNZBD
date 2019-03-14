# SABNZDB
A Powershell module for working with your SABNZBD instance.

https://sabnzbd.org/

This module allows you to pull queue information into Powershell objects and manipulate the queue/slots.

# Usage

## Module

Copy the module to you `$env:PSModulePath` and load with:

```Import-Module SABNZBD```

## Functions

### Set-SABQueueStatus

Manipulate the status of the whole queue. Use this function to pause or resume all slots in the queue. Use the syntax:

`Set-SABQueueStatus -Hostname xxx.com.au:8080 -apikey 33697778f6821f9895d99bf599e5d04a -status Paused -Minutes 60`

`-Hostname` - Provide the hostname and port of your servers web interface

`-apikey` - Provide the API key generated from the SAB configuration menu

`-status` - Provide the status action, either `Pause` or `Resume`

`-minutes` - If pausing the queue you can provide a number of minutes to pause. If not provided the queue is paused indefinitely (unless manually resumed)

### Get-SABQueueTotals

Return statistics about the whole queue. Use the syntax:

`Get-SABQueueTotals -Hostname xxx.com.au:8080 -apikey 33697778f6821f9895d99bf599e5d04a`

`-Hostname` - Provide the hostname and port of your servers web interface

`-apikey` - Provide the API key generated from the SAB configuration menu

#### Example output

```
No. Downloads        : 7
Speed (KB/s)         : 5724
Total (MB)           : 13325
Total Remaining (MB) : 12374
Completed (%)        : 7
```

### Get-SABQueueList

Gets a list of the queued items in your SAB installation. Use the syntax:

`Get-SABQueueList -Hostname xxx.com.au:8080 -apikey 33697778f6821f9895d99bf599e5d04a -ExcludeCompleted`

`-Hostname` - Provide the hostname and port of your servers web interface

`-apikey` - Provide the API key generated from the SAB configuration menu

`-ExcludeCompleted ` - `$True` or `$False` this option will exclude downloads that are at 100%

#### Example output

```
Remaining (MB) Size (MB) Completed (%) FileName
-------------- --------- ------------- --------
           860      1563            55 xxxxxxxxxxxxxxxx.S06E09.720p.HDTV.x264-AVS
            98      1392             7 xxxxxxxxxxxxxxxx.S04E04.720p.HDTV.x264-SKGTV
            74      1435             5 xxxxxxxxxxxxxxxx.S04E03.720p.HDTV.x264-SKGTV
            38      3045             1 xxxxxxxxxxxxxxxx-s01E01-hddvd-720p
           346      7715             4 xxxxxxxxxxxxxxxx.2015.DOCU.1080p.BluRay.x264-AN0NYM0US.cp
           176      2496             7 xxxxxxxxxxxxxxxx-s01E11-hddvd-720p
            21      2453             1 xxxxxxxxxxxxxxxx-s01E23-hddvd-720p
          2358      2496            94 xxxxxxxxxxxxxxxx-s01E10-hddvd-720p
           176      2293             8 xxxxxxxxxxxxxxxx.S02E10.1080p.WEB-DL.DD5.1.H.264
            65      2234             3 xxxxxxxxxxxxxxxx.2014.S02E09.1080p.WEB-DL.DD5.1.H.264
```

### Get-SABRawQueue

Returns the raw queue data from SABNZBD. This function can be called directly, but is generally used by other functions internally. Use the syntax:

`Get-SABRawQueue -Hostname xxx.com.au:8080 -apikey 33697778f6821f9895d99bf599e5d04a -ExcludeCompleted`

`-Hostname` - Provide the hostname and port of your servers web interface

`-apikey` - Provide the API key generated from the SAB configuration menu