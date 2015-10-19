<cfif structkeyexists (session,"empid") and structkeyexists(session, "passport")>			
			<cfif Session.empid neq "">		
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
			<cfif Session.customerid neq "">	
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
		<cfcontent
    type="text/plain"
    variable="#ToBinary( ToBase64( 'true' ) )#"
    />