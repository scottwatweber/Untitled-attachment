<cfparam name="url.loadid" default="0">
<cfparam name="MailTo" default="">
<cfparam name="MailFrom" default="">
<cfparam name="Subject" default="">
<cfparam name="body" default="">
<cfset loadID = "">
<cfif  structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1>
	<cfset loadID = url.loadid>
</cfif>
<cfinvoke component="#variables.objloadGateway#" method="getCompanyInformation" returnvariable="request.qGetCompanyInformation" />
<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />
<cfinvoke component="#variables.objloadGateway#" method="getLoadCarriersMails" loadid="#loadID#" returnvariable="request.qcarriers" />
<cfinvoke component="#variables.objloadGateway#" method="getcurAgentMaildetails" returnvariable="request.qcurAgentdetails" employeID="#session.empid#" />
<cfset SmtpAddress=request.qcurAgentdetails.SmtpAddress>
<cfset SmtpUsername=request.qcurAgentdetails.SmtpUsername>
<cfset SmtpPort=request.qcurAgentdetails.SmtpPort>
<cfset SmtpPassword=request.qcurAgentdetails.SmtpPassword>
<cfset FA_SSL=request.qcurAgentdetails.useSSL>
<cfset FA_TLS=request.qcurAgentdetails.useTLS>
<cfset MailFrom=request.qcurAgentdetails.EmailID>
<cfset MailTo=request.qcarriers>
<cfset Subject = request.qGetSystemSetupOptions.BOLHead>
	
<cfif IsDefined("form.send")>
	<cfif form.MailTo is not "" AND form.MailFrom is not "" AND form.Subject is not "">
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
		<cfoutput>
			<cfreport name="genPDF" format="PDF" template="BOLReport.cfr" query="#BOLReport#"> 
				<cfreportParam name="ReportDate" value="#DateFormat(Now(),'mm/dd/yyyy')#"> 
			</cfreport>
			<cftry>
				<cfif request.qGetCompanyInformation.ccOnEmails EQ true>
					<cfmail from='"#SmtpUsername#" <#SmtpUsername#>' subject="#form.Subject#" to="#form.MailTo#" CC="#request.qGetCompanyInformation.email#" type="text/plain" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" >
					#form.body#
						<cfmailparam
							file="#BOLReport.LoadNumber#.BOLReport.pdf"
							type="application/pdf"
							content="#genPDF#"
						/>
					</cfmail>
				<cfelse>
					<cfmail from='"#SmtpUsername#" <#SmtpUsername#>' subject="#form.Subject#" to="#form.MailTo#" type="text/plain" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" >
					#form.body#
					 <cfmailparam
						file="#BOLReport.LoadNumber#.BOLReport.pdf"
						type="application/pdf"
						content="#genPDF#"
						/>

					</cfmail>
				</cfif>
				<cfinvoke component="#variables.objloadGateway#" method="setLogMails" loadID="#loadID#" date="#Now()#" subject="#form.Subject#" emailBody="#form.body#" reportType="BOL" fromAddress="#SmtpUsername#" toAddress="#form.MailTo#" />
				<cfsavecontent variable="content">
					<div id="message" class="msg-area" style="width: 100%;display:block;"><p>Thank you, <cfoutput>#form.MailFrom#: your message has been sent</cfoutput>.</p></div>
				</cfsavecontent>
				<script>
					setTimeout(function(){ 
						window.close(); 
					}, 2000);				
				</script>
				<cfcatch>
					<cfsavecontent variable="content">
						<div id="message" class="msg-area" style="width: 100%;display:block;background: none repeat scroll 0 0 ##f4cbc8;border: 1px solid ##f2867a;"><p>The mail is not sent.</p></div>
					</cfsavecontent>
				</cfcatch>
			</cftry>
		</cfoutput>
	<cfelse>
		<cfoutput>
		<cfsavecontent variable="content">
			<div id="message" class="msg-area" style="width: 100%;display:block;background: none repeat scroll 0 0 ##f4cbc8;border: 1px solid ##f2867a;"><p>Please provide details like 'From', 'To' and 'Subject'.</p></div>
		</cfsavecontent>
		</cfoutput>
	</cfif>
<cfelse>
	Unable to generate the report. Please specify the load Number or Load ID	
</cfif>
					   
<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="X-UA-Compatible" content="IE=8" >
<script language="javascript" type="text/javascript" src="scripts/jquery-1.6.2.min.js"></script>	
<script language="javascript" type="text/javascript" src="scripts/jquery.form.js"></script>	
<link href="../webroot/styles/style.css" rel="stylesheet" type="text/css" />
<style>
	.progress { position:relative; width:400px; border: 1px solid ##ddd; padding: 1px; border-radius: 3px; }
	.bar { background-image:url("../webroot/images/pbar-ani.gif"); width:0%; height:20px; border-radius: 3px; }
	.percent { position:absolute; display:inline-block; top:3px; left:48%; }
	
	input.alertbox{
	border-color:##dd0000;
}
</style></head>
<body>
</body>  

<cfif isDefined('content')>
#content#
</cfif>
<p> 
<form action = "index.cfm?event=loadMail&type=BOL&loadid=#loadID#&#session.URLToken#" method="POST">
	<div class="white-mid" style=" border-top: 5px solid rgb(130, 187, 239);width: 100%;">
		<div class="form-con" style="width:auto;">
			<fieldset>
			<div style="color:##000000;font-size:14px;font-weight:bold;margin-bottom:20px;margin-top:10px;">BOL Report Mail</div>
			<div class="clear"></div>
			<label style="margin-top: 3px;">To:</label>
			<input style="width:500px;" type="Text" name="MailTo" class="mid-textbox-1" id="MailTo" value="#MailTo#">
			<div class="clear"></div>
			<label style="margin-top: 3px;">From:</label>
			<input style="width:500px;" type="Text" name="MailFrom" class="mid-textbox-1 disabledLoadInputs" id="MailFrom" value="#MailFrom#" readonly>
			<div class="clear"></div>
			<cfif request.qGetCompanyInformation.ccOnEmails EQ true>
				<label style="margin-top: 3px;">Cc:</label>
				<input style="width:500px;" type="Text" name="cCMail" class="mid-textbox-1 disabledLoadInputs" id="cCMail" value="#request.qGetCompanyInformation.email#" readonly>
				<div class="clear"></div>
			</cfif>
			<label style="margin-top: 3px;">Subject:</label>
			<input style="width:500px;" type="Text" name="Subject" class="mid-textbox-1" id="Subject" value="#Subject#">
			<div class="clear"></div>
			<label style="margin-top: 3px;">Mesage:</label>
			<textarea style="width:500px;height:180px;" class="addressChange" rows="" name="body" id="body" cols="">#body#</textarea>
			<div class="clear"></div>
			</fieldset>
		</div>
	</div>
	<div class="white-mid" style="width:auto;">
		<div class="form-con" style="bottom: 0px; position: absolute; background-color: rgb(130, 187, 239); width: 100%; padding: 2px 5px;">
			<fieldset>
				<div style="width:auto;">
					<input type = "Submit" name = "send" value="Send">
				</div>
			</fieldset>
		</div>
	</div>
</p> 
</form> 
</html>
</cfoutput>