<cfoutput>
<cfsilent>
<cfimport taglib="../../../plugins/customtags/mytag/" prefix="myoffices" >	
<!---Init Default Value------->
<cfparam name="EquipmentCode" default="">
<cfparam name="ITSCode" default="">
<cfparam name="TranscoreCode" default="">
<cfparam name="PosteverywhereCode" default="">
<cfparam name="loadboardcode" default="">
<cfparam name="Length" default="">
<cfparam name="Width" default="">
<cfparam name="PEPcode" default="0">
<cfparam name="EquipmentName" default="">
<cfparam name="Status" default="">
<cfparam name="url.editid" default="0">
<cfparam name="url.equipmentid" default="0">
<cfparam name="unitNumber" default="">
<cfparam name="vin" default="">
<cfparam name="licensePlate" default="">
<cfparam name="tagexpirationdate" default="">
<cfparam name="annualDueDate" default="">
<cfparam name="Driver" default="">
<cfparam name="driverowned" default="0">
<cfparam name="Notes" default="">

<cfif isdefined("url.equipmentid") and len(trim(url.equipmentid)) gt 1>
	<cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" EquipmentID="#url.equipmentid#" returnvariable="request.qEquipments" />
	<cfif request.qEquipments.recordcount eq 1>
		<cfset EquipmentCode=request.qEquipments.EquipmentCode>
		<cfset EquipmentName=request.qEquipments.EquipmentName>
		<cfset PEPcode=request.qEquipments.PEPcode>
		<cfset Length=request.qEquipments.Length>
		<cfset Width=request.qEquipments.Width>
		<cfset ITSCode=request.qEquipments.ITSCode>
		<cfset TranscoreCode=request.qEquipments.TranscoreCode>
		<cfset PosteverywhereCode=request.qEquipments.PosteverywhereCode>
		<cfset Status=request.qEquipments.IsActive>
		<cfset editid=request.qEquipments.EquipmentID>
		<cfset LoadboardCode=request.qEquipments.LoadboardCode>		
		<cfset unitNumber=request.qEquipments.unitNumber>
		<cfset vin=request.qEquipments.vin>
		<cfset licensePlate=request.qEquipments.licensePlate>
		<cfset tagexpirationdate=request.qEquipments.tagexpirationdate>
		<cfset annualDueDate=request.qEquipments.annualDueDate>
		<cfset Driver=request.qEquipments.Driver>
		<cfset driverowned=request.qEquipments.driverowned>
		<cfset Notes=request.qEquipments.Notes>		
	</cfif>
</cfif>

<cfquery name="getDrivers" datasource="#application.DSN#">
	select DISTINCT carrierid, CarrierName from carriers
</cfquery>

</cfsilent>

<cfif isdefined("url.equipmentid") and len(trim(url.equipmentid)) gt 1>
<div class="search-panel"><div class="delbutton">
<cfif PEPcode neq 1><a href="index.cfm?event=equipment&equipmentid=#editid#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?');"></cfif>
  Delete <cfif PEPcode neq 1></a></cfif></div></div>	
