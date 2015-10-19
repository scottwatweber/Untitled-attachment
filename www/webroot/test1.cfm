<!---cfdump var="#Application.userLoggedInCount#"--->
<!---cfquery name="test" datasource="#Application.dsn#">
	select * from loadstops where loadid='78DF087E-4CE1-430B-A4DD-A8AFDED428C3'
</cfquery>
<cfquery name="test" datasource="#Application.dsn#">

select * from SystemConfig

</cfquery>

<cfdump var="#test#"--->
<!---cfquery name="loadifta" datasource="#Application.dsn#">
	select loadNumber from LoadIFTAMiles 
</cfquery>
<cfif loadifta.recordcount>
	<cfloop query="loadifta">

		<cfquery name="getloadid" datasource="#Application.dsn#">
			select loadid from loads where loadNumber=<cfqueryparam value="#loadifta.loadNumber#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif getloadid.recordcount>
			<cfquery name="update" datasource="#Application.dsn#">
			UPDATE LoadIFTAMiles
			SET loadid =<cfqueryparam value="#getloadid.LoadID#" cfsqltype="cf_sql_varchar">
			where  loadNumber=<cfqueryparam value="#loadifta.loadNumber#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>	
	</cfloop>
</cfif>	
<cfdump var="LoadIFTAMiles loadid column was updated"--->


<cfquery name="test" datasource="#Application.dsn#">

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_catalog = '#Application.dsn#' 
    AND table_name = 'SystemConfig'

</cfquery>
<cfdump var="#test#">