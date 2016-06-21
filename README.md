# SABNZDB
Some Powershell modules for working with SABNZDB. I needed a non-production project to help me learn GIT so here is some functions that may be helpful.

You will need to configure and provide a SABNzbd API key from the web interface.

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