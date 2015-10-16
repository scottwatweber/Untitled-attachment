
<cfcomponent hint="I handle AJAX File Uploads from Valum's AJAX file uploader library">
	
    <cffunction name="Upload" access="remote" output="false" returntype="any" returnformat="JSON">
		<cfargument name="qqfile" type="string" required="true">
		
		<cfset var local = structNew()>
		<cfset local.response = structNew()>
		<cfset local.requestData = GetHttpRequestData()>
		<cfset local.response.fileName = "">
		
		<CFSET UploadDir = "#ExpandPath('../')#img\">
		<cfif not directoryExists(UploadDir)>
			<cfdirectory action="create" directory="#UploadDir#">
		</cfif>
		
		<!--- check if XHR data exists --->
        <cfif len(local.requestData.content) GT 0>
			<cfset local.response = UploadFileXhr(arguments.qqfile,local.requestData.content)>       
		<cfelse>
		<!--- no XHR data process as standard form submission --->
			<cffile action="upload" file="#arguments.qqfile#" destination="#UploadDir#" nameConflict="makeunique">
			
    		<cfset local.response['success'] = true>
    		<cfset local.response['type'] = 'form'>
		<cfset local.response.fileName = '#cfFile.ServerFile#'>

		</cfif>
		
		<cfreturn local.response>
	</cffunction>
      
    
    <cffunction name="UploadFileXhr" access="private" output="false" returntype="struct">
		<cfargument name="qqfile" type="string" required="true">
		<cfargument name="content" type="any" required="true">

		<cfset var local = structNew()>
		<cfset local.response = structNew()>
		<cfset local.response.fileName ="">
		<CFSET UploadDir = "#ExpandPath('../')#img\">

        <!--- write the contents of the http request to a file.  
		The filename is passed with the qqfile variable --->
		<cffile action="write" file="#UploadDir#/#arguments.qqfile#" output="#arguments.content#">

		<!--- if you want to return some JSON you can do it here.  
		I'm just passing a success message	--->
    	<cfset local.response['success'] = true>
    	<cfset local.response['type'] = 'xhr'>
		<cfset local.response.fileName = '#arguments.qqfile#'>
		<cfreturn local.response>
    </cffunction>
    	
	</cfcomponent>