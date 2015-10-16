<cfcomponent output="false">
<cffunction name="init" access="public" output="false" returntype="void">
	<cfargument name="dsn" type="string" required="yes" />
	<cfset variables.dsn = Application.dsn />
</cffunction>
<!----Get All Equipments Information---->
<cffunction name="getAllUnits" access="public" output="false" returntype="any">
    <cfargument name="UnitID" required="no" type="any">
     <cfargument name="sortorder" required="no" type="any">
     <cfargument name="sortby" required="no" type="any">
	 <cfargument name="status" required="no" type="string">
	<cfquery name="qrygetunits" datasource="#variables.dsn#">
    	select * from  Units
        where 1=1
        <cfif isdefined('arguments.UnitID') and len(arguments.UnitID)>
        	and UnitID='#arguments.UnitID#'
         </cfif>	
		<cfif isdefined('arguments.status') and len(arguments.status)>
			and isActive = '#arguments.status#'
		</cfif>
        	ORDER BY unitName
	</cfquery>
             
	<cfif isDefined("arguments.sortorder") and isDefined("arguments.sortby") and len(arguments.sortby)> 
    	<cfquery datasource="#variables.dsn#" name="getnewAgent">
        	select *  from Units
            where 1=1
            order by #arguments.sortby# #arguments.sortorder#;
		</cfquery>             
		<cfreturn getnewAgent>               
	</cfif>
    
    <cfreturn qrygetunits>
</cffunction>
<!-----get unit infor for add /edit load page----->
<cffunction name="getloadUnits" access="public" output="false" returntype="any">
    <cfargument name="UnitID" required="no" type="any">
     <cfargument name="sortorder" required="no" type="any">
     <cfargument name="sortby" required="no" type="any">
	 <cfargument name="status" required="no" type="string">
	<cfquery name="qrygetunits" datasource="#variables.dsn#">
    	select unitID,unitName,unitCode,CustomerRate,CarrierRate from  Units
        where 1=1
        <cfif isdefined('arguments.UnitID') and len(arguments.UnitID)>
        	and UnitID='#arguments.UnitID#'
         </cfif>	
		<cfif isdefined('arguments.status') and len(arguments.status)>
			and isActive = '#arguments.status#'
		</cfif>
        	ORDER BY unitName
	</cfquery>
             
	<cfif isDefined("arguments.sortorder") and isDefined("arguments.sortby") and len(arguments.sortby)> 
    	<cfquery datasource="#variables.dsn#" name="getnewAgent">
        	select unitID,unitName,unitCode from  Units
            where 1=1
            order by #arguments.sortby# #arguments.sortorder#;
		</cfquery>             
		<cfreturn getnewAgent>               
	</cfif>
    
    <cfreturn qrygetunits>
</cffunction>
<!---Add Equipment Information---->
<cffunction name="Addunit" access="public" output="false" returntype="any">
   <cfargument name="formStruct" type="struct" required="no" />
   <cfset variables.customerRate = replace( arguments.formStruct.CustomerRate,"$","","ALL") > 
	<cfset variables.carrierRate = replace( arguments.formStruct.CarrierRate,"$","","ALL") > 
      <cfquery name="insertquery" datasource="#variables.dsn#">
       insert into Units(UnitCode,UnitName,IsActive,CreatedBy,LastModifiedBy,CreatedDateTime,LastModifiedDateTime,IsFee,CreatedByIP,GUID,CustomerRate,CarrierRate)
       values(
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.UnitCode#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.UnitName#">,
              <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.Status#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
              <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
              <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
              <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.IsFee#">, 
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_USER_AGENT#"> ,
			  <cfqueryparam cfsqltype="cf_sql_decimal"  value="#variables.customerRate#">,
			  <cfqueryparam cfsqltype="cf_sql_decimal"  value="#variables.carrierRate#">
              )
   </cfquery>
   <cfreturn "Unit has been added Successfully">	    	
</cffunction>
<!---Update Equipment --->
<cffunction name="Updateunit" access="public" output="false" returntype="any">
    <cfargument name="formStruct" type="struct">
    <cfargument name="editid" type="any"> 
	<cfset variables.customerRate = replace( arguments.formStruct.CustomerRate,"$","","ALL") > 
	<cfset variables.carrierRate = replace( arguments.formStruct.CarrierRate,"$","","ALL") >
    <cfquery name="qryupdate" datasource="#variables.dsn#" result="updateResult">
         update Units
         set  UnitCode= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.UnitCode#">,
              UnitName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.UnitName#">,
              IsActive=<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.Status#">,
              IsFee=<cfqueryparam cfsqltype="cf_sql_bit"  value="#arguments.formStruct.IsFee#">,
			  CustomerRate=<cfqueryparam  value="#variables.customerRate#">,
			  CarrierRate=<cfqueryparam value="#variables.carrierRate#">,
              UpdatedByIP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
        where UnitID='#arguments.formStruct.editid#' 
     </cfquery>
     <cfreturn "Unit has been updated Successfully">
</cffunction>
<!--- Delete Equipment---->
<cffunction name="deleteUnits"  access="public" output="false" returntype="any">
<cfargument name="UnitID" type="any" required="yes">
    <cftry>
    		<cfquery name="qryDelete" datasource="#variables.dsn#">
    			 delete from Units where  UnitID='#arguments.UnitID#'
    		</cfquery>
    		<cfreturn "Units has been deleted successfully.">	
    		<cfcatch type="any">
    			<cfreturn "Delete operation has been not successfull.">
    		</cfcatch>
    	</cftry>
</cffunction>  

<cffunction name="getSearchedUnit" access="public" output="false" returntype="query">
	<cfargument name="searchText" required="yes" type="any">
	<CFSTOREDPROC PROCEDURE="searchUnit" DATASOURCE="#variables.dsn#"> 
		<cfif isdefined('arguments.searchText') and len(arguments.searchText)>
		 	<CFPROCPARAM VALUE="#arguments.searchText#" cfsqltype="CF_SQL_VARCHAR">  
		 <cfelse>
		 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
		 </cfif>
		 <CFPROCRESULT NAME="QreturnSearch"> 
	</CFSTOREDPROC>
    <cfreturn QreturnSearch>
</cffunction>

</cfcomponent>