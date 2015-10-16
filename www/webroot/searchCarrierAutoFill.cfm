<cfoutput>
	
	<cfquery name="qSystemSetupOptions" datasource="#Application.dsn#">
    	SELECT showExpiredInsuranceCarriers
        FROM SystemConfig
    </cfquery>
	<cfif url.loadid NEQ "">
		<cfquery name="qGetNewDeliveryDate" datasource="#Application.dsn#">
			SELECT NewDeliveryDate
			FROM loads 
			where 
				loadid =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.loadid#">
		</cfquery>
	</cfif>
	
	<cfquery name="qrygetFilterCarriers" datasource="#Application.dsn#">
		<!---
		SELECT upper(LTRIM(CarrierNAME)) Text , car.CarrierID Value,car.Cel AS cell, car.Fax,car.EmailID,upper(CarrierNAME)AS carrierName,
		car.City, GETDATE() AS currentDate, car.StateCode,car.zipcode,car.Address, car.InsExpDate,
		Phone phone,
		Case car.Status WHEN 1 THEN 'ACTIVE' ElSE 'INACTIVE' end Status
		FROM Carriers car
		where (ltrim(CarrierNAME) like '#url.q#%' OR MCNumber = '#url.q#' ) 
		AND car.Status = 1
		<cfif qSystemSetupOptions.showExpiredInsuranceCarriers EQ false>
			AND car.InsExpDate >= GETDATE()
		</cfif>
		--->
		SELECT upper(LTRIM(CarrierNAME)) Text , car.CarrierID Value,car.Cel AS cell, car.Fax,car.EmailID,upper(CarrierNAME)AS carrierName,
		car.City, GETDATE() AS currentDate, car.StateCode,car.zipcode,car.Address, car.InsExpDate,
		Phone phone,
		Case car.Status WHEN 1 THEN 'ACTIVE' ElSE 'INACTIVE' end Status
		FROM Carriers car
		where (ltrim(CarrierNAME) like '#url.term#%' OR MCNumber = '#url.term#' ) 
		AND car.Status = 1
		<cfif qSystemSetupOptions.showExpiredInsuranceCarriers EQ false AND url.loadid NEQ "" AND qGetNewDeliveryDate.recordcount> 
			AND car.InsExpDate <= <cfqueryparam value="#qGetNewDeliveryDate.NewDeliveryDate#">
		</cfif>
	</cfquery>
</cfoutput>
<cfoutput>
[
	<cfset isFirstIteration='yes'>
	<cfloop query="qrygetFilterCarriers">
		<cfif isFirstIteration EQ 'no'>,</cfif>
		<cfif TRIM(qrygetFilterCarriers.InsExpDate) EQ ''>
			<cfset insuranceExpired = 'yes'>
		<cfelseif url.loadid NEQ "">
			<cfset dateDif = DateCompare(DateFormat(qrygetFilterCarriers.InsExpDate,'yyyy/mm/dd'), DateFormat(qGetNewDeliveryDate.NewDeliveryDate,'yyyy/mm/dd'))>
			<cfif dateDif LTE 0>
				<cfset insuranceExpired = 'yes'>
			<cfelse>
				<cfset insuranceExpired = 'no'>
			</cfif>
		<cfelse>
			<cfset insuranceExpired = 'no'>
		</cfif>
		<cfset isFirstIteration='no'>
			{
				"label": "#replace(TRIM(qrygetFilterCarriers.carrierName),'"','&apos;','all')#",
				"value": "#replace(TRIM(qrygetFilterCarriers.value),'"','&apos;','all')#",
				"name" : "#replace(TRIM(qrygetFilterCarriers.carrierName),'"','&apos;','all')#",
				"location": "#replace(TRIM(qrygetFilterCarriers.Address),'"','&apos;','all')#",
				"city" : "#replace(TRIM(qrygetFilterCarriers.City),'"','&apos;','all')#",
				"state": "#replace(TRIM(qrygetFilterCarriers.StateCode),'"','&apos;','all')#",
				"zip": "#replace(TRIM(qrygetFilterCarriers.zipCode),'"','&apos;','all')#",
				"phoneNo": "#replace(TRIM(qrygetFilterCarriers.phone),'"','&apos;','all')#",
				"cell": "#replace(TRIM(qrygetFilterCarriers.cell),'"','&apos;','all')#",
				"fax": "#replace(TRIM(qrygetFilterCarriers.fax),'"','&apos;','all')#",
				"InsExpDate": "#replace(TRIM(DateFormat(qrygetFilterCarriers.InsExpDate,'mm/dd/yyyy')),'"','&apos;','all')#",
				"email": "#replace(TRIM(qrygetFilterCarriers.emailID),'"','&apos;','all')#",
				"insuranceExpired" : "#replace(TRIM(insuranceExpired),'"','&apos;','all')#"
			}
	</cfloop>
]
</cfoutput>






