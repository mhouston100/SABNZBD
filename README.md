# SABNZDB
A Powershell module for working with your SABNZBD queue.

https://sabnzbd.org/

This module allows you to pull queue information into Powershell objects and manipulate the queue/slots.

# Usage

## Module

Copy the module to you `$env:PSModulePath` and load with:

```Import-Module SABNZBD```

## Functions

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