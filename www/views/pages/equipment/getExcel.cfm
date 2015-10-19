<cfsetting enablecfoutputonly="true">
<cfif structkeyexists(form,"DateFrom") and structkeyexists(form,"DateTo")>	
	<!---sscfquery name="getIftaDisplayData" datasource="#application.dsn#">
		select lm.loadnumber, sum(tollmiles) as tollmiles, sum(nontollmiles) as nontollmiles, sum(totalMiles) as totalMiles, state  
		from LoadIFTAMiles lm
		inner join Loads l on l.loadnumber = lm.loadnumber
		where 
		(l.NewDeliveryDate BETWEEN CONVERT(DATETIME, <cfqueryparam value="#form.DateFrom#" cfsqltype="cf_sql_timestamp">, 102) AND CONVERT(DATETIME, <cfqueryparam value="#form.DateTo#" cfsqltype="cf_sql_timestamp">, 102))
		group by state, lm.loadnumber
	</cfquery--->
	<cfquery name="getIftaDisplayData" datasource="#application.dsn#">
		select lm.loadnumber, sum(tollmiles) as tollmiles, sum(nontollmiles) as nontollmiles, sum(totalMiles) as totalMiles, lm.state
		from LoadIFTAMiles lm
		inner join Loads l on l.loadnumber = lm.loadnumber
		inner join loadstops ls on l.LoadID=ls.loadid
		where 
		(ls.stopdate BETWEEN CONVERT(DATETIME, <cfqueryparam value="#form.DateFrom#" cfsqltype="cf_sql_timestamp">, 102) AND CONVERT(DATETIME, <cfqueryparam value="#form.DateTo#" cfsqltype="cf_sql_timestamp">, 102))
		and ls.loadtype=<cfqueryparam value="2" cfsqltype="cf_sql_integer"> 
		and l.StatusTypeID not in(<cfqueryparam value="C126B878-9DB5-4411-BE4D-61E93FAB8C95" cfsqltype="cf_sql_varchar">,<cfqueryparam value="FBE06AA0-0868-48A9-A353-2B7CF8DA9F45" cfsqltype="cf_sql_varchar">,<cfqueryparam value="EBE06AA0-0868-48A9-A353-2B7CF8DA9F45" cfsqltype="cf_sql_varchar">)
		group by lm.state, lm.loadnumber
	</cfquery>
	<cfset queryAddColumn(getIftaDisplayData, "weight", "cf_sql_decimal", ArrayNew(1)) />
	<cfset queryAddColumn(getIftaDisplayData, "qty", "cf_sql_decimal", ArrayNew(1)) />
	<cfset queryAddColumn(getIftaDisplayData, "CarrCharges", "cf_sql_decimal", ArrayNew(1)) />
	<cfset queryAddColumn(getIftaDisplayData, "miles", "cf_sql_decimal",ArrayNew(1)) />
	<cfset queryAddColumn(getIftaDisplayData, "FuelGallons", "cf_sql_decimal",ArrayNew(1)) />
	<cfset queryAddColumn(getIftaDisplayData, "FuelCost", "cf_sql_decimal",ArrayNew(1)) />
	<cfset queryAddColumn(getIftaDisplayData, "truckName", "cf_sql_varchar", ArrayNew(1)) />
	<cfset queryAddColumn(getIftaDisplayData, "loadedmiles", "cf_sql_decimal",ArrayNew(1)) />
	<cfset queryAddColumn(getIftaDisplayData, "emptymiles", "cf_sql_decimal", ArrayNew(1)) />
	<cfloop query="#getIftaDisplayData#">
		<cfquery name="qryGetweight" datasource="#application.dsn#">
			select sum(lsc.weight) as weight, sum(lsc.qty) as qty,sum(CarrCharges) as CarrCharges,ift.state from loadstopcommodities lsc
			inner join loadstops ls on ls.loadstopid = lsc.loadstopid
			inner join loads l on l.loadid = ls.loadid
			inner join LoadIFTAMiles ift on ift.loadid=l.loadid
			where 
			l.loadnumber = <cfqueryparam value="#getIftaDisplayData.loadnumber#" cfsqltype="cf_sql_integer">
			AND ift.state = <cfqueryparam value="#getIftaDisplayData.state#" cfsqltype="cf_sql_varchar">
			group by ift.state
		</cfquery>
		<cfif len(qryGetweight.weight)>
			<cfset variables.weight=qryGetweight.weight>
		<cfelse>
			<cfset variables.weight=0>
		</cfif>
		<cfif len(qryGetweight.qty)>
			<cfset variables.qty=qryGetweight.qty>
		<cfelse>
			<cfset variables.qty=0>
		</cfif>
		<cfif len(qryGetweight.CarrCharges)>
			<cfset variables.CarrCharges=qryGetweight.CarrCharges>
		<cfelse>
			<cfset variables.CarrCharges=0>
		</cfif>
		<cfset querySetCell(getIftaDisplayData, "weight",variables.weight, getIftaDisplayData.currentRow) />
		<cfset querySetCell(getIftaDisplayData, "qty",variables.qty, getIftaDisplayData.currentRow) />
		<cfset querySetCell(getIftaDisplayData, "CarrCharges",variables.CarrCharges, getIftaDisplayData.currentRow) />
		
		<cfquery name="qryGetmiles" datasource="#application.dsn#">
			select sum(miles) as miles from loadstops ls 
			inner join loads l on l.LoadID = ls.loadid
			inner join LoadIFTAMiles ift on ift.loadid=l.loadid
			where 
			l.loadnumber = <cfqueryparam value="#getIftaDisplayData.loadnumber#" cfsqltype="cf_sql_integer">
			AND ift.state =  <cfqueryparam value="#getIftaDisplayData.state#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif len(qryGetmiles.miles)>
			<cfset variables.miles=qryGetmiles.miles>
		<cfelse>
			<cfset variables.miles=0>
		</cfif>
		<cfset querySetCell(getIftaDisplayData, "miles",variables.miles, getIftaDisplayData.currentRow) />
		<cfquery name="qryGettruckName" datasource="#application.dsn#">
			select eq.equipmentname from equipments eq
			inner join loadstops  ls on ls.newequipmentid=eq.equipmentid
			inner join loads l on l.LoadID = ls.loadid
			inner join LoadIFTAMiles ift on ift.loadid=l.loadid
			where 
			l.loadnumber = <cfqueryparam value="#getIftaDisplayData.loadnumber#" cfsqltype="cf_sql_integer">
			AND ift.state = <cfqueryparam value="#getIftaDisplayData.state#" cfsqltype="cf_sql_varchar">
			and ls.loadtype=<cfqueryparam value="2" cfsqltype="cf_sql_integer">
			order by ls.stopno asc
		</cfquery>
		<cfset querySetCell(getIftaDisplayData, "truckName",qryGettruckName.equipmentname, getIftaDisplayData.currentRow) />
		<cfif getIftaDisplayData.weight eq 0>
			<cfset variables.emptyMiles=0>
		<cfelse>
			<cfset variables.emptyMiles=getIftaDisplayData.miles>
		</cfif>
		<cfif getIftaDisplayData.weight eq 0>
			<cfset variables.loadedMiles=getIftaDisplayData.miles>
		<cfelse>
			<cfset variables.loadedMiles=0>
		</cfif>
		<cfset querySetCell(getIftaDisplayData, "loadedmiles",variables.loadedMiles, getIftaDisplayData.currentRow) />
		<cfset querySetCell(getIftaDisplayData, "emptymiles",variables.emptyMiles, getIftaDisplayData.currentRow) />
		<cfquery name="qryGetFuelDetails" datasource="#application.dsn#">
			select CASE WHEN u.UnitName = 'FGP-IFTA' THEN lsc.qty Else 0 END AS FuelGallons, CASE WHEN u.UnitName = 'FGP-IFTA' THEN lsc.CarrCharges else 0 END AS FuelCost from loadstopcommodities lsc
			inner join loadstops ls on ls.loadstopid = lsc.loadstopid
			INNER JOIN Units u ON lsc.UnitID = u.UnitID
			inner join loads l on l.loadid = ls.loadid
			inner join LoadIFTAMiles ift on ift.loadid=l.loadid
			where 1 = 1
			and l.loadnumber = <cfqueryparam value="#getIftaDisplayData.loadnumber#" cfsqltype="cf_sql_integer">
			AND ift.state = <cfqueryparam value="#getIftaDisplayData.state#" cfsqltype="cf_sql_varchar">
			Group BY u.UnitName,lsc.qty,lsc.CarrCharges 
		</cfquery>
		<cfquery name="qryFinalFueldetails" dbtype="query">
			 select sum(FuelGallons) as FuelGallons,sum(FuelCost) as FuelCost
			 from qryGetFuelDetails
		</cfquery>
		<cfif not qryFinalFueldetails.recordcount>
			<cfset variables.FuelGallons=0>
			<cfset variables.FuelCost=0>
		<cfelse>
			<cfset variables.FuelGallons=qryFinalFueldetails.FuelGallons>
			<cfset variables.FuelCost=qryFinalFueldetails.FuelCost>
		</cfif>
		<cfset querySetCell(getIftaDisplayData, "FuelGallons",variables.FuelGallons, getIftaDisplayData.currentRow) />
		<cfset querySetCell(getIftaDisplayData, "FuelCost",variables.FuelCost, getIftaDisplayData.currentRow) />
	</cfloop>
	<cfquery name="displayIftaData" dbtype="query">
	 select TRUCKNAME,state,sum(TOLLMILES) as TOLLMILES,sum(NONTOLLMILES) as NONTOLLMILES,sum(EMPTYMILES) as EMPTYMILES,sum(LOADEDMILES)as LOADEDMILES ,sum(totalMiles) as totalMiles,sum(FuelGallons) as FuelGallons,sum(FuelCost)as FuelCost
	 from getIftaDisplayData
	 group by state,TRUCKNAME
	 order by TRUCKNAME
	</cfquery>
	<cfheader name="content-disposition" value="attachment; filename=IftaTaxSummmary.csv">
	<cfcontent type="text/csv"> 
	<cfoutput>IFTA Date Report,#form.DateFrom#,#form.DateTo#,#chr(10)##chr(10)#</cfoutput>
	<cfoutput> 
		Truck,States,TollMiles,Non-TollMiles,TotalMiles,EmptyMiles,LoadedMiles,Fuel Gallons,Fuel Cost
		#chr(10)#
	</cfoutput>
	
	<cfloop query="displayIftaData">
		<cfoutput>
			#displayIftaData.TRUCKNAME#,#displayIftaData.state#,#displayIftaData.TOLLMILES#,#displayIftaData.totalMiles#,#displayIftaData.NONTOLLMILES#,#displayIftaData.EMPTYMILES#,#displayIftaData.LOADEDMILES#,#displayIftaData.FuelGallons#,#displayIftaData.FuelCost#
			#chr(10)#
		</cfoutput>
	</cfloop>
</cfif>	


<cfabort>