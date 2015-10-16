<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="yes" />
		<cfset variables.dsn = Application.dsn />
	</cffunction>

	<!--- insert IFT Miles function --->
	<cffunction name="insertLoadIFTAMiles" access="public" returntype="void" >
		<cfargument name="loadNum" type="any">
		<cfargument name="NonTollMiles" default="0">
		<cfargument name="TollMiles" default="0">
		<cfargument name="TotalMiles" default="0">
		<cfargument name="State" default="">
		<cfargument name="datasource" default="">
		
		<cfquery name="qryInsertLoadIFTAMiles" datasource="#arguments.datasource#">
			insert into LoadIFTAMiles
			(
				loadNumber,
				tollMiles,
				nonTollMiles,
				totalMiles,
				state,
				dateCreated
			) 
			VALUES
			(
				<cfqueryparam value="#arguments.loadNum#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#arguments.tollMiles#" cfsqltype="cf_sql_double">,
				<cfqueryparam value="#arguments.nonTollMiles#" cfsqltype="cf_sql_double">,
				<cfqueryparam value="#arguments.totalMiles#" cfsqltype="cf_sql_double">,
				<cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			)
		</cfquery>
	</cffunction>

	<!--- delete IFT Miles function --->
	<cffunction name="deleteLoadIFTAMiles" access="public" returntype="void" >
		<cfargument name="datasource" default="">
		<cfargument name="loadNum" type="any" required="true">
		<cfquery name="qryDeleteLoadIFTAMiles" datasource="#arguments.datasource#">
			delete from 
				LoadIFTAMiles 
			where 
				loadNumber = <cfqueryparam value="#arguments.loadNum#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cffunction>

	<cffunction name="promilesCalculation" access="public" returntype="any">
		<cfargument name="frmstruct" type="struct" required="yes">
		<cfparam name="arguments.frmstruct.dsn" default="Iz0lOkkK">
		<!--- <cfdump var="#arguments#" /><cfabort /> --->
		<cfif structKeyExists(session,"empid")>
			<cfquery name="getProMileDetails" datasource="#Application.dsn#">
					select PCMilerUsername,PCMilerPassword,companyCode from Employees
					where EmployeeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.empid#"> 
			</cfquery>
		</cfif>
		<cfif getProMileDetails.recordcount>
			<cfset variables.Username=getProMileDetails.PCMilerUsername>
			<cfset variables.Password=getProMileDetails.PCMilerPassword>
			<cfset variables.CompanyCode=getProMileDetails.companyCode>
		</cfif>
		<Cfset variables.decryptedvar = decrypt(toString(toBinary(arguments.frmstruct.dsn)), 'load')>
		
		<cfif isdefined("arguments.frmstruct.fifthConAdd") and Len(trim(arguments.frmstruct.fifthConAdd)) gt 3> 
			<cfset variables.desinationValue = arguments.frmstruct.fifthConAdd>
		<cfelseif isdefined("arguments.frmstruct.fifthShpAdd") and Len(trim(arguments.frmstruct.fifthShpAdd)) gt 3> 
			<cfif (arguments.frmstruct.fourthShpAdd) neq (arguments.frmstruct.fifthShpAdd)> 
				<cfset variables.desinationValue = arguments.frmstruct.fifthShpAdd>
			</cfif>
		<cfelseif isdefined("arguments.frmstruct.fourthConAdd") and Len(trim(arguments.frmstruct.fourthConAdd)) gt 3> 
			<cfset variables.desinationValue = arguments.frmstruct.fourthConAdd>
		<cfelseif isdefined("arguments.frmstruct.fourthShpAdd") and Len(trim(arguments.frmstruct.fourthShpAdd)) gt 3> 
			<cfif (arguments.frmstruct.thirdShpAdd) neq (arguments.frmstruct.fourthShpAdd)> 
				<cfset variables.desinationValue = arguments.frmstruct.fourthShpAdd>
			</cfif>
		<cfelseif isdefined("arguments.frmstruct.thirdConAdd") and Len(trim(arguments.frmstruct.thirdConAdd)) gt 3> 
			<cfset variables.desinationValue = arguments.frmstruct.thirdConAdd>
		<cfelseif isdefined("arguments.frmstruct.thirdShpAdd") and Len(trim(arguments.frmstruct.thirdShpAdd)) gt 3> 
			<cfif (arguments.frmstruct.secShpAdd) neq (arguments.frmstruct.thirdShpAdd)> 
				<cfset variables.desinationValue = arguments.frmstruct.thirdShpAdd>
			</cfif>
		<cfelseif isdefined("arguments.frmstruct.secConAdd") and Len(trim(arguments.frmstruct.secConAdd)) gt 3>
			<cfset variables.desinationValue = arguments.frmstruct.secConAdd>
		<cfelseif isdefined("arguments.frmstruct.secShpAdd") and Len(trim(arguments.frmstruct.secShpAdd)) gt 3> 
			<cfif (arguments.frmstruct.frstShpAdd) neq (arguments.frmstruct.secShpAdd)> 
				<cfset variables.desinationValue = arguments.frmstruct.secShpAdd>
			</cfif>
		<cfelse>
			<cfset variables.desinationValue = arguments.frmstruct.consigneestate>
		</cfif>
		
		<cfoutput>
			<cfsavecontent variable="myVariable">
				<?xml version="1.0" encoding="utf-8"?>
				<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
					<soap:Body>
						<RunTrip xmlns="http://promiles.com/">
							<c>
								<Username>#variables.Username#</Username>
								<Password>#variables.Password#</Password>
								<CompanyCode>#variables.CompanyCode#</CompanyCode>
							</c>
							<Trip>
								<Options>
									<Routing>
										<RoutingMethod>PRACTICAL</RoutingMethod>
										<SpeedOverrides xsi:nil="true" />
										<BorderOpen>0</BorderOpen>
										<DoRouteOptimization>1</DoRouteOptimization>
										<RouteOptimizationMethod>NO_OPTIMIZATION</RouteOptimizationMethod>
										<IsHUBMode>0</IsHUBMode>
										<IsHazmat>0</IsHazmat>
										<AvoidTollRoads>0</AvoidTollRoads>
										<AllowRelaxRestrictions>1</AllowRelaxRestrictions>
									</Routing>
								</Options>
								<TripLegs>
									<TripLeg>
										<LocationText>#arguments.frmstruct.shippercity#</LocationText>
									</TripLeg>
									<cfset variables.locationContains = 0>
									<cfif variables.desinationValue NEQ arguments.frmstruct.consigneestate>
										<TripLeg>
											<LocationText>#arguments.frmstruct.consigneestate#</LocationText>
										</TripLeg>
										<cfset variables.locationContains = 1>
									</cfif>
									<cfif isdefined("arguments.frmstruct.secShpAdd") and Len(trim(arguments.frmstruct.secShpAdd)) gt 3 AND variables.desinationValue NEQ arguments.frmstruct.secShpAdd> 
										<cfif (arguments.frmstruct.frstShpAdd) neq (arguments.frmstruct.secShpAdd)>
											<cfif variables.locationContains EQ 1> , </cfif> <cfset variables.locationContains = 1>
											<TripLeg>
												<LocationText>#arguments.frmstruct.secShpAdd#</LocationText>
											</TripLeg>
										</cfif>
									</cfif>
									<cfif isdefined("arguments.frmstruct.secConAdd") and Len(trim(arguments.frmstruct.secConAdd)) gt 3 AND variables.desinationValue NEQ arguments.frmstruct.secConAdd>
										<cfif variables.locationContains EQ 1> , </cfif> <cfset variables.locationContains = 1>
										<TripLeg>
											<LocationText>#arguments.frmstruct.secConAdd#</LocationText>
										</TripLeg>
									</cfif>
									<cfif isdefined("arguments.frmstruct.thirdShpAdd") and Len(trim(arguments.frmstruct.thirdShpAdd)) gt 3 AND variables.desinationValue NEQ arguments.frmstruct.thirdShpAdd> 
										<cfif (arguments.frmstruct.secShpAdd) neq (arguments.frmstruct.thirdShpAdd)> 
											<cfif variables.locationContains EQ 1> , </cfif> <cfset variables.locationContains = 1>
											<TripLeg>
												<LocationText>#arguments.frmstruct.thirdShpAdd#</LocationText>
											</TripLeg>
										</cfif>
									</cfif>	
									<cfif isdefined("arguments.frmstruct.thirdConAdd") and Len(trim(arguments.frmstruct.thirdConAdd)) gt 3 AND variables.desinationValue NEQ arguments.frmstruct.thirdConAdd>
										<cfif variables.locationContains EQ 1> , </cfif> <cfset variables.locationContains = 1>
										<TripLeg>
											<LocationText>#arguments.frmstruct.thirdConAdd#</LocationText>
										</TripLeg>
									</cfif>
									<cfif isdefined("arguments.frmstruct.fourthShpAdd") and Len(trim(arguments.frmstruct.fourthShpAdd)) gt 3 AND variables.desinationValue NEQ arguments.frmstruct.fourthShpAdd> 
										<cfif (arguments.frmstruct.thirdShpAdd) neq (arguments.frmstruct.fourthShpAdd)>
											<cfif variables.locationContains EQ 1> , </cfif> <cfset variables.locationContains = 1>
											<TripLeg>
												<LocationText>#arguments.frmstruct.fourthShpAdd#</LocationText>
											</TripLeg>
										</cfif>
									</cfif>	
									<cfif isdefined("arguments.frmstruct.fourthConAdd") and Len(trim(arguments.frmstruct.fourthConAdd)) gt 3 AND variables.desinationValue NEQ arguments.frmstruct.fourthConAdd>
										<cfif variables.locationContains EQ 1> , </cfif> <cfset variables.locationContains = 1>
										<TripLeg>
											<LocationText>#arguments.frmstruct.fourthConAdd#</LocationText>
										</TripLeg>
									</cfif>
									<cfif isdefined("arguments.frmstruct.fifthShpAdd") and Len(trim(arguments.frmstruct.fifthShpAdd)) gt 3 AND variables.desinationValue NEQ arguments.frmstruct.fifthShpAdd> 
										<cfif (arguments.frmstruct.fourthShpAdd) neq (arguments.frmstruct.fifthShpAdd)>
											<cfif variables.locationContains EQ 1> , </cfif> <cfset variables.locationContains = 1>
											<TripLeg>
												<LocationText>#arguments.frmstruct.fifthShpAdd#</LocationText>
											</TripLeg>
										</cfif>
									</cfif>	
									<cfif isdefined("arguments.frmstruct.fifthConAdd") and Len(trim(arguments.frmstruct.fifthConAdd)) gt 3 AND variables.desinationValue NEQ arguments.frmstruct.fifthConAdd> 
										<cfif variables.locationContains EQ 1> , </cfif>
										<TripLeg>
											<LocationText>#arguments.frmstruct.fifthConAdd#</LocationText>
										</TripLeg>
									</cfif>
									<TripLeg>
										<LocationText>#variables.desinationValue#</LocationText>
									</TripLeg>
								</TripLegs> 
								<VehicleAndLoadDescription>
									<VehicleType>Tractor2AxleBobtail</VehicleType>
									<UseDefaultsForVehicleType>1</UseDefaultsForVehicleType>
								</VehicleAndLoadDescription>
								<GetDrivingDirections>0</GetDrivingDirections>
								<GetStateBreakout>1</GetStateBreakout>
								<GetFuelOptimization>0</GetFuelOptimization>
								<GetTripSummary>0</GetTripSummary>
								<GetItinerary>0</GetItinerary>
								<GetTruckStopsOnRoute>0</GetTruckStopsOnRoute>
								<GetTaxSummary>1</GetTaxSummary>
							</Trip>
						</RunTrip>
					</soap:Body>
				</soap:Envelope>
			</cfsavecontent>
		</cfoutput>
		<cfhttp url="http://prime.promiles.com/Webservices/v1_1/PRIMEStandardV1_1.asmx?op=RunTrip" method="post" result="httpResponse">
			<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
			<cfhttpparam type="header" name="Content-Length" value="length" />
			<cfhttpparam type="header" name="SOAPAction" value="http://promiles.com/RunTrip" />
			<cfhttpparam type="xml" value="#trim(myVariable)#" />
		</cfhttp>
	
		<cfset soapResponse = xmlParse(httpResponse.fileContent) />
			<cfinvoke  method="ConvertXmlToStruct" xmlNode="#soapResponse#" str="#structNew()#" returnvariable="xmlToStruct"/>
			<cfif IsDefined('xmlToStruct.Body.RunTripResponse.RunTripResult.Results')>
				<cfinvoke method="AddIFTATaxSummary" datasource="#application.dsn#" TaxSummaryDetails="#xmlToStruct.Body.RunTripResponse.RunTripResult.Results#" loadNum="#arguments.frmstruct.loadnumber#" returnvariable="response"/>
				<cfset resultArray = xmlToStruct.Body.RunTripResponse.RunTripResult.Results.StateMileage.StateBreakoutRow>
				<cfset nonTollMiles = arraynew(1)>
				<cfset tollMiles = arraynew(1)>
				<cfset totalMiles = arraynew(1)>
				<!--- <cfset deleteLoadIFTAMiles(datasource="#variables.decryptedvar#")> --->
				<cfif isStruct(resultArray)>
					<cfset myStruct = resultArray>
					<cfset resultArray = arraynew(1)>
					<cfset ArrayAppend(resultArray,myStruct)>
				</cfif>
				<cfinvoke method="deleteLoadIFTAMiles" datasource="#application.dsn#" loadNum="#arguments.frmstruct.loadnumber#"/>
				<cfloop from="1" to="#arraylen(resultArray)#" index="i">
				   <cfinvoke method="insertLoadIFTAMiles" loadNum="#arguments.frmstruct.loadnumber#" NonTollMiles="#resultArray[i].NonTollMiles#" TollMiles="#resultArray[i].TollMiles#" TotalMiles="#resultArray[i].TotalMiles#" State="#resultArray[i].State#" datasource="#variables.decryptedvar#"  returnvariable="xmlToStruct"/>
				</cfloop>
			</cfif>
	</cffunction>

	<!--- deleteIFTATaxSummary function --->
	<cffunction name="AddIFTATaxSummary" access="public" returntype="any" output="false" hint="Inserts all tax summary details">
		<cfargument name="TaxSummaryDetails" type="struct" required="true" />
		<cfargument name="loadNum" type="numeric" required="true" />
		<cfparam name="arguments.datasource" default="Iz0lOkkK">

		<cfinvoke method="getIFTATaxSummary" datasource="#application.dsn#" loadNum="#arguments.loadNum#" returnvariable="qIFTATaxSummary"/>
		<cfif qIFTATaxSummary.recordCount>
			<cfinvoke method="UpdateIFTATaxSummary" TaxSummaryDetails="#arguments.TaxSummaryDetails#" datasource="#application.dsn#" loadNum="#arguments.loadNum#" returnvariable="qIFTATaxSummary"/>
			<cfset TaxSummaryID = qIFTATaxSummary.TaxSummaryID>
			<cfinvoke method="DeleteTaxSummaryRows" datasource="#application.dsn#" loadNum="#arguments.loadNum#"/>
		<cfelse>
			<cfinvoke method="InsertIFTATaxSummary" TaxSummaryDetails="#arguments.TaxSummaryDetails#" datasource="#application.dsn#" loadNum="#arguments.loadNum#" returnvariable="TaxSummaryID"/>
		</cfif>
		<cfinvoke method="InsertIFTATaxSummaryRows" TaxSummaryDetails="#arguments.TaxSummaryDetails#" datasource="#application.dsn#" loadNum="#arguments.loadNum#" TaxSummaryID="#TaxSummaryID#"/>
		<cfreturn true />
	</cffunction>

	<!--- getIFTATaxSummary function --->
	<cffunction name="getIFTATaxSummary" access="public" returntype="Query" output="false" hint="get all tax summary details of a loadID">
		<cfargument name="loadNum" type="numeric" required="true" />
		<cfparam name="arguments.datasource" default="Iz0lOkkK">

		<cfquery name="qGetIFTATaxSummary" datasource="#arguments.datasource#">
			SELECT * FROM IFTATaxSummary WHERE loadNumber = <cfqueryparam value="#arguments.loadNum#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		<cfreturn qGetIFTATaxSummary />
	</cffunction>

	<!--- InsertIFTATaxSummary function --->
	<cffunction name="InsertIFTATaxSummary" access="public" returntype="any" output="false" hint="Insert tax summary details of a loadID">
		<cfargument name="TaxSummaryDetails" type="struct" required="true" />
		<cfargument name="loadNum" type="numeric" required="true" />
		<cfparam name="arguments.datasource" default="Iz0lOkkK">

		<cfquery name="qInsertIFTATaxSummary" datasource="#arguments.datasource#" result="result">
			INSERT INTO IFTATaxSummary(loadnumber, GallonsBurned, MPG, TotalIFTASurcharge, TotalIFTATax, TotalMileTax, TotalMiles, TotalTaxDue, TotalTaxableMiles)
			Values(
				<cfqueryparam value="#arguments.loadNum#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.GallonsBurned#" cfsqltype="cf_sql_float">,
				<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.MPG#" cfsqltype="cf_sql_float">,
				<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalIFTASurcharge#" cfsqltype="cf_sql_float">,
				<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalIFTATax#" cfsqltype="cf_sql_float">,
				<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalMileTax#" cfsqltype="cf_sql_float">,
				<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalMiles#" cfsqltype="cf_sql_float">,
				<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalTaxDue#" cfsqltype="cf_sql_float">,
				<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalTaxableMiles#" cfsqltype="cf_sql_float">
				)
		</cfquery>
		
		<cfreturn result.generatedkey />
	</cffunction>

	<!--- InsertIFTATaxSummary function --->
	<cffunction name="UpdateIFTATaxSummary" access="public" returntype="any" output="false" hint="Update tax summary details of a loadID">
		<cfargument name="TaxSummaryDetails" type="struct" required="true" />
		<cfargument name="loadNum" type="numeric" required="true" />
		<cfparam name="arguments.datasource" default="Iz0lOkkK">

		<cfquery name="qUpdateIFTATaxSummary" datasource="#arguments.datasource#">
			UPDATE IFTATaxSummary
			SET
				GallonsBurned = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.GallonsBurned#" cfsqltype="cf_sql_float">,
				MPG = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.MPG#" cfsqltype="cf_sql_float">,
				TotalIFTASurcharge = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalIFTASurcharge#" cfsqltype="cf_sql_float">,
				TotalIFTATax = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalIFTATax#" cfsqltype="cf_sql_float">,
				TotalMileTax = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalMileTax#" cfsqltype="cf_sql_float">,
				TotalMiles = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalMiles#" cfsqltype="cf_sql_float">,
				TotalTaxDue = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalTaxDue#" cfsqltype="cf_sql_float">,
				TotalTaxableMiles = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalTaxableMiles#" cfsqltype="cf_sql_float">
			
			WHERE
				loadnumber = <cfqueryparam value="#arguments.loadnum#" cfsqltype="cf_sql_float">
		</cfquery>
		
		<cfreturn qGetIFTATaxSummary />
	</cffunction>

	<!--- getIFTATaxSummary function --->
	<cffunction name="DeleteTaxSummaryRows" access="public" returntype="void" output="false" hint="Deletes all tax summary details of a loadID">
		<cfargument name="loadNum" type="numeric" required="true" />
		<cfparam name="arguments.datasource" default="Iz0lOkkK">

		<cfquery name="qDeleteTaxSummaryRow" datasource="#arguments.datasource#">
			DELETE FROM IFTATaxSummaryRow WHERE loadnumber = <cfqueryparam value="#arguments.loadNum#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cffunction>

	<!--- InsertIFTATaxSummaryRows function --->
	<cffunction name="InsertIFTATaxSummaryRows" access="public" returntype="void" output="false" hint="Insert Tax Summary Rows">
		<cfargument name="TaxSummaryDetails" type="struct" required="true" />
		<cfargument name="loadNum" type="numeric" required="true" />
		<cfargument name="TaxSummaryID" type="numeric" required="true" />
		<cfparam name="arguments.datasource" default="Iz0lOkkK">

		
		<cfloop array="#arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow#" index="rowDetails">
			<cfquery name="qInsertIFTATaxSummaryRows" datasource="#arguments.datasource#" result="result">
				INSERT INTO IFTATaxSummaryRow(TaxSummaryID,loadnumber, FuelBurned, GallonsPurchased, IFTASurcharge, IFTATax, IFTATaxRate, MileTax, PurchaseDifferenceGallons, StateAbbreviation, TaxableMiles, TollMiles, TotalMiles)
				Values(
					<cfqueryparam value="#arguments.TaxSummaryID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#arguments.loadNum#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#rowDetails.FuelBurned#" cfsqltype="cf_sql_float">,
					<cfqueryparam value="#rowDetails.GallonsPurchased#" cfsqltype="cf_sql_float">,
					<cfqueryparam value="#rowDetails.IFTASurcharge#" cfsqltype="cf_sql_float">,
					<cfqueryparam value="#rowDetails.IFTATax#" cfsqltype="cf_sql_float">,
					<cfqueryparam value="#rowDetails.IFTATaxRate#" cfsqltype="cf_sql_float">,
					<cfqueryparam value="#rowDetails.MileTax#" cfsqltype="cf_sql_float">,
					<cfqueryparam value="#rowDetails.PurchaseDifferenceGallons#" cfsqltype="cf_sql_float">,
					<cfqueryparam value="#rowDetails.StateAbbreviation#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#rowDetails.TaxableMiles#" cfsqltype="cf_sql_float">,
					<cfqueryparam value="#rowDetails.TollMiles#" cfsqltype="cf_sql_float">,
					<cfqueryparam value="#rowDetails.TotalMiles#" cfsqltype="cf_sql_float">
					)
			</cfquery>
		</cfloop>
		
	</cffunction>

	<!--- ConvertXmlToStruct function --->
	<cffunction name="ConvertXmlToStruct" access="public" returntype="struct" output="false" hint="Parse raw XML response body into ColdFusion structs and arrays and return it.">
		<cfargument name="xmlNode" type="string" required="true" />
		<cfargument name="str" type="struct" required="true" />
		<cfset var i = 0 />
		<cfset var axml = arguments.xmlNode />
		<cfset var astr = arguments.str />
		<cfset var n = "" />
		<cfset var tmpContainer = "" />
		<cfset axml = XmlSearch(XmlParse(arguments.xmlNode),"/node()")>
		<cfset axml = axml[1] />
		<cfloop from="1" to="#arrayLen(axml.XmlChildren)#" index="i">
			<cfset n = replace(axml.XmlChildren[i].XmlName, axml.XmlChildren[i].XmlNsPrefix&":", "") />
			<cfif structKeyExists(astr, n)>
				<cfif not isArray(astr[n])>
					<cfset tmpContainer = astr[n] />
					<cfset astr[n] = arrayNew(1) />
					<cfset astr[n][1] = tmpContainer />
				<cfelse>
				</cfif>
				<cfif arrayLen(axml.XmlChildren[i].XmlChildren) gt 0>
						<cfset astr[n][arrayLen(astr[n])+1] = ConvertXmlToStruct(axml.XmlChildren[i], structNew()) />
					<cfelse>
						<cfset astr[n][arrayLen(astr[n])+1] = axml.XmlChildren[i].XmlText />
				</cfif>
			<cfelse>
				<cfif arrayLen(axml.XmlChildren[i].XmlChildren) gt 0>
					<cfset astr[n] = ConvertXmlToStruct(axml.XmlChildren[i], structNew()) />
				<cfelse>
					<cfif IsStruct(aXml.XmlChildren[i].XmlAttributes) AND StructCount(aXml.XmlChildren[i].XmlAttributes) GT 0>
						<cfset astr[n] = axml.XmlChildren[i].XmlText />
						 <cfset attrib_list = StructKeylist(axml.XmlChildren[i].XmlAttributes) />
						 <cfloop from="1" to="#listLen(attrib_list)#" index="attrib">
							 <cfif ListgetAt(attrib_list,attrib) CONTAINS "xmlns:">
								<cfset Structdelete(axml.XmlChildren[i].XmlAttributes, listgetAt(attrib_list,attrib))>
							 </cfif>
						 </cfloop>
						 <cfif StructCount(axml.XmlChildren[i].XmlAttributes) GT 0>
							 <cfset astr[n&'_attributes'] = axml.XmlChildren[i].XmlAttributes />
						</cfif>
					<cfelse>
						 <cfset astr[n] = axml.XmlChildren[i].XmlText />
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn astr />
	</cffunction>
	
</cfcomponent>