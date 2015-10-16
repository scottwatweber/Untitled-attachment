<cfcomponent output="false">
<cffunction name="init" access="public" output="false" returntype="void">
	<cfargument name="dsn" type="string" required="yes" />
	<cfset variables.dsn = Application.dsn />
</cffunction>
<!----Get All Equipments Information---->
<cffunction name="getAllEquipments" access="public" output="false" returntype="any">
    <cfargument name="EquipmentID" required="no" type="any">
	<cfargument name="sortorder" required="no" type="any">
	<cfargument name="sortby" required="no" type="any">
             <cfquery name="qrygetcustomers" datasource="#variables.dsn#">
                 select * from  Equipments
                 where 1=1
         		 <cfif isdefined('arguments.EquipmentID') and len(arguments.EquipmentID)>
         			and EquipmentID='#arguments.EquipmentID#'
         		</cfif>
                ORDER BY EquipmentName	
             </cfquery>
             
    <cfif isDefined("arguments.sortorder") and isDefined("arguments.sortby") and len(arguments.sortby)> 
              
           <cfquery datasource="#variables.dsn#" name="getnewAgent">
                       select *  from Equipments
                       where 1=1
                       order by #arguments.sortby# #arguments.sortorder#;
           </cfquery>
                     
          <cfreturn getnewAgent>               
                       
     </cfif>
             <cfreturn qrygetcustomers>
</cffunction>
<cffunction name="getloadEquipments" access="public" output="false" returntype="any">
    <cfargument name="EquipmentID" required="no" type="any">
	<cfargument name="sortorder" required="no" type="any">
	<cfargument name="sortby" required="no" type="any">
             <cfquery name="qrygetcustomers" datasource="#variables.dsn#">
                 select equipmentID,equipmentname from  Equipments
                 where 1=1
         		 <cfif isdefined('arguments.EquipmentID') and len(arguments.EquipmentID)>
         			and EquipmentID='#arguments.EquipmentID#'
         		</cfif>
                ORDER BY EquipmentName	
             </cfquery>
             
    <cfif isDefined("arguments.sortorder") and isDefined("arguments.sortby") and len(arguments.sortby)> 
              
           <cfquery datasource="#variables.dsn#" name="getnewAgent">
                       select  equipmentID,equipmentname  from Equipments
                       where 1=1
                       order by #arguments.sortby# #arguments.sortorder#;
           </cfquery>
                     
          <cfreturn getnewAgent>               
                       
     </cfif>
             <cfreturn qrygetcustomers>
</cffunction>
<!---Add Equipment Information---->
<cffunction name="Addequipment" access="public" output="false" returntype="any">
   <cfargument name="formStruct" type="struct" required="no" />
      <cfif isdefined('arguments.formStruct.PEPCODE')>
  			<cfset PEPcode=True>
  		<cfelse>
  			<cfset PEPcode=False>
  		</cfif>

      <cfif isdefined('arguments.formStruct.driverowned')>
        <cfset driverowned=True>
      <cfelse>
        <cfset driverowned=False>
      </cfif>

      <cfquery name="insertquery" datasource="#variables.dsn#">
       insert into Equipments(
          EquipmentCode,EquipmentName,IsActive,CreatedBy,LastModifiedBy,CreatedDateTime,LastModifiedDateTime,CreatedByIP,GUID,PEPCode,Length,Width,TranscoreCode,PosteverywhereCode,ITSCode,LoadboardCode
          <cfif structKeyExists(arguments.formStruct, "unitNumber")>
              ,unitNumber, vin, licensePlate, Driver, driverowned, Notes
          </cfif>
          <cfif structKeyExists(arguments.formStruct, "tagexpirationdate") AND arguments.formStruct.tagexpirationdate NEQ "">
            ,tagexpirationdate 
          </cfif>
          <cfif structKeyExists(arguments.formStruct, "annualDueDate") AND arguments.formStruct.annualDueDate NEQ "">
            ,annualDueDate
          </cfif>
        )
       values(
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.EquipmentCode#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.EquipmentName#">,
              <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.Status#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
              <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
              <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">, 
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_USER_AGENT#">,
      			  '#PEPcode#',
      			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(arguments.formStruct.Length)#">,  
      			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(arguments.formStruct.Width)#">,
      			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.TranscoreCode#">,
      			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.PosteverywhereCode#">,
      			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.ITSCode#">   ,       
      			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.123loadboardcode#">
              <cfif structKeyExists(arguments.formStruct, "unitNumber")>
                  ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.unitNumber#">
                  ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.vin#">
                  ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.licensePlate#">                  
                  ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Driver#">
                  ,<cfqueryparam cfsqltype="cf_sql_bit" value="#driverowned#">
                  ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Notes#">
              </cfif>
              <cfif structKeyExists(arguments.formStruct, "tagexpirationdate") AND arguments.formStruct.tagexpirationdate NEQ "">
                  ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.tagexpirationdate#">
              </cfif>
              <cfif structKeyExists(arguments.formStruct, "annualDueDate") AND arguments.formStruct.annualDueDate NEQ "">
                  ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.annualDueDate#">
              </cfif>
              )
   </cfquery>
   <cfreturn "Equipment has been added Successfully">	    	
