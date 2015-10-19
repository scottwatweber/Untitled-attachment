<!---<cfparam name="message" default="">
<cfparam name="url.sortorder" default="desc">
<cfparam name="sortby"  default="">--->
<cfparam name="MailTo" default="">
<cfparam name="MailFrom" default="">
<cfparam name="Subject" default="">
<cfparam name="body" default="">
<cfset Secret = application.dsn>
<cfset TheKey = 'NAMASKARAM'>
<cfset Encrypted = Encrypt(Secret, TheKey)>
<cfset dsn = ToBase64(Encrypted)>
<cfscript>
	variables.objequipmentGateway = getGateway("gateways.equipmentgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
	variables.objCutomerGateway = getGateway("gateways.customergateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
</cfscript>
<cfsilent>
<cfparam name="loadID" default="">
<cfinvoke component="#variables.objloadGateway#" method="getCompanyInformation" returnvariable="request.qGetCompanyInformation" />
<cfinvoke component="#variables.objloadGateway#" method="getcurAgentMaildetails" returnvariable="request.qcurAgentdetails" employeID="#session.empid#" />
<cfinvoke component="#variables.objloadGateway#" AuthLevelId="1" method="getSalesPerson" returnvariable="request.qSalesPerson" />
<cfinvoke component="#variables.objloadGateway#" AuthLevelId="3" method="getSalesPerson" returnvariable="request.qDispatcher" />
<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />
<cfinvoke component="#variables.objequipmentGateway#" method="getloadEquipments" returnvariable="request.qEquipments" />
<cfinvoke component="#variables.objCutomerGateway#" method="getAllpayerCustomers" returnvariable="request.qryCustomersList" />
<cfinvoke component="#variables.objloadGateway#" method="getcurAgentMaildetails" returnvariable="request.qcurMailAgentdetails" employeID="#session.empid#" />
<cfset MailFrom=request.qcurAgentdetails.EmailID>
<cfset Subject = request.qGetSystemSetupOptions.SalesHead>
	<cfif request.qcurMailAgentdetails.recordcount gt 0 and (request.qcurMailAgentdetails.SmtpAddress eq "" or request.qcurMailAgentdetails.SmtpUsername eq "" or request.qcurMailAgentdetails.SmtpPort eq "" or request.qcurMailAgentdetails.SmtpPassword eq "" or request.qcurMailAgentdetails.SmtpPort eq 0)>
	  <cfset mailsettings = "false">
  <cfelse>
	  <cfset mailsettings = "true">
  </cfif>
	<cfif request.qGetSystemSetupOptions.freightBroker>
		<cfset variables.freightBroker = "Carrier">
	<cfelse>
		<cfset variables.freightBroker = "Driver">
	</cfif>
</cfsilent>

<cfoutput>
<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
	<div style="float: left;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">Commission Report</h2></div>
</div>
<div style="clear:left"></div>

<div class="white-con-area">
	<div class="white-top"></div>
	
    <div class="white-mid">
	<cfform name="frmCommissionReport" action="##" method="post">

	<div class="form-con">
	<fieldset>
		<!---label style="text-align:left; padding:0 0px 0 65px;"---><h2>Group By</label>
        	<div class="clear"></div>
            <div style="width:110px; float:left;">&nbsp;</div>
            <div style="float:left;">
                <cfinput type="radio" name="groupBy" value="salesAgent" id="salesAgent" checked="yes" style="width:15px; padding:0px 0px 0 0px;"/>
                <label class="normal" for="salesAgent" style="text-align:left; padding:0 0 0 0;">Sales Agent</label>
            </div>
            <div class="clear"></div>
            <div style="width:110px; float:left;">&nbsp;</div>
            <div style="float:left;">
                <cfinput type="radio" name="groupBy" value="dispatcher" id="dispatcher"  style="width:15px; padding:0px 0px 0 0px;"/>
                <label class="normal" for="dispatcher" style="text-align:left; padding:0 0 0 0;">Dispatcher</label>
            </div>			
			<div class="clear"></div>
			<div style="width:110px; float:left;">&nbsp;</div>
            <div style="float:left;">
                <cfinput type="radio" name="groupBy" value="customer" id="customer"  style="width:15px; padding:0px 0px 0 0px;"/>
                <label class="normal" for="customer" style="text-align:left; padding:0 0 0 0;">Customer</label>
            </div>			
			 <div class="clear"></div>
            <div style="width:110px; float:left;">&nbsp;</div>
            <div style="float:left;">
                <cfinput type="radio" name="groupBy" value="#variables.freightBroker#" id="#variables.freightBroker#" style="width:15px; padding:0px 0px 0 0px;"/>
                <label class="normal" for="#variables.freightBroker#" style="text-align:left; padding:0 0 0 0;">#variables.freightBroker#</label>
            </div>            
            <div class="clear"></div>            
            
            <h2>Date</h2>
            <label>From</label>
	        <cfinput class="sm-input" name="dateFrom" id="dateFrom" value="#dateformat(Now()-30,'mm/dd/yyy')#" validate="date" required="yes" message="Please enter a valid date in Date From" type="datefield" />
        	<label style="margin-left: -54px;">To</label>
	        <cfinput class="sm-input" name="dateTo" id="dateTo" value="#dateformat(Now(),'mm/dd/yyy')#" validate="date" required="yes" message="Please enter a valid date in Date To" type="datefield" />
            <div class="clear"></div>
            
			<div width="100%">
				<div width="50%" style="float:left;margin-top:9px;">
					<h2>Commission</h2>
					<label>Deduction %</label>
					<cfinput class="sm-input" name="deductionPercent" id="deductionPercent" value="#NumberFormat(request.qGetSystemSetupOptions.DeductionPercentage,'0.00')#" validate="float" required="yes" message="Please enter a valid percentage in Deduction %"/>
					<div class="clear"></div>
					
					<label>Commission %</label>
					<cfinput class="sm-input" name="commissionPercent" id="commissionPercent" value="#NumberFormat(0,'0.00')#" validate="float" required="yes" message="Please enter a valid percentage in Commission %"/>
				</div>
				<div width="50%" style="float:left;margin-top:9px;">
					<h2 style="margin-left:50px">Margin Range</h2>
					<label>From </label>
					<cfinput class="sm-input" name="marginFrom" id="marginFrom" value="#DollarFormat(0)#" validate="float" required="yes" message="Please enter a valid amount in Margin From"/>
					<div class="clear"></div>
					
					<label>To </label>
					<cfinput class="sm-input" name="marginTo" id="marginTo" value="#DollarFormat(0)#" validate="float" required="yes" message="Please enter a valid amount in Margin To"/>
					<div class="clear"></div>
				</div>
			</div>
			<div class="clear"></div>
			<cfset loadStatus=request.qGetSystemSetupOptions.ARANDAPEXPORTSTATUSID>
			
			<h2 style="margin-top:14px;">Load Status</h2>
            <label>Status From</label>
			<cfinvoke component="#variables.objloadGateway#" method="getLoadStatus" returnvariable="request.qLoadStatus" /> 			
   			<select name="loadStatus" id="StatusTo">
				<cfloop query="request.qLoadStatus">
					<option value="#request.qLoadStatus.value#" <cfif loadStatus EQ  request.qLoadStatus.value>selected="selected"</cfif>>#request.qLoadStatus.Text#</option>
				</cfloop>
			</select>
		
			<label>Status To</label>					
			<cfinvoke component="#variables.objloadGateway#" method="getLoadStatus" returnvariable="request.qLoadStatus" /> 
   			<select name="loadStatus" id="StatusFrom">
				<cfloop query="request.qLoadStatus">
					<option value="#request.qLoadStatus.value#" <cfif loadStatus EQ  request.qLoadStatus.value>selected="selected"</cfif>>#request.qLoadStatus.Text#</option>
				</cfloop>
			</select>
			<div class="clear"></div>
            <h2 style="margin-top:12px;">Type</h2>
			<label>Report Type</label>
	        <cfselect name="reportType" id="reportType">
				<option value="Sales">Sales</option>
				<option value="Commission">Commission</option>
			</cfselect>
	</fieldset>
	</div>
	<div class="form-con">
		<fieldset>	

        <h2>Sales Rep</h2>
            <label>From </label>
	        <cfselect name="salesRepFrom" id="salesRepFrom">
            	<option value="########">########</option>
                <cfloop query="request.qSalesPerson">
					<option value="#request.qSalesPerson.EmployeeID#">#request.qSalesPerson.Name#</option>
				</cfloop>
                <option value="ZZZZ">ZZZZ</option>
            </cfselect>
            <div class="clear"></div>
            <label>To </label>
	        <cfselect id="salesRepTo" name="salesRepTo">
            	<option value="########">########</option>
                <cfloop query="request.qSalesPerson">
					<option value="#request.qSalesPerson.EmployeeID#">#request.qSalesPerson.Name#</option>
				</cfloop>
                <option value="ZZZZ" selected="selected">ZZZZ</option>
            </cfselect>
            <div class="clear"></div>
            
         <h2 style="margin-top:14px;">Dispatcher</h2>
            <label>From </label>
	        <cfselect name="dispatcherFrom" id="dispatcherFrom">
            	<option value="########">########</option>
                <cfloop query="request.qDispatcher">
		        	<option value="#request.qDispatcher.EmployeeID#">#request.qDispatcher.Name#</option>
		        </cfloop>
                <option value="ZZZZ">ZZZZ</option>
            </cfselect>
            <div class="clear"></div>
            <label>To </label>
	        <cfselect id="dispatcherTo" name="dispatcherTo">
            	<option value="########">########</option>
                <cfloop query="request.qDispatcher">
		        	<option value="#request.qDispatcher.EmployeeID#">#request.qDispatcher.Name#</option>
		        </cfloop>
                <option value="ZZZZ" selected="selected">ZZZZ</option>
            </cfselect>
            <div class="clear"></div>
			
			<h2 style="margin-top:14px;">Customer</h2>
			<label>From </label>
			<cfselect name="customerFrom" id="customerFrom">
				<option value="########">########</option>
				<cfloop query="request.qryCustomersList">
				<option value="#request.qryCustomersList.customerid#">#request.qryCustomersList.customername#</option>
				</cfloop>
				<option value="ZZZZ">ZZZZ</option>
			</cfselect>
			<div class="clear"></div>
			<label>To </label>
			<cfselect name="customerTo" id="customerTo">
				<option value="########">########</option>
				<cfloop query="request.qryCustomersList">
				<option value="#request.qryCustomersList.customerid#">#request.qryCustomersList.customername#</option>
				</cfloop>
				<option value="ZZZZ" selected="selected">ZZZZ</option>
			</cfselect>
			<div class="clear"></div>
			
			<h2 style="margin-top:14px;">Equipment</h2>
			<label>From </label>
			<cfselect name="equipmentFrom" id="equipmentFrom">
				<option value="########">########</option>
				<cfloop query="request.qEquipments">
				<option value="#request.qEquipments.equipmentID#">#request.qEquipments.equipmentname#</option>
				</cfloop>
				<option value="ZZZZ">ZZZZ</option>
			</cfselect>
			<div class="clear"></div>
			<label>To </label>
			<cfselect name="equipmentTo" id="equipmentTo">
				<option value="########">########</option>
				<cfloop query="request.qEquipments">
				<option value="#request.qEquipments.equipmentID#">#request.qEquipments.equipmentname#</option>
				</cfloop>
				<option value="ZZZZ" selected="selected">ZZZZ</option>
			</cfselect>
			<div class="clear"></div>
			<cfinput type="hidden" name="repUrl" id="repUrl" value="ss">
			<cfinput type="hidden" name="freightBroker" id="freightBroker" value="#variables.freightBroker#">            
			
            
        <div class="right" style="margin-top:39px;">
			<div style="cursor:pointer;width:27px;background-color: ##bfbcbc;float: left;margin: 1px 0;text-align: center;">
				<cfif request.qGetSystemSetupOptions.emailType EQ "Load Manager Email">
					<img id="salesReportImg" style="vertical-align:bottom;" src="images/black_mail.png" data-action="view">
				<cfelse>
					<a <cfif request.qGetCompanyInformation.ccOnEmails EQ true> href="mailto:#MailTo#?cc=#request.qGetCompanyInformation.email#&subject=#Subject#&" <cfelse> href="mailto:#MailTo#?subject=#Subject#"</cfif>>
						<img style="vertical-align:bottom;" src="images/black_mail.png">
					</a>
				</cfif>
				<!---<cfparam name="MailFrom" default="">
				<cfparam name="Subject" default="">--->
			</div>
			<input id="sReport" type="button" name="viewReport" class="bttn tooltip" value="View Report" style="width:95px;"  <cfif mailsettings>data-allowmail="true"<cfelse>data-allowmail="false"</cfif>/>
	    </div>
		</fieldset>
        <div class="clear"></div>
         <div id="message" class="msg-area" style="width:153px; margin-left:200px; display:none;"></div>
         <div class="clear"></div>
	</div>
   <div class="clear"></div>
 </cfform>
    </div>
    
	<div class="white-bot"></div>
</div>

<script type="text/javascript">
		$(document).ready(function(){
			$('##salesReportImg').click(function(){				
				// if(!$('##sReport').data('allowmail')) {
				// 	alert('You must setup your email address in your profile before you can email reports.');					
				// } else {
					var dsn='#dsn#';
					getCommissionReport('#session.URLToken#', 'mail',dsn);
				// }
				/*
				var action =  $(this).data('action');
				if(action == 'view')
				{
					 $(this).attr('src',"images/white_mail.png");
					 $(this).data('action','mail');
					 $('##sReport').attr('title','Mail Sales/Commission Report');
				}
				else if(action == 'mail')
				{
					 $(this).attr('src',"images/black_mail.png");
					 $(this).data('action','view');
					 $('##sReport').attr('title','View Sales/Commission Report');
				}
				*/
			 });
			 $('##sReport').click(function(){	
				var dsn='#dsn#';
				getCommissionReport('#session.URLToken#', 'view',dsn);
				/*
				var action =  $('##salesReportImg').data('action');
				if(action == 'mail')
				{
					if(!$(this).data('allowmail'))
					alert('You must setup your email address in your profile before you can email reports.');
					else
					getCommissionReport('#session.URLToken#');	
				}
				else
				getCommissionReport('#session.URLToken#');
				*/
			 });
		});		
		function sendmail(){
			var sub = "#Subject#";
			var mailTo = " ";
			myWindow=window.open("mailto:"+mailTo+"?subject="+sub,'','width=500,height=500');
			
		}
</script>

</cfoutput>