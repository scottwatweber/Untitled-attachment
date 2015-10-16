<cfscript>
	variables.objequipmentGateway = getGateway("gateways.equipmentgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
</cfscript>
<cfif  request.event neq 'login' AND request.event neq 'customerlogin'>
		<cfif (not isdefined("session.passport.isLoggedIn") or not(session.passport.isLoggedIn))>
			<!--- <cfset request.content = includeTemplate("views/security/loginform.cfm", true) />
			<cfset includeTemplate("views/templates/maintemplate.cfm") /> --->
		<cfelse>
		<cfswitch expression="#request.event#">
			<cfcase value="equipment">			  
			    <cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" returnvariable="request.qEquipments" />
				<cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				<cfset request.content = includeTemplate("views/pages/equipment/disp_equipment.cfm", true) />
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addequipment">
                 <cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/equipment/addequipment.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addequipment:process">                   
				 <cfset formStruct = structNew()>
				 <cfset formStruct = form>
                 <cfif isdefined("form.editid") and len(form.editid) gt 1>
					<cfinvoke component="#variables.objequipmentGateway#" method="Updateequipment" returnvariable="message">
					   <cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				 <cfelse>	 
					 <cfinvoke component="#variables.objequipmentGateway#" method="Addequipment" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				 </cfif>
				 <!--- <cfoutput>#message#</cfoutput> --->
				 <cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" returnvariable="request.qEquipments" />
				 <cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/equipment/disp_equipment.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addDriverEquipment">
                 <cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/equipment/addDriverEquipment.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			
            <cfdefaultcase>
			</cfdefaultcase>
		</cfswitch>
		</cfif>
</cfif>