</cffunction>
<!---Update Equipment --->
<cffunction name="Updateequipment" access="public" output="false" returntype="any">
    <cfargument name="formStruct" type="struct">
	 <cfargument name="editid" type="any">
	 <cfif isdefined('arguments.formStruct.PEPCODE')>
  		<cfset PEPcode=True>
  	<cfelse>
  		<cfset PEPcode=False>
  	</cfif> 

  <cfif isdefined('arguments.formStruct.driverowned')>
    <cfset driverowned=True>
  <cfelse>
    <cfset driverowned=False>
  </cfif>

    <cfquery name="qryupdate" datasource="#variables.dsn#">
         update Equipments
         set  EquipmentCode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.EquipmentCode#">,
              EquipmentName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.EquipmentName#">,
              IsActive=<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.Status#">,
              UpdatedByIP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
      			  PEPCode='#PEPcode#',
      			  Length=<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(arguments.formStruct.Length)#">, 
      			  Width=<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(arguments.formStruct.Width)#">, 
      			  TranscoreCode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.TranscoreCode#">,
      			  PosteverywhereCode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.PosteverywhereCode#">,
      			  ITSCode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.ITSCode#">,
      			  LoadboardCode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.123LoadboardCode#">
              <cfif structKeyExists(arguments.formStruct, "unitNumber")>
                  ,unitNumber=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.unitNumber#">
              </cfif>
              <cfif structKeyExists(arguments.formStruct, "vin")>
                  ,vin=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.vin#">
              </cfif>
              <cfif structKeyExists(arguments.formStruct, "licensePlate")>
                  ,licensePlate=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.licensePlate#">
              </cfif>
              <cfif structKeyExists(arguments.formStruct, "tagexpirationdate")>
                  ,tagexpirationdate=<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.tagexpirationdate#">
              </cfif>
              <cfif structKeyExists(arguments.formStruct, "annualDueDate")>
                  ,annualDueDate=<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.annualDueDate#">
              </cfif>
              <cfif structKeyExists(arguments.formStruct, "Driver")>
                  ,Driver=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Driver#">
                  <cfif isDefined("driverowned")>
                      ,driverowned=<cfqueryparam cfsqltype="cf_sql_bit" value="#driverowned#">
                  </cfif>
              </cfif>              
              <cfif structKeyExists(arguments.formStruct, "Notes")>
                  ,Notes=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Notes#">
              </cfif>
        where EquipmentID='#arguments.formStruct.editid#' 
     </cfquery>
     <cfreturn "Equipment has been updated Successfully">
</cffunction>
<!--- Delete Equipment---->
<cffunction name="deleteEquipments"  access="public" output="false" returntype="any">
<cfargument name="EquipmentID" type="any" required="yes">
    <cftry>
    		<cfquery name="qryDelete" datasource="#variables.dsn#">
    			 delete from Equipments where  EquipmentID='#arguments.EquipmentID#'
    		</cfquery>
    		<cfreturn "Equipments has been deleted successfully.">	
    		<cfcatch type="any">
    			<cfreturn "Delete operation has been not successfull.">
    		</cfcatch>
    	</cftry>
</cffunction>  
<cffunction name="getSearchedEquipment" access="public" output="false" returntype="query">
	<cfargument name="searchText" required="yes" type="any">
	<CFSTOREDPROC PROCEDURE="searchEquipment" DATASOURCE="#variables.dsn#"> 
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