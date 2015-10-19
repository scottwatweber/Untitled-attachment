<cfif structkeyExists(url,"dsn")>
<!--- Decrypt String --->
<cfset TheKey = 'NAMASKARAM'>
<cfset dsn = Decrypt(ToString(ToBinary(url.dsn)), TheKey)>
</cfif>
<cfset variables.frieghtBroker = "">
<cfif structkeyexists(url,"type")>
	<cfset variables.frieghtBroker=url.type>
</cfif>
<cfif structkeyexists(url,"loadno") or structkeyexists(url,"loadid")>

	<cfquery name="careerReport" datasource="#dsn#">
		SELECT *, 
			(SELECT sum(weight)  from vwCarrierConfirmationReport 
			   <cfif structkeyexists(url,"loadno")>
					WHERE  (LoadNumber = #url.loadno#)
				<cfelseif structkeyexists(url,"loadid")>
					WHERE  (LoadID = '#url.loadid#')
			   </cfif>
			 GROUP BY loadnumber) as TotalWeight 
		FROM vwCarrierConfirmationReport
	   <cfif structkeyexists(url,"loadno")>
			WHERE  (LoadNumber = #url.loadno#)
		<cfelseif structkeyexists(url,"loadid")>
			WHERE  (LoadID = '#url.loadid#')
	   </cfif>
	   	   ORDER BY stopnum 
	</cfquery>
	 <cfoutput>
	<!---
	<cfreport format="PDF" template="loadReportForCarrierConfirmation.cfr" style="../webroot/styles/reportStyle.css" query="#careerReport#"> 
	--->
	<cfif variables.frieghtBroker eq 'Carrier'>
		<cfreport format="PDF" template="loadReportForCarrierConfirmation.cfr" style="../webroot/styles/reportStyle.css" query="#careerReport#"> 
			<cfreportParam name="ReportDate" value="#DateFormat(Now(),'mm/dd/yyyy')#"> 
		</cfreport> 
	<cfelseif variables.frieghtBroker eq 'Dispatch'>
		<cfreport format="PDF" template="LoadReportForDispatch.cfr" style="../webroot/styles/reportStyle.css" query="#careerReport#"> 
			<cfreportParam name="ReportDate" value="#DateFormat(Now(),'mm/dd/yyyy')#"> 
		</cfreport> 
	</cfif>	
	</cfoutput>	 
<cfelse>
	Unable to generate the report. Please specify the load Number or Load ID	
</cfif>	