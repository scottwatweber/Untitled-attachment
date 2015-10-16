<cfscript>
	variables.objCarrierGateway = getGateway("gateways.carrierGateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
	variables.objequipmentGateway = getGateway("gateways.equipmentGateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
</cfscript>

<cfif  request.event neq 'login' AND request.event neq 'customerlogin'>
		<cfif (not isdefined("session.passport.isLoggedIn") or not(session.passport.isLoggedIn))>
			<!--- <cfset request.content = includeTemplate("views/security/loginform.cfm", true) />
			<cfset includeTemplate("views/templates/maintemplate.cfm") /> --->
		<cfelse>
		<cfswitch expression="#request.event#">
			<cfcase value="carrier">
				<!---<cfinvoke component="#variables.objCarrierGateway#" method="getAllCarriers" returnvariable="request.qCarrier" />--->
				<cfset request.subnavigation = includeTemplate("views/admin/carriernav.cfm", true) />
				<cfset request.content = includeTemplate("views/pages/carrier/disp_carrier.cfm", true) />
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
            
            <cfcase value="carrierselection">
				<!---<cfinvoke component="#variables.objCarrierGateway#" method="getAllCarriers" returnvariable="request.qCarrier" />--->
				<cfset request.subnavigation = includeTemplate("views/admin/carriernav.cfm", true) />
				<cfset request.content = includeTemplate("views/pages/carrier/disp_carrier_selection.cfm", true) />
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
            
			<cfcase value="addnewcarrier">
				<cfset request.subnavigation = includeTemplate("views/admin/carriernav.cfm", true) />
				<cfset request.content=includeTemplate("views/pages/carrier/addnew_carrier.cfm",true)/>
				<cfset includeTemplate("views/templates/maintemplate.cfm") />  
			</cfcase>
			<cfcase value="addnewcarrier:process">
			  <cfset request.subnavigation = includeTemplate("views/admin/carriernav.cfm", true) />
			  <cfset request.content=includeTemplate("views/pages/carrier/addnew_carrier.cfm",true)/>
			  <cfset includeTemplate("views/templates/maintemplate.cfm") /> 
			</cfcase>
			<cfcase value="addcarrier">
				 <cfinvoke component="#variables.objAgentGateway#" method="getAllCountries" returnvariable="request.qCountries" />
				 <cfinvoke component="#variables.objAgentGateway#" method="getAllStaes" returnvariable="request.qstates"/>
				 <!---<cfinvoke component="#variables.objAgentGateway#" method="getAllAgent" returnvariable="request.qAgent" />--->
				 <!---<cfinvoke component="#variables.objAgentGateway#" method="getOffices" returnvariable="request.qoffices"/>--->
				 <!---<cfinvoke component="#variables.objAgentGateway#" method="getAllRole" returnvariable="request.qRoles"/>--->
				 <!---<cfinvoke component="#variables.objAgentGateway#" method="getAllDispatcher" returnvariable="request.qDispatcher"/>--->
                 <!---<cfinvoke component="#variables.objCarrierGateway#" method="getCarrierOffice" returnvariable="request.qCarrierOffices"> --->
				<cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" returnvariable="request.qEquipments" />
                <!---  <cfinvoke component="#variables.objCarrierGateway#" method="getAllCarriers" returnvariable="request.qCarrier" /> --->
                  			
				 <cfset request.subnavigation = includeTemplate("views/admin/carriernav.cfm", true) />
                 <!--- <cfset request.content=includeTemplate("views/pages/carrier/addnew_carrier.cfm",true)/> --->
				 <cfset request.content=includeTemplate("views/pages/carrier/add_carrier.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>        
           
			<cfcase value="addcarrier:process">
                 <cfset formStruct = structNew()>
				 <cfset formStruct = form>
                 <cfif isdefined("form.editid") and len(form.editId) gt 1>
					<cfinvoke component="#variables.objCarrierGateway#" method="UpdateCarrier" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
				    </cfinvoke>
				<cfloop from="1" to="5" index="fldID"> 
					<cfinvoke component="#variables.objCarrierGateway#" method="UpdateCarrierOffices" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
					    <cfinvokeargument name="fieldID" value="#fldid#">               
		            </cfinvoke>
                </cfloop>
				 <cfelse>	 
				 
                   <cfinvoke component="#variables.objCarrierGateway#" method="AddCarrier" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
					<cfinvoke component="#variables.objCarrierGateway#" method="AddLIWebsiteData" returnvariable="message">
						 <cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				<cfloop from="1" to="5" index="fldID">    
					 <cfinvoke component="#variables.objCarrierGateway#" method="AddCarrierOffices" returnvariable="message">
					     <cfinvokeargument name="formStruct" value="#formStruct#">
					     <cfinvokeargument name="fieldID" value="#fldid#">               
					 </cfinvoke> 
                </cfloop>        
				 </cfif>
				<!---  <cfinvoke component="#variables.objCarrierGateway#" method="getCarrierOffice" returnvariable="request.qCarrierOffices" /> --->
                <!---<cfinvoke component="#variables.objCarrierGateway#" method="getAllCarriers" returnvariable="request.qCarrier" /> --->
                  
                 <cfset request.subnavigation = includeTemplate("views/admin/carriernav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/carrier/disp_carrier.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			
			<cfcase value="adddriver">
				<cfinvoke component="#variables.objAgentGateway#" method="getAllCountries" returnvariable="request.qCountries" />
				<cfinvoke component="#variables.objAgentGateway#" method="getAllStaes" returnvariable="request.qstates"/>
				<cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" returnvariable="request.qEquipments" />
                <cfset request.subnavigation = includeTemplate("views/admin/carriernav.cfm", true) />
                <cfset request.content=includeTemplate("views/pages/carrier/add_driver.cfm",true)/>
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>        
           
			<cfcase value="adddriver:process">
				<cfset formStruct = structNew()>
				<cfset formStruct = form>
				<cfif isdefined("form.editid") and len(form.editId) gt 1>
					<cfinvoke component="#variables.objCarrierGateway#" method="UpdateDriver" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
					</cfinvoke>
				<cfelse>	 
					<cfinvoke component="#variables.objCarrierGateway#" method="AddDriver" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
					</cfinvoke>
					<cfinvoke component="#variables.objCarrierGateway#" method="AddLIWebsiteData" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
					</cfinvoke>					     
				</cfif>
				<cfset request.subnavigation = includeTemplate("views/admin/carriernav.cfm", true) />
				<cfset request.content=includeTemplate("views/pages/carrier/disp_carrier.cfm",true)/>
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			
		</cfswitch>
		</cfif>
</cfif>
