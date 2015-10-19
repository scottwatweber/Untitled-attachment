<cfscript>

	Application.QBdsn = "LMaccessQB";
	Application.dsn = trim(listFirst(cgi.SCRIPT_NAME,'/'));
</cfscript>

