<cfset nextTime = timeFormat(now(),"hh:mm tt")>

<cfset variables.currentFileName = ListLast(cgi.SCRIPT_NAME,"/")>
<cfset variables.schedulerPathForUserCount = ReplaceNoCase(cgi.SCRIPT_NAME,variables.currentFileName ,"userLoginScheduler.cfm")>

<cfschedule 
    action="update" 
    task="UserLogginCount" 
    operation="httprequest" 
    url="https://#cgi.http_host#/#variables.schedulerPathForUserCount#" 
    startdate="#dateFormat(Now(), 'mm-dd-yyyy')#" 
    starttime="#nextTime#" 
    resolveurl="yes" 
    interval="60"
/>