<h1>Edit Equipment <span style="padding-left:180px;">#Ucase(EquipmentName)#</span></h1>
<cfelse>
<h1>Add New Equipment</h1>
</cfif>
<div class="white-con-area">
<div class="white-top"></div>
<div class="white-mid">
<cfform name="frmEquipment" action="index.cfm?event=addequipment:process&editid=#editid#&#session.URLToken#" method="post">
	<cfinput type="hidden" name="editid" value="#editid#">
	<div class="form-con">
	<fieldset>    
	    <label><strong>Equipment Code*</strong></label>
		<cfif PEPcode neq 1>
			<cfinput type="text" name="EquipmentCode"    value="#EquipmentCode#" size="25" required="yes" message="Please  enter the equipment code">
			<div class="clear"></div>  
			<label><strong>Description*</strong></label>
			<cfinput type="text" name="EquipmentName" value="#EquipmentName#" size="25" required="yes" message="Please  enter the equipment name">
		<cfelse>
			<cfinput type="text" name="EquipmentCode"    readonly  value="#EquipmentCode#" size="25" required="yes" message="Please  enter the equipment code">
			<div class="clear"></div>  
			<label><strong>Description*</strong></label>
			<cfinput type="text" name="EquipmentName"   readonly  value="#EquipmentName#" size="25" required="yes" message="Please  enter the description">
		</cfif>
        <div class="clear"></div>
		<label><strong>Length</strong></label>
        <cfinput type="text" name="Length" value="#Length#" size="4" maxlength="4" validate="integer"  style="width:40px" message="Please  enter the valid Length">
   		<label style="width:84px;"><strong>Width</strong></label>
        <cfinput type="text" name="Width" value="#Width#" size="4" maxlength="4" validate="integer" style="width:40px" message="Please  enter the valid Width">
		<div class="clear"></div>
				
		<label><strong>Unit Number</strong></label>
        <cfinput type="text" name="unitNumber" value="#unitNumber#" size="25" message="Please enter the unit number">
		<div class="clear"></div>
		
		<label><strong>VIN</strong></label>
        <cfinput type="text" name="vin" value="#vin#" size="25" message="Please enter the vin">
		<div class="clear"></div>
		
		<label><strong>License Plate##</strong></label>
        <cfinput type="text" name="licensePlate" value="#licensePlate#" size="25" message="Please enter the license plate">
		<div class="clear"></div>
		
		<label><strong>Tag Expiration Date</strong></label>
		<cfinput class="" name="tagexpirationdate" id="tagexpirationdate" value="#dateformat(tagexpirationdate,'mm/dd/yyyy')#" type="datefield" style="width:75px;" validate="date" readOnly />
		<div class="clear"></div>
		
		<label><strong>Annual Due Date</strong></label>
		<cfinput class="" name="annualDueDate" id="annualDueDate" value="#dateformat(annualDueDate,'mm/dd/yyyy')#" type="datefield" style="width:75px;" validate="date" readOnly />
		<div class="clear"></div>
		
		<label><strong>Driver</strong></label>
		<select name="Driver" style="width:65px;">
			<cfloop query="getDrivers">
				<option value="#getDrivers.carriername#" <cfif Driver EQ getDrivers.carriername> selected </cfif> >#getDrivers.carriername#</option>
			</cfloop>
        </select>
		
		<label><strong>Driver Owned?</strong></label>
		<input type="checkbox" name="driverowned" id="driverowned" value="1" <cfif driverowned EQ 1> checked="checked" </cfif>  style="width:20px;">
		<div class="clear"></div>
		
		<label><strong>Active*</strong></label>
        <select name="Status">
          <option value="1" <cfif Status eq '1'>selected="selected" </cfif>>Active</option>
          <option value="0" <cfif Status eq '0'>selected="selected" </cfif>>InActive</option>
        </select>
	 <!---  <div class="clear"></div>
		<label><strong>Post Everwhere</strong></label>
         <input name="PEPcode" ID="PEPcode" type="checkbox"  style="border:none; float:left;width: 20px " <cfif PEPcode eq 1> checked="checked" </cfif> value=""  />
        <div class="clear"></div> --->
    </fieldset>
    </div>
    <div class="form-con">
		<fieldset>
			<label style="text-align:left;"><strong>Notes</strong></label>
			<div class="clear"></div>
			<textarea name="notes" id="notes" style="width:300px;">#notes#</textarea>
			<div class="clear"></div>
			
			<label><strong>123Loadboard Code</strong></label><input type="text" name="123LoadboardCode" value="#LoadboardCode#" size="25">
			<div class="clear"></div>
			
			<label><strong>ITS Code</strong></label><input type="text" name="ITSCode" value="#ITSCode#" size="25">
			<div class="clear"></div>
			
			<label><strong>Transcore360 Code</strong></label><input type="text" name="TranscoreCode" value="#TranscoreCode#" size="25">
			<div class="clear"></div>
			
			<label><strong>Posteverywhere Code</strong></label><input type="text" name="PosteverywhereCode" value="#PosteverywhereCode#" size="25">
		
			<div class="clear"></div>
			<div style="padding-left:150px;"><input  type="submit" name="submit" onclick="return validateEquipment(frmEquipment);" class="bttn" value="Save Equipment" style="width:112px;"     /><input  type="button" onclick="javascript:history.back();" name="back" class="bttn" value="Back" style="width:70px;" /></div>
			<div class="clear"></div>  		
		</fieldset>
	</div>
    </cfform>
   <div class="clear"></div>
<cfif isDefined("url.equipmentid") and len(url.equipmentid) gt 1>
<p id="footer" style="padding-left:10px;font-family:Verdana, Geneva, sans-serif; font-style:italic bold; text-transform:uppercase;font-family:Verdana, Geneva, sans-serif; font-style:italic; text-transform:uppercase;width:80%;">Last Updated:<cfif isDefined("request.qEquipments")>&nbsp;&nbsp;&nbsp; #request.qEquipments.LastModifiedDateTime#&nbsp;&nbsp;&nbsp;#request.qEquipments.LastModifiedBy#</cfif></p>
</cfif> 
</div>

<div class="white-bot"></div>
</div>
</cfoutput>


