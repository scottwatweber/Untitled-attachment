<!---<!--- Get the request monitor. --->
<cfset LOCAL.RequestMonitor = CreateObject("java","coldfusion.runtime.RequestMonitor") />
 
<!--- Return the current request timeout. --->
<cfdump var="#LOCAL.RequestMonitor.GetRequestTimeout()#" />--->

<cfinclude template="../webroot/Application.cfm">
<cfsetting requestTimeOut = "24000">
<cfset groupBy = url.groupBy>
<cfset orderDateFrom = url.orderDateFrom>
<cfset orderDateTo = url.orderDateTo>
<cfset deductionPercentage = url.deductionPercentage>
<cfset salesRepFrom = url.salesRepFrom>
<cfset salesRepFromForQuery = url.salesRepFrom>
<cfset salesRepTo = url.salesRepTo>
<cfset salesRepToForQuery = url.salesRepTo>
<cfset dispatcherFrom = url.dispatcherFrom>
<cfset dispatcherFromForQuery = url.dispatcherFrom>
<cfset dispatcherTo = url.dispatcherTo>
<cfset dispatcherToForQuery = url.dispatcherTo>
<cfset marginRangeFrom = url.marginRangeFrom>
<cfset marginRangeTo = url.marginRangeTo>
<cfset deductionPercentage = url.deductionPercentage>
<cfset commissionPercentage = url.commissionPercentage>
<cfset reportType = url.reportType>
<cfset statusTo = url.statusTo>
<cfset statusFrom = url.statusFrom>
<cfset equipmentFrom = url.equipmentFrom>
<cfset equipmentFromForQuery = url.equipmentFrom>
<cfset equipmentTo= url.equipmentTo>
<cfset equipmentToForQuery= url.equipmentTo>
<cfset freightBroker= url.freightBroker>

<cfif salesRepFrom eq "AAAA">
	<cfset salesRepFrom = "########">
    <cfset salesRepFromForQuery = "">
</cfif>
<cfif salesRepTo eq "AAAA">
	<cfset salesRepTo = "########">
    <cfset salesRepToForQuery = "">
</cfif>

<cfif dispatcherFrom eq "AAAA">
	<cfset dispatcherFrom = "########">
    <cfset dispatcherFromForQuery = "">
</cfif>
<cfif dispatcherTo eq "AAAA">
	<cfset dispatcherTo = "########">
    <cfset dispatcherToForQuery = "">
</cfif>

<cfif equipmentFrom eq "AAAA">
	<cfset equipmentFrom = "########">
    <cfset equipmentFromForQuery = "(BLANK)">
</cfif>
<cfif equipmentTo eq "AAAA">
	<cfset equipmentTo = "########">
    <cfset equipmentToForQuery = "(BLANK)">
</cfif>
<cfif groupBy eq "salesAgent">
	<cfset groupBy = "Sales Agent">
	<cfset groupsBy = "SALESAGENT">
<cfelseif groupBy eq "Driver">	
	<cfset groupBy = "Driver">
	<cfset groupsBy = "Driver">
<cfelseif groupBy eq "Carrier">	
	<cfset groupBy = "Carrier">
	<cfset groupsBy = "Carrier">	
<cfelse>
	<cfset groupBy = "Dispatcher">
	<cfset groupsBy = "DISPATCHER">
</cfif>

<cfstoredproc procedure="USP_GetLoadsForCommissionReport" datasource="#Application.dsn#">
  <cfprocparam value="#groupsBy#" cfsqltype="cf_sql_varchar">
  <cfprocparam value="#groupBy#" cfsqltype="cf_sql_varchar">
  <cfprocparam value="#orderDateFrom#" cfsqltype="cf_sql_varchar">
  <cfprocparam value="#orderDateTo#" cfsqltype="cf_sql_varchar">
  <cfprocparam value="#salesRepFromForQuery#" cfsqltype="cf_sql_varchar">
  <cfprocparam value="#salesRepToForQuery#" cfsqltype="cf_sql_varchar">
  <cfprocparam value="#dispatcherFromForQuery#" cfsqltype="cf_sql_varchar">
  <cfprocparam value="#dispatcherToForQuery#" cfsqltype="cf_sql_varchar">
  <cfprocparam value="#statusTo#" cfsqltype="cf_sql_varchar">
  <cfprocparam value="#statusFrom#" cfsqltype="cf_sql_varchar">
  <cfprocparam value="#deductionPercentage#" cfsqltype="cf_sql_varchar">
  <cfprocparam value="#equipmentFromForQuery#" cfsqltype="cf_sql_varchar">
  <cfprocparam value="#equipmentToForQuery#" cfsqltype="cf_sql_varchar">
  <cfprocresult name="qCommissionReportLoads">
</cfstoredproc>
<cfset tempRootPath = expandPath("../reports/loadCommissionReport.cfr")> 
<cfoutput>
	<cftry>
		<cfreport format="pdf" template="#tempRootPath#" query="#qCommissionReportLoads#">
			<cfreportParam name="ReportType" value="#reportType#">
			<cfreportParam name="orderDateFrom" value="#orderDateFrom#">
			<cfreportParam name="orderDateTo" value="#orderDateTo#">
			<cfreportParam name="salesRepFrom" value="#salesRepFrom#">
			<cfreportParam name="salesRepTo" value="#salesRepTo#">
			<cfreportParam name="dispatcherFrom" value="#dispatcherFrom#">
			<cfreportParam name="dispatcherTo" value="#dispatcherTo#">
			<cfreportParam name="marginRangeFrom" value="#marginRangeFrom#">
			<cfreportParam name="marginRangeTo" value="#marginRangeTo#">
			<cfreportParam name="paramgroupBy" value="#groupsBy#">
			<cfreportParam name="deductionPercentage" value="#deductionPercentage#">
			<cfreportParam name="equipmentFrom" value="#equipmentFrom#">
			<cfreportParam name="equipmentTo" value="#equipmentTo#">
			<cfreportParam name="freightBroker" value="#freightBroker#">
		</cfreport>
	<cfcatch>
		<cfdump var="#cfcatch#" abort="true">
		Sorry! Unexpected error occurred. Please try again later.
	</cfcatch> 
	</cftry>
</cfoutput> 
