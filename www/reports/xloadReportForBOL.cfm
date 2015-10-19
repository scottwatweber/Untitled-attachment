<cfoutput>
<cfinclude template="../webroot/Application.cfm">
 
<cfif structkeyexists(url,"loadno") or structkeyexists(url,"loadid")>
	<cfquery name="BOLReport" datasource="#Application.dsn#">
		SELECT top 5 l.Loadid,l.LoadNumber,
		l.CustomerPONo as RefNo,
		[Address]  as custaddress,
		[City] as custcity,
		[Statecode] as custstate,
		[PostalCode] as custpostalcode,
		[Phone] as custphone,
		[Fax] as custfax,
		[Cellno] as custcell,
		[CustName] as custname,
		EmergencyResponseNo,
		CodAmt,
		CodFee,
		DeclaredValue,
		Notes,
		shipperState,
		shipperCity,
		consigneeState,
		consigneeCity,
		CarrierName,
		LoadStopID,
		StopNo,
		[NewPickupDate] as PickupDate,
		[NewPickupTime] as PickupTime,
		[NewDeliveryDate] as DeliveryDate,
		[NewDeliveryTime] as DeliveryTime,
		shipperStopName,
		consigneeStopName,
		shipperLocation,
		consigneeLocation,
		[shipperPostalCode],
		[consigneePostalCode],
		shipperContactPerson,
		consigneeContactPerson,
		shipperPhone,
		consigneePhone,
		shipperFax,
		consigneeFax,
		shipperEmailID,
		consigneeEmailID,
		shipperBlind,
		consigneeBlind,
		shipperDriverName,
		consigneeDriverName,
		<!--- SrNo,ISNULL(Qty,0),Description,ISNULL(Weight,0),ClassID,Hazmat,LoadStopIDBOL --->
		SrNo,ISNULL(Qty,0) as Qty,Description,ISNULL(Weight,0) as Weight,ClassID,Hazmat,LoadStopIDBOL,CarrierTerms
		FROM LOADS l
		left outer join (select 
		a.LoadID,
		a.LoadStopID,a.StopNo,
		a.NewCarrierID,
		a.NewOfficeID,
		a.City AS shipperCity,
		b.City AS consigneeCity,
		a.custName AS shipperStopName,
		b.custName AS consigneeStopName,
		a.Address AS shipperLocation,
		b.Address AS consigneeLocation,
		a.PostalCode AS shipperPostalCode,
		b.PostalCode AS consigneePostalCode,
		a.ContactPerson AS shipperContactPerson,
		b.ContactPerson AS consigneeContactPerson,
		a.Phone AS shipperPhone,
		b.Phone AS consigneePhone,
		a.fax AS shipperFax,
		b.fax AS consigneeFax,
		a.EmailID AS shipperEmailID,
		b.EmailID AS consigneeEmailID,
		a.StopDate AS shipperStopDate,
		b.StopDate AS consigneeStopDate,
		a.StopTime AS shipperStopTime,
		b.StopTime AS consigneeStopTime,
		a.TimeIn AS shipperStopTimeIn,
		b.TimeIn AS consigneeStopTimeIn,
		a.TimeOut AS shipperStopTimeOut,
		b.TimeOut AS consigneeStopTimeOut,
		a.ReleaseNo AS shipperReleaseNo,
		b.ReleaseNo AS consigneeReleaseNo,
		a.Blind AS shipperBlind,
		b.Blind AS consigneeBlind,
		a.Instructions AS shipperInstructions,
		b.Instructions AS consigneeInstructions,
		a.Directions AS shipperDirections,
		b.Directions AS consigneeDirections,
		a.LoadStopID AS shipperLoadStopID,
		b.LoadStopID AS consigneeLoadStopID,
		a.NewBookedWith AS shipperBookedWith,
		b.NewBookedWith AS consigneeBookedWith,
		a.NewEquipmentID AS shipperEquipmentID,
		b.NewEquipmentID AS consigneeEquipmentID,
		a.NewDriverName AS shipperDriverName,
		b.NewDriverName AS consigneeDriverName,
		a.NewDriverCell AS shipperDriverCell,
		b.NewDriverCell AS consigneeDriverCell,
		a.NewTruckNo AS shipperTruckNo,
		b.NewTruckNo AS consigneeTruckNo,
		a.NewTrailorNo AS shipperTrailorNo,
		b.NewTrailorNo AS consigneeTrailorNo,
		a.RefNo AS shipperRefNo,
		b.RefNo AS consigneeRefNo,
		a.Miles AS shipperMiles,
		b.Miles AS consigneeMiles,
		a.CustomerID AS shipperCustomerID,
		b.CustomerID AS consigneeCustomerID,
		a.StateCode as shipperState,
		b.StateCode as consigneeState
		from LoadStops a 
		join LoadStops b on a.LoadID = b.LoadID and a.StopNo = b.StopNo
		where a.LoadID = '#url.loadid#'
		and a.LoadType = 1
		and b.LoadType = 2
		and a.forbol =1
		and b.forbol =1)
		<!--- and (a.forbol =1)
		and (b.forbol =1)) --->
		as stops  on stops.loadid = l.loadid
		left outer join (SELECT [CarrierID],[CarrierName] FROM [Carriers]) as carr on carr.CarrierID = stops.NewCarrierID
		left outer join (select CarrierTerms from dbo.SystemConfig ) as CarrierTerms on 1=1
		left outer join 
		(select ISNULL(SrNo,'') as SrNo ,ISNULL(Qty,0) as Qty,ISNULL(Description,'') as Description,ISNULL(Weight,0) as Weight,ClassName as classid,ISNULL(Hazmat,'') as Hazmat,LoadStopIDBOL as LoadStopIDBOL from dbo.LoadStopsBOL left Join dbo.CommodityClasses on dbo.LoadStopsBOL.ClassID = dbo.CommodityClasses.ClassID) as BOL on BOL.LoadStopIDBOL =  l.loadid
		where l.LoadID = '#url.loadid#'
		
		order by loadnumber
	</cfquery>
	
	<cfreport format="PDF" template="BOLReport.cfr" query="#BOLReport#">
	</cfreport> 	 
<cfelse>
	Unable to generate the report. Please specify the load Number or Load ID	
</cfif>
</cfoutput>	