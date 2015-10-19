<cfsetting enablecfoutputonly="yes" />
<!---
Written By: Weber Systems Inc. 
Date Started: 28-01-2011
Page Purpose: Main Application page
--->
<cfset strApplicationName = Right(ExpandPath('.'), 64) />
<cfapplication name="#strApplicationName#" clientmanagement="no" sessionmanagement="yes" setclientcookies="no" setdomaincookies="no" sessiontimeout="#CreateTimeSpan(0,0,60,0)#" applicationtimeout="#CreateTimeSpan(10,0,0,0)#">
<cfscript>
	//StructDelete(Session, "passport");
	//Application Variables
	Application.Name = strApplicationName;
	Application.QBdsn = "LMaccessQB"; //Quickbooks DSN
	Application.gAPI='AIzaSyAMvv7YySXPntllOqj7509OH-9N3HgCJmw';	//Googple Maps API
	Application.dsn = trim(listFirst(cgi.SCRIPT_NAME,'/'));
	Application.strWebsiteTitle = "Load Manager"; //Remember this does not effect the error template title
	Application.strDeveloperEmailAddress = "ScottW@WeberSystems.com;scottnweber@gmail.com";
	Application.ExtrasFolder = ExpandPath("../../extras");
	Application.strDateFormat = "d MMMM YYYY";
	Application.strDateFormatForTextInput = "dd/MM/YYYY";
	Application.ResultsPerPage = 10;
	Application.ImportDSN = "";
	Application.SchedulerTimeout = 120;
	Application.pwdExpiryDays = 600; // How many days before the passwords expire (by default).
	Application.strTimeFormat = "HH:MM";
	Application.NoAuthEvents = "login|login:process|lostpassword|lostpassword:process|customerlogin|Customerlogin:process"; // This is a Pipe(|) Separated List of events that do not require the user to be logged in first (e.g. login|login:process).
	Application.strSMSAddress = "ScottW@WeberSystems.com";
	Application.strEmailFromAddress = "ScottW@WeberSystems.com";
	param name="Application.userLoggedInCount" default="";
</cfscript>
	<cfset basepath = GetDirectoryFromPath(GetBaseTemplatePath())>
	<!--- publicRoot: the directory that Application.cfc resides in (the web root) --->

	<cfset publicRoot = GetDirectoryFromPath(GetCurrentTemplatePath())>
	
	<cfif len(basepath) gt len(publicRoot)>
		<!--- relativePath: the difference between basepath and publicRoot --->
		<cfset relativePath = right(basepath, len(basepath) - len(publicRoot))>
		<!--- publicRootRelative: the relative path from the current template to the web root --->
		<cfset publicRootRelative = ReReplace(relativePath, "[^\\\/]+", "..", "ALL")>
		<cfset publicRootParentRelative = iif(Len(publicRootRelative) GT 3, 'Left(publicRootRelative, Len(publicRootRelative) - 3)', DE(publicRootRelative))>
		<cfset publicRootGrandParentRelative = iif(Len(publicRootParentRelative) GT 3, 'Left(publicRootParentRelative, Len(publicRootParentRelative) - 3)', DE(publicRootParentRelative))>
	<cfelse>
		<!--- the current template resides in the web root, both these variables are empty --->
		<cfset relativePath = "">
		<cfset publicRootRelative = "">
	</cfif>
	
	<cfset session.checkUnload = ''>
	<cfset request.webpath = Replace("http://#cgi.http_host##cgi.script_name#", "\", "/", "ALL")>
	<cfset numDirectories = ListLen(relativePath, "\/") + 1>
	
	<cfloop from="1" to="#numDirectories#" index="i">
		<cfset request.webpath = left(request.webpath, len(request.webpath) - find("/", reverse(request.webpath)))>
	</cfloop>

	<cfset request.imagesPath = request.webpath & "/images/">
	<cfset request.fileUploadedtemp = request.webpath & "/fileupload/imgTemp/">  
	<cfset request.fileUploadedPer = request.webpath & "/filesUpload/imgPrmnt/">
	
	<!--- URL path --->
	<cfset request.cfcpath =  Application.dsn &'.www.gateways'>   

	<!---Sample URL is http://www.loadmanager.biz/cfmps/www/webroot/index.cfm?strDebugMode=EntelDebug2012041106--->
	<!---The 06 in the end is the hour of the current time in the timezone set on the server. This would need to change every hour.---> 
	<cfif IsDefined("URL.strDebugMode")>
		<cfif URL.strDebugMode EQ "EntelDebug#DateFormat(Now(),"yyyyMMddHH")#">
			<cfset Application.blnDebugMode = True>
		</cfif>
	<cfelse>
		<cfset Application.blnDebugMode = false>   
	</cfif>
	<cfif IsDefined("URL.reinit")>
		<cfscript>
			StructDelete(Application, "objLoadGatewayAdd", "True");
			StructDelete(Application, "objloadGateway", "True");
			StructDelete(Application, "objLoadGatewaynew", "True");
			StructDelete(Application, "objAgentGateway", "True");
			StructDelete(Application, "objLoadgatewayUpdate", "True");
		</cfscript>
	</cfif>
	<cfset variables.loginFlag = 0>
	<cfif structkeyexists(Session,"empid") and len(trim(Session.empid)) >
		<cfset variables.loginFlag = 1>
	</cfif>
	<cfif structkeyexists(Session,"customerid") and len(trim(Session.customerid))>
		<cfset variables.loginFlag = 1>
	</cfif>		
	<cfif structKeyExists(cookie, "userlogginid") and len(trim(cookie.userLogginID)) and variables.loginFlag eq 0>			
		<cfif cookie.userLogginID neq "">
			<cfquery name="qGetUserLoggedInCount" datasource="#Application.dsn#">
				select cutomerId,currenttime 
				from userLoggedInCount
				where cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cookie.userLogginID#">
			</cfquery>			
			<cfif qGetUserLoggedInCount.recordcount>
				<cfquery name="qUpdateIsLoggin" datasource="#Application.dsn#">
					delete from userLoggedInCount
					where 	cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cookie.userLogginID#">
				</cfquery>
			</cfif>
			<cfset listPos = ListFindNoCase(Application.userLoggedInCount, cookie.userLogginID)>
			<cfif listPos>
				<cfset Application.userLoggedInCount = ListDeleteAt(Application.userLoggedInCount, listPos)>
			</cfif>
			<cfset structDelete(cookie, "userLogginID") />
		</cfif>
	</cfif>
	<cfparam name="Session.blnDebugMode" default="#Application.blnDebugMode#">

	<cfif Application.blnDebugMode Or Session.blnDebugMode>
		<cfsetting showdebugoutput="yes">
	<cfelse>
		<cfsetting showdebugoutput="no">
		<!--- <cferror type="exception" template="templates/error_general.cfm" mailto="#Application.strDeveloperEmailAddress#">
		<cferror type="request" template="templates/error_general.cfm" mailto="#Application.strDeveloperEmailAddress#"> --->
	</cfif>
	<cfif structkeyexists (session,"empid") and structkeyexists(session, "passport")>			
		<cfif Session.empid neq "" and session.passport.isLoggedIn>				
			<cfif NOT ListFindNoCase(Application.userLoggedInCount, Session.empid)>
				<cfset Application.userLoggedInCount = ListAppend(Application.userLoggedInCount,
				Session.empid)>
			</cfif>
			<cfquery name="qGetUserLoggedInCount" datasource="#Application.dsn#">
				select cutomerId,currenttime 
				from userLoggedInCount
				where cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">
			</cfquery>
			<cfif qGetUserLoggedInCount.recordcount>
				<cfquery name="qUpdateIsLoggin" datasource="#Application.dsn#">
					update userLoggedInCount
					set 
						currenttime = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
						isactive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					where 	cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">
				</cfquery>
			<cfelse>
				<cfquery name="qUpdateIsLoggin" datasource="#Application.dsn#">
					insert into userLoggedInCount(cutomerId,currenttime,isactive)
					VALUES(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">
					) 
				</cfquery>				
			</cfif>				
		</cfif>	
	</cfif>
	<cfif structkeyexists (session,"customerid") and structkeyexists(session, "passport")>
		<cfif Session.customerid neq "" and session.passport.isLoggedIn>				
			<cfif NOT ListFindNoCase(Application.userLoggedInCount, Session.customerid)>
				<cfset Application.userLoggedInCount = ListAppend(Application.userLoggedInCount,
				Session.customerid)>
			</cfif>
			<cfquery name="qGetUserLoggedInCount" datasource="#Application.dsn#">
				select cutomerId,currenttime 
				from userLoggedInCount
				where cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.customerid#">
			</cfquery>
			<cfif qGetUserLoggedInCount.recordcount>
				<cfquery name="qUpdateIsLoggin" datasource="#Application.dsn#">
					update userLoggedInCount
					set 
						currenttime = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
						isactive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					where 	cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.customerid#">
				</cfquery>
			<cfelse>
				<cfquery name="qUpdateIsLoggin" datasource="#Application.dsn#">
					insert into userLoggedInCount(cutomerId,currenttime,isactive)
					VALUES(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.customerid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">
					) 
				</cfquery>
			</cfif>
		</cfif>	
	</cfif>