<cfquery name="test" datasource="#application.dsn#">
	SELECT top 10 *
	FROM Employees
</cfquery>

<cfdump var="#test#">