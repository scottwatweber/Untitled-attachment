<!--- :::::
---------------------------------
Changing 571 Line Extra line comment of consigneeZipcode already use in getdistancenext.cfm page
---------------------------------
::::: --->

<cfoutput>
  <cfparam name="nextLoadStopId" default="">
  <cfparam name="nextLoadStopId" default="">
  <cfset ShipCustomerStopName ="">
  <cfset ConsineeCustomerStopName ="">
  <cfset ShipCustomerStopId ="">
  <cfset ConsigneeCustomerStopId ="">
  <cfset Shiplocation ="">
  <cfset Shipcity ="">
  <cfset Shipstate1 ="">
  <cfset Shipzipcode ="">
  <cfset ShipcontactPerson ="">
  <cfset ShipPhone ="">
  <cfset Shipfax ="">
  <cfset Shipemail ="">
  <cfset ShipPickupNo ="">
  <cfset ShippickupDate ="">
  <cfset ShippickupTime ="">
  <cfset ShiptimeIn ="">
  <cfset ShiptimeOut ="">
  <cfset ShipInstructions ="">
  <cfset Shipdirection ="">
  <cfset carrierIDNext ="">
  <cfset Consigneelocation ="">
  <cfset Consigneecity ="">
  <cfset Consigneestate1 ="">
  <cfset Consigneezipcode ="">
  <cfset ConsigneecontactPerson ="">
  <cfset ConsigneePhone ="">
  <cfset Consigneefax ="">
  <cfset Consigneeemail ="">
  <cfset ConsigneePickupNo ="">
  <cfset ConsigneepickupDate ="">
  <cfset ConsigneepickupTime ="">
  <cfset ConsigneetimeIn ="">
  <cfset ConsigneetimeOut ="">
  <cfset ConsigneeInstructions ="">
  <cfset Consigneedirection ="">
  <cfset shipBlind="False">
  <cfset ConsBlind="False">
  <cfset bookedwith1 ="">
  <cfset equipment1 ="">
  <cfset driver ="">
  <cfset driverCell ="">
  <cfset truckNo ="">
  <cfset TrailerNo ="">
  <cfset refNo ="">
  <cfset showItems = false>
  <cfset stofficeidNext="">
  <cfset loadIDN = "">
  <cfif isdefined("url.loadid") and len(trim(url.loadid)) gt 1 >
    <cfset loadIDN = url.loadid>
    <cfelseif isdefined("url.loadToBeCopied") and len(trim(url.loadToBeCopied)) gt 1>
    <cfset loadIDN = url.loadToBeCopied>
  </cfif>
  <cfif loadIDN neq "">
    <cfinvoke component="#variables.objloadGateway#" method="getAllLoads" loadid="#loadIDN#" stopNo="#StopNoIs#" returnvariable="request.qLoads" />
	<cfif request.qLoads.recordcount and len(request.qLoads.LOADSTOPID) gt 1>
      <cfinvoke component="#variables.objloadGateway#" method="getAllItems" LOADSTOPID="#request.qLoads.LOADSTOPID#" returnvariable="request.qItems" />
      <cfset showItems = true>
      <cfset nextLoadStopId = request.qLoads.LOADSTOPID>
      <cfset url.editid=loadIDN>
      <cfset loadIDN=loadIDN>
      <cfset LOADSTOPID = request.qLoads.LOADSTOPID>
      <cfset loadStatus=request.qLoads.STATUSTYPEID>
      <cfset Salesperson=request.qLoads.SALESREPID>
      <cfset Dispatcher=request.qLoads.DISPATCHERID>
      <cfset Notes=request.qLoads.NEWNOTES>
      <cfset posttoloadboard=request.qLoads.ISPOST>
      <cfset CustomerRate=request.qLoads.CUSTFLATRATE>
      <cfset CarrierRate=request.qLoads.CARRFLATRATE>
      <cfset TotalCustomerCharges=request.qLoads.TotalCustomerCharges>
      <cfset TotalCarrierCharges=request.qLoads.TotalCarrierCharges>
      <cfset dispatchNotes=request.qLoads.NEWDISPATCHNOTES>
      <cfset NewcustomerID=request.qLoads.PAYERID>
      <cfset carrierIDNext=request.qLoads.NEWCARRIERID>
      <cfif len(carrierIDNext) gt 1>
        <cfquery  name="request.qoffices" datasource="#application.dsn#">
			   select * from carrieroffices  where location <> '' and carrierID='#carrierIDNext#'
               ORDER BY Location ASC
			</cfquery>
      </cfif>
      <cfset stofficeidNext = request.qLoads.NEWofficeID>
      <cfset customerPO=request.qLoads.CUSTOMERPONO>
      <!---<cfset shipCustomerStopId=request.qLoads.SHIPPERID>--->
      <!---<cfinvoke component="#variables.objCutomerGateway#" method="getAllstop" CustomerStopID="#shipCustomerStopId#" returnvariable="request.ShipperStop" />--->
      <cfset request.ShipperStop = request.qLoads>
	  <cfinvoke component="#variables.objloadGateway#" method="getLoadStopInfo" StopNo="#StopNoIs#" LoadType="1" loadID="#loadID#" returnvariable="request.LoadStopInfoShipper" />
      <cfset ShipCustomerStopName=request.ShipperStop.ShipperStopName>
      <cfset shiplocation=request.ShipperStop.ShipperLocation>
      <cfset shipcity=request.ShipperStop.Shippercity>
      <cfset shipstate1=request.ShipperStop.ShipperState>
      <cfset shipzipcode=request.ShipperStop.Shipperpostalcode>
      <cfset shipcontactPerson=request.ShipperStop.ShipperContactPerson>
      <cfset shipPhone=request.ShipperStop.Shipperphone>
      <cfset shipfax=request.ShipperStop.Shipperfax>
      <cfset shipemail=request.ShipperStop.ShipperemailId>
      <cfset shipPickupNo=request.ShipperStop.ShipperReleaseNo>
      <cfset shippickupDate=request.LoadStopInfoShipper.StopDate>
      <cfset shippickupTime=request.LoadStopInfoShipper.StopTime>
      <cfset shiptimeIn=request.LoadStopInfoShipper.TimeIn>
      <cfset shiptimeOut=request.LoadStopInfoShipper.TimeOut>
	  <cfinvoke component="#variables.objloadGateway#" method="getPayerStop" stopID="#request.LoadStopInfoShipper.loadstopid#" returnvariable="request.shipIsPayer" />
	  <cfif request.shipIsPayer.recordcount>
			<cfset shipIsPayer = request.shipIsPayer.IsPayer>
	  <cfelse>
			<cfset shipIsPayer = 0>
	  </cfif>
	  <cfset shipBlind=request.ShipperStop.ShipperBlind>
      <cfset shipInstructions=request.ShipperStop.ShipperInstructions>
      <cfset shipdirection=request.ShipperStop.ShipperDirections>
      <!---<cfset consigneeCustomerStopId=request.qLoads.CONSIGNEEID>--->
      <!---<cfinvoke component="#variables.objCutomerGateway#" method="getAllstop" CustomerStopID="#consigneeCustomerStopId#" returnvariable="request.ConsineeStop" />--->
      <cfset request.ConsineeStop = request.qloads>
	  <cfinvoke component="#variables.objloadGateway#" method="getLoadStopInfo" StopNo="#StopNoIs#" LoadType="2" loadID="#loadID#" returnvariable="request.LoadStopInfoConsignee" />
      <cfset ConsineeCustomerStopName=request.ConsineeStop.ConsigneeStopName>
      <cfset consigneelocation=request.ConsineeStop.ConsigneeLocation>
      <cfset consigneecity=request.ConsineeStop.Consigneecity>
      <cfset consigneestate1=request.ConsineeStop.ConsigneeState>
      <cfset consigneezipcode=request.ConsineeStop.Consigneepostalcode>
      <cfset consigneecontactPerson=request.ConsineeStop.ConsigneeContactPerson>
      <cfset consigneePhone=request.ConsineeStop.Consigneephone>
      <cfset consigneefax=request.ConsineeStop.Consigneefax>
      <cfset consigneeemail=request.ConsineeStop.ConsigneeemailId>
      <cfset consigneePickupNo=request.ConsineeStop.ConsigneeReleaseNo>
      <cfset consigneepickupDate=request.LoadStopInfoConsignee.StopDate>
      <cfset consigneepickupTime=request.LoadStopInfoConsignee.StopTime>
      <cfset consigneetimeIn=request.LoadStopInfoConsignee.TimeIn>
      <cfset consigneetimeOut=request.LoadStopInfoConsignee.TimeOut>
	  <cfinvoke component="#variables.objloadGateway#" method="getPayerStop" stopID="#request.LoadStopInfoConsignee.loadstopid#" returnvariable="request.consigneeIsPayer" />
	  <cfif request.consigneeIsPayer.recordcount>
			<cfset consigneeIsPayer = request.consigneeIsPayer.IsPayer>
	  <cfelse>
			<cfset consigneeIsPayer = 0>
	  </cfif>
	  <cfset ConsBlind=request.ConsineeStop.ConsigneeBlind>
      <cfset consigneeInstructions=request.ConsineeStop.ConsigneeInstructions>
      <cfset consigneedirection=request.ConsineeStop.ConsigneeDirections>
      <cfset bookedwith1=request.ConsineeStop.ConsigneeBOOKEDWITH>
      <cfset equipment1=request.ConsineeStop.ConsigneeEQUIPMENTID>
      <cfset driver=request.ConsineeStop.ConsigneeDRIVERNAME>
      <cfset driverCell=request.ConsineeStop.ConsigneeDRIVERCELL>
      <cfset truckNo=request.ConsineeStop.ConsigneeTRUCKNO>
      <cfset TrailerNo=request.ConsineeStop.ConsigneeTRAILORNO>
      <cfset refNo=request.ConsineeStop.ConsigneeREFNO>
      <cfset milse=request.ConsineeStop.ConsigneeMILES>
      <cfset editid=loadIDN>
    </cfif>
  </cfif>
  <script language="javascript" type="text/javascript">
	
function ConfirmMessage(index,stopno){
	if(stopno !=0){
			index=index+""+stopno;
		}
		
	
	percentagedata=$('##CarrierPer'+index).val();
	percentagedata=percentagedata.replace("%", "");	
	if(percentagedata.indexOf("%")==-1){
		if(percentagedata<1){
			percentagedata=percentagedata*100;			
		}
		$('##CarrierPer'+index).val(percentagedata+"%");
	}
	data = $('##CarrierRate'+index).val();
	data=data.replace("$", "");	
	if(parseFloat(data)>0){
		if (confirm("Do you want to set #variables.freightBroker# rate to 0 ?")) { 		
			$('##CarrierRate'+index).val('$0.00');
			
		}
	
	}
	CalculateTotal();
}
</script>
    
  <input type="hidden" name="nextLoadStopId#stopNumber#" value="#nextLoadStopId#">
  	<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
		<div class="pg-title-carrier" id="StopNo#stopNumber#" style="float: left; min-height: 36px; width: 18%;padding:0px;">
			<h2 style="color:white;font-weight:bold;padding-left:5px;">Stop #stopNumber#</h2>
		</div>
		<div style="float: left; min-height: 36px; width: 26%;">
			<div class="form-con" style="width:100%">
				<ul class="load-link" id="ulStopNo#stopNumber#" style="line-height:36px;">
					<cfif  loadIDN neq "">
						<cfloop from="1" to="#totStops#" index='stpNoid'>
							<cfif stpNoid is 1>
								<li><a href="##StopNo#stpNoid#">###stpNoid#</a></li>
							<cfelse>
								<li><a href="##StopNo#stpNoid#">###stpNoid#</a></li>
						  </cfif>
						</cfloop>
					<cfelse>
						<li><a href="##StopNo#stpNoid#">###stopNumber#</a></li>
					</cfif>
					<!--- <li><a href="##">##2</a></li><li><a href="##">##3</a></li> --->
				</ul>
				<span style="display:inline-block;margin-left:20px;" name="span_Shipper#stopNumber#" id ="span_Shipper#stopNumber#"></span>
				<div class="clear"></div>
			</div>
		</div>
		<div style="float: left; width: 56%; min-height: 36px;">
			<h2 style="color:white;font-weight:bold;">Load###Ucase(loadnumber)#</h2>
		</div>
	</div>
    <!---<div class="white-top" style="text-align:center; background-color:##FFF; height:35px;">
      <h2>Load## #Ucase(loadnumber)#</h2>
    </div>--->
    <div class="white-mid">
      <div id="ShipperInfo">
        <div class="form-heading-carrier">
          <!---<div class="pg-title-carrier" id="StopNo#stopNumber#">
            <h2>Stop #stopNumber#</h2>
          </div>
          <div class="form-con">
            <ul class="load-link" id="ulStopNo#stopNumber#">
              <cfif  loadIDN neq "">
                <cfloop from="1" to="#totStops#" index='stpNoid'>
                  <cfif stpNoid is 1>
                    <li><a href="##StopNo#stpNoid#">###stpNoid#</a></li>
                    <cfelse>
                    <li><a href="##StopNo#stpNoid#">###stpNoid#</a></li>
                  </cfif>
                </cfloop>
                <cfelse>
                <li><a href="##StopNo#stpNoid#">###stopNumber#</a></li>
              </cfif>
            </ul>
            <span style="display:inline-block;margin-left:20px;" name="span_Shipper#stopNumber#" id ="span_Shipper#stopNumber#"></span>
            <div class="clear"></div>
          </div>--->
          <div class="rt-button1">
            <input name="addstopButton" disabled="yes" type="button" class="green-btn" onclick="AddStop('stop#(stopNumber+1)#',#(stopNumber+1)#);setStopValue();" value="Add Stop" />
            <input name="" type="button" class="red-btn" onclick="deleteStop('stop#stopNumber#',#(stopNumber-1)#,#showItems#,'#nextLoadStopId#','#application.DSN#','#loadIDN#');setStopValue();" value="Delete Stop" />
          </div>
          <div class="clear"></div>
        </div>
        <div class="form-con">
          <fieldset>
            <cfset shipperStopId = "">
            <cfset shipperStopNameList="">
            <cfset tempList = "">
            <!---<cfloop query="request.qShipper">
							<cfset tempList = "#request.qShipper.CustomerName# &nbsp;&nbsp;&nbsp; #request.qShipper.Location# &nbsp;&nbsp;&nbsp; #request.qShipper.City# &nbsp;&nbsp;&nbsp;#request.qShipper.StateCode# &nbsp;&nbsp;&nbsp;  #request.qShipper.ZipCode#">
							<cfif isdefined('request.qShipper.Instructions') AND Trim(request.qShipper.Instructions) neq ''>
                                <cfset tempList = tempList & "&nbsp;&nbsp;&nbsp;  #Left(request.qShipper.Instructions,10)# ...">
                            </cfif>


							<cfset shipperStopNameList = ListAppend(shipperStopNameList,tempList)>
						</cfloop>--->
            <label class="big-text">Select Shipper</label>
            <input name="shipper#stopNumber#" id="shipper#stopNumber#" value="#ShipCustomerStopName#"  message="Please select a Shipper"   onkeyup ="ChkUpdteShipr(this.value,'Shipper',#stopNumber#); showChangeAlert('shipper',#stopNumber#);"   tabindex="#evaluate(currentTab+1)#"/>
			<img src="images/clear.gif" style="height:14px;width:14px"  title="Click here to clear shipper information"  onclick="ChkUpdteShipr('','Shipper1',#stopNumber#);">
            <input type="hidden" name="shipperValueContainer#stopNumber#" id="shipperValueContainer#stopNumber#" value="#shipperCustomerID#"  message="Please select a Shipper"/>
			<input type="hidden" name="shipIsPayer#stopNumber#" class="updateCreateAlert" id="shipIsPayer#stopNumber#" value="#shipIsPayer#">
			<!---<select name="Shipper#stopNumber#" id="Shipper#stopNumber#" onchange="getShipperFormNext(this.value,'#application.DSN#',#stopNumber#); addressChanged(#stopNumber#);">
						<option value="">CHOOSE A SHIPPER OR ENTER ONE BELOW</option>
						<cfloop query="request.qShipper">
							<option value="#request.qShipper.CustomerID#" <cfif IsDefined('request.qLoads') AND CustomerID EQ request.qLoads.shipperLoadStopID>  selected="selected" </cfif>>
							#request.qShipper.CustomerName# &nbsp;&nbsp;&nbsp; #request.qShipper.Location# &nbsp;&nbsp;&nbsp; #request.qShipper.City# &nbsp;&nbsp;&nbsp;#request.qShipper.StateCode# &nbsp;&nbsp;&nbsp;  #request.qShipper.ZipCode#
							</option>
						</cfloop>
						</select>--->
            <div class="clear"></div>
            <label>Name*</label>
            <input name="shipperName#stopNumber#" id="shipperName#stopNumber#" value="#ShipCustomerStopName#" type="text"    onkeyup ="ChkUpdteShipr(this.value,'Shipper',#stopNumber#); showChangeAlert('shipper',#stopNumber#);"  tabindex="#evaluate(currentTab+1)#"/>
			<input type="hidden" name="shipperNameText#stopNumber#" id="shipperNameText#stopNumber#" value="#ShipCustomerStopName#">
			<div class="clear"></div>
            <label>
        	Address
            <div class="clear"></div>
            <span class="float_right">
				<cfif request.qSystemSetupOptions.googleMapsPcMiler AND request.qcurAgentdetails.PCMilerUsername NEQ "" AND request.qcurAgentdetails.PCMilerPassword NEQ "">
					<a href="##" onclick="Mypopitup('create_map.cfm?loc=#shiplocation#&city=#shipcity#&state=#stateName# #shipzipcode#&stopNo=#stopNumber#&shipOrConsName=#ShipCustomerStopName#&loadNum=#loadnumber#' );"><img style="float:left;" align="absmiddle" src="./map.jpg" width="24" height="24" alt="PC Miler Map"  /></a>
				<cfelse>
					<a href="##" onclick="Mypopitup('create_map.cfm?loc=#shiplocation#&city=#shipcity#&state=#stateName# #shipzipcode#&stopNo=#stopNumber#&shipOrConsName=#ShipCustomerStopName#&loadNum=#loadnumber#' );"><img style="float:left;" align="absmiddle" src="./map.jpg" width="24" height="24" alt="Google Map"  /></a>
				</cfif>
			</span>
        
        </label>
		   <input type="hidden" name="shipperUpAdd#stopNumber#" id="shipperUpAdd#stopNumber#" value=""> 
	
            <textarea rows="" name="shipperlocation#stopNumber#" id="shipperlocation#stopNumber#" cols=""   onkeydown="ChkUpdteShiprAddress(this.value,'Shipper',#stopNumber#);" class="addressChange" data-role="#stopNumber#" onkeyup ="showChangeAlert('shipper',#stopNumber#);" tabindex="#evaluate(currentTab+1)#">#shiplocation#</textarea>
            <div class="clear"></div>
            <label>City</label>
            <input name="shippercity#stopNumber#" id="shippercity#stopNumber#" value="#shipcity#" type="text" class="addressChange" data-role="#stopNumber#" onkeyup ="showChangeAlert('shipper',#stopNumber#);"  onkeydown="ChkUpdteShiprCity(this.value,'Shipper',#stopNumber#);" <cfif shipzipcode eq ''>tabindex="#evaluate(currentTab+1)#"</cfif>/>
            <div class="clear"></div>
            <label>State</label>
            <select name="shipperstate#stopNumber#" id="shipperstate#stopNumber#" onchange="addressChanged(#stopNumber#);showChangeAlert('shipper',#stopNumber#);loadState(this,'shipper',#stopNumber#);" <cfif shipzipcode eq ''>tabindex="#evaluate(currentTab+1)#"</cfif>>
              <option value="">Select</option>
              <cfloop query="request.qStates">
                <option value="#request.qStates.statecode#" <cfif request.qStates.statecode is shipstate1> selected="selected" </cfif> >#request.qStates.statecode#</option>
                <cfif request.qStates.statecode is shipstate1>
                  <cfset variables.stateName = #request.qStates.statecode#>
                </cfif>
              </cfloop>
            </select>
            <input type="hidden" name="shipperStateName#stopNumber#" id="shipperStateName#stopNumber#" value ="<cfif structKeyExists(variables,"stateName")>#stateName#</cfif>">
            <div class="clear"></div>
            <label>Zip</label>
            <input name="shipperZipcode#stopNumber#" id="shipperZipcode#stopNumber#" value="#shipzipcode#" type="text" class="addressChange" data-role="#stopNumber#" onkeyup ="showChangeAlert('shipper',#stopNumber#);" <cfif shipzipcode neq ''>tabindex="#evaluate(currentTab+1)#"</cfif>/>
            <div class="clear"></div>
            <label>Contact</label>
            <input name="shipperContactPerson#stopNumber#" id="shipperContactPerson#stopNumber#" value="#shipcontactPerson#" type="text" tabindex="#evaluate(currentTab+1)#"/>
            <div class="clear"></div>
            <label>Phone</label>
            <input name="shipperPhone#stopNumber#" id="shipperPhone#stopNumber#" value="#shipPhone#" type="text" onchange="ParseUSNumber(this.value);" tabindex="#evaluate(currentTab+1)#"/>
            <div class="clear"></div>
            <label>Fax</label>
            <input name="shipperFax#stopNumber#" id="shipperFax#stopNumber#" value="#shipfax#" type="text" tabindex="#evaluate(currentTab+1)#"/>
            <div class="clear"></div>
          </fieldset>
        </div>
        <div class="form-con">
          <fieldset>
            <label class="stopsLeftLabel">Email</label>
            <input name="shipperEmail#stopNumber#" id="shipperEmail#stopNumber#" value="#shipemail#" type="text" tabindex="#evaluate(currentTab+1)#"/>
            <div class="clear"></div>
            <label class="stopsLeftLabel">Pickup ## </label>
            <input name="shipperPickupNo1#stopNumber#" id="shipperPickupNo1#stopNumber#" value="#shipPickupNo#" type="text" tabindex="#evaluate(currentTab+1)#"/>
            <div class="clear"></div>
            <label class="stopsLeftLabel">Pickup Date*</label>
            <div style="position:relative;float:left;">
                  <div style="float:left;">
            <input class="sm-input datefield" name="shipperPickupDate#stopNumber#" id="shipperPickupDate#stopNumber#" value="#dateformat(ShippickupDate,'mm/dd/yyy')#" validate="date" message="Please enter a valid date" type="datefield" tabindex="#evaluate(currentTab+1)#"/>
              </div></div>
            <!--- <input class="sm-input" name="shipperPickupDate#stopNumber#" id="shipperPickupDate#stopNumber#" value="#dateformat(ShippickupDate,'mm/dd/yyy')#" validate="date" message="Please enter a valid date" type="datefield" /> --->
            <label class="sm-lbl">Pickup Time</label>
            <input class="pick-input" name="shipperpickupTime#stopNumber#" id="shipperpickupTime#stopNumber#" value="#shippickupTime#" type="text" tabindex="#evaluate(currentTab+1)#"/>
            <div class="clear"></div>
            <label class="stopsLeftLabel">Time In</label>
            <input class="sm-input" name="shipperTimeIn#stopNumber#" id="shipperTimeIn#stopNumber#" value="#shiptimeIn#" type="text" tabindex="#evaluate(currentTab+1)#"/>
            <label class="sm-lbl">Time Out</label>
            <input class="pick-input" name="shipperTimeOut#stopNumber#" id="shipperTimeOut#stopNumber#" value="#shipTimeOut#" type="text" tabindex="#evaluate(currentTab+1)#"/>
            <div class="clear"></div>
            <label>&nbsp;</label>
            <label class="ch-box">
              <input name="shipBlind#stopNumber#" id="shipBlind#stopNumber#" type="checkbox" <cfif shipBlind is true> checked="checked" </cfif> class="check" tabindex="#evaluate(currentTab+1)#"/>
              Ship Blind</label>
            <div class="clear"></div>
			<label class="space_it_medium margin_top">Instructions</label>
			<div class="clear"></div>
			<textarea rows="" name="shipperNotes#stopNumber#" id="shipperNotes#stopNumber#" class="carrier-textarea-medium" cols="" tabindex="#evaluate(currentTab+1)#">#shipInstructions#</textarea>
			<div class="clear"></div>
			<label class="space_it_medium margin_top">Directions</label>
			<div class="clear"></div>
			<textarea rows="" name="shipperDirection#stopNumber#" id="shipperDirection#stopNumber#" class="carrier-textarea-medium" cols="" tabindex="#evaluate(currentTab+1)#">#shipdirection#</textarea>
            <!---<label>Instructions</label>
            <textarea rows="" name="shipperNotes#stopNumber#" id="shipperNotes#stopNumber#" style="height:61px;" cols="" tabindex="#evaluate(currentTab+1)#">#shipInstructions#</textarea>
            <div class="clear"></div>
            <label>Directions</label>
            <textarea rows="" name="shipperDirection#stopNumber#" id="shipperDirection#stopNumber#" style="height:62px;" cols="" tabindex="#evaluate(currentTab+1)#">#shipdirection#</textarea>--->
            <div class="clear"></div>
          </fieldset>
        </div>
      </div>
      <div class="clear"></div>
      <div align="center"><img border="0" alt="" src="images/line.jpg"></div>
      <div class="clear"></div>
      <span style="display:inline-block;margin-left:205px;" name="span_Consignee#stopNumber#" id ="span_Consignee#stopNumber#"></span>
      <div id="ConsigneeInfo">
        <div class="form-con">
          <fieldset>
            <cfset shipperStopId = "">
            <cfset shipperStopNameList="">
            <cfset tempList = "">
            <!---<cfloop query="request.qConsignee">
							<cfset tempList = "#request.qConsignee.CustomerName# &nbsp;&nbsp;&nbsp; #request.qConsignee.Location# &nbsp;&nbsp;&nbsp; #request.qConsignee.City# &nbsp;&nbsp;&nbsp;#request.qConsignee.StateCode# &nbsp;&nbsp;&nbsp;  #request.qConsignee.ZipCode#">
							<cfif isdefined('request.qShipper.Instructions') AND Trim(request.qShipper.Instructions) neq ''>
                                <cfset tempList = tempList & "&nbsp;&nbsp;&nbsp;  #Left(request.qShipper.Instructions,10)# ...">
                            </cfif>

							<cfset shipperStopNameList = ListAppend(shipperStopNameList,tempList)>
						</cfloop>--->
            <label class="big-text">Select Consignee</label>
            <input name="consignee#stopNumber#" id="consignee#stopNumber#" value="#ConsineeCustomerStopName#"    onkeyup ="ChkUpdteShipr(this.value,'consignee',#stopNumber#); showChangeAlert('consignee',#stopNumber#);"  message="Please select a Consignee" tabindex="#evaluate(currentTab+1)#"/><img src="images/clear.gif" style="height:14px;width:14px"  title="Click here to clear consignee information"  onclick="ChkUpdteShipr('','consignee1',#stopNumber#);">
            <input type="hidden" name="consigneeValueContainer#stopNumber#" id="consigneeValueContainer#stopNumber#" value="#consigneeCustomerID#"  message="Please select a Consignee" />
            <input type="hidden" name="consigneeIsPayer#stopNumber#" class="updateCreateAlert" id="consigneeIsPayer#stopNumber#" value="#consigneeIsPayer#">
			<!---<select name="Consignee#stopNumber#" id="Consignee#stopNumber#" onchange="getConsigneeFormNext(this.value,'#application.DSN#',#stopNumber#);  addressChanged(#stopNumber#);" >
						<option value="">CHOOSE A SHIPPER OR ENTER ONE BELOW</option>
						<cfloop query="request.qConsignee">
							<option value="#request.qConsignee.CustomerID#" <cfif IsDefined('request.qLoads') AND CustomerID EQ request.qLoads.consigneeLoadStopID>  selected="selected" </cfif>>
								#request.qConsignee.CustomerName# &nbsp;&nbsp;&nbsp; #request.qConsignee.Location# &nbsp;&nbsp;&nbsp; #request.qConsignee.City# &nbsp;&nbsp;&nbsp;#request.qConsignee.StateCode# &nbsp;&nbsp;&nbsp;  #request.qConsignee.ZipCode#
							</option>
						</cfloop>
						</select>--->
            <div class="clear"></div>
            <label>Name</label>
            <input name="consigneeName#stopNumber#" id="consigneeName#stopNumber#" value="#ConsineeCustomerStopName#" type="text"    onkeyup ="ChkUpdteShipr(this.value,'consignee',#stopNumber#); showChangeAlert('consignee',#stopNumber#);" tabindex="#evaluate(currentTab+1)#"/>
            <input type="hidden" name="consigneeNameText#stopNumber#" id="consigneeNameText#stopNumber#" value="#ConsineeCustomerStopName#">
			<div class="clear"></div>
		 <label>Address
			<div class="clear"></div>
			<span class="float_right">
				<cfif request.qSystemSetupOptions.googleMapsPcMiler AND request.qcurAgentdetails.PCMilerUsername NEQ "" AND request.qcurAgentdetails.PCMilerPassword NEQ "">
					<a href="##" onclick="Mypopitup('create_map.cfm?loc=#Consigneelocation#&city=#Consigneecity#&state=#stateName# #Consigneezipcode#&stopNo=#stopNumber#&shipOrConsName=#ConsineeCustomerStopName#&loadNum=#loadnumber#');" ><img style="float:left;" align="absmiddle" src="./map.jpg" width="24" height="24" alt="PC Miler Map"/></a>
				<cfelse>
					<a href="##" onclick="Mypopitup('create_map.cfm?loc=#Consigneelocation#&city=#Consigneecity#&state=#stateName# #Consigneezipcode#&stopNo=#stopNumber#&shipOrConsName=#ConsineeCustomerStopName#&loadNum=#loadnumber#');" ><img style="float:left;" align="absmiddle" src="./map.jpg" width="24" height="24" alt="Google Map"/></a>
				</cfif>
			</span>
		  </label>
		  
  <input type="hidden" name="consigneeUpAdd#stopNumber#" id="consigneeUpAdd#stopNumber#" value="">

            <textarea rows="" name="consigneelocation#stopNumber#" id="consigneelocation#stopNumber#" cols="" 	onkeydown="ChkUpdteShiprAddress(this.value,'consignee',#stopNumber#);"  class="addressChange" data-role="#stopNumber#" onkeyup ="showChangeAlert('consignee',#stopNumber#);" tabindex="#evaluate(currentTab+1)#">#Consigneelocation#</textarea>
            <div class="clear"></div>
            <label>City</label>
            <input name="consigneecity#stopNumber#" id="consigneecity#stopNumber#" value="#Consigneecity#" type="text" class="addressChange" data-role="#stopNumber#" onkeydown="ChkUpdteShiprCity(this.value,'consignee',#stopNumber#);" onkeyup ="showChangeAlert('consignee',#stopNumber#);" <cfif Consigneezipcode eq ''>tabindex="#evaluate(currentTab+1)#"</cfif>/>
            <div class="clear"></div>
            <label>State</label>
            <select name="consigneestate#stopNumber#" id="consigneestate#stopNumber#" onchange="addressChanged(#stopNumber#);showChangeAlert('consignee',#stopNumber#);loadState(this,'consignee',#stopNumber#);" <cfif Consigneezipcode eq ''>tabindex="#evaluate(currentTab+1)#"</cfif>>
              <option value="">Select</option>
              <cfloop query="request.qStates">
                <option value="#request.qStates.statecode#" <cfif request.qStates.statecode is Consigneestate1> selected="selected" </cfif> >#request.qStates.statecode#</option>
                <cfif request.qStates.statecode is Consigneestate1>
                  <cfset variables.stateName = #request.qStates.statecode#>
                </cfif>
              </cfloop>
            </select>
            <input type="hidden" name="consigneeStateName#stopNumber#" id="consigneeStateName#stopNumber#" value ="<cfif structKeyExists(variables,"stateName")>#stateName#</cfif>">
            <div class="clear"></div>
            <label>Zip</label>
            <cfinclude template="getdistanceNext.cfm">
            <!--- <input name="consigneeZipcode#stopNumber#" id="consigneeZipcode#stopNumber#" value="#Consigneezipcode#" type="text" /> --->
            <div class="clear"></div>
            <label>Contact</label>
            <input name="consigneeContactPerson#stopNumber#" id="consigneeContactPerson#stopNumber#" value="#ConsigneecontactPerson#" type="text" tabindex="#evaluate(currentTab+1)#"/>
            <div class="clear"></div>
            <label>Phone</label>
            <input name="consigneePhone#stopNumber#" id="consigneePhone#stopNumber#" value="#ConsigneePhone#" onchange="ParseUSNumber(this.value);" type="text" tabindex="#evaluate(currentTab+1)#"/>
            <div class="clear"></div>
            <label>Fax</label>
            <input name="consigneeFax#stopNumber#" id="consigneeFax#stopNumber#" value="#Consigneefax#" type="text" tabindex="#evaluate(currentTab+1)#"/>
            <div class="clear"></div>
          </fieldset>
        </div>
        <div class="form-con">
          <fieldset>
            <label class="stopsLeftLabel">Email</label>
            <input name="consigneeEmail#stopNumber#" id="consigneeEmail#stopNumber#" value="#Consigneeemail#" type="text" tabindex="#evaluate(currentTab+1)#"/>
            <div class="clear"></div>
            <label class="stopsLeftLabel">Delivery ##</label>
            <input name="consigneePickupNo#stopNumber#" id="consigneePickupNo#stopNumber#" value="#ConsigneePickupNo#" type="text" tabindex="#evaluate(currentTab+1)#"/>
            <div class="clear"></div>
            <label class="stopsLeftLabel">Delivery Date*</label>
            <div style="position:relative;float:left;">
                  <div style="float:left;">
            <input class="sm-input datefield" name="consigneePickupDate#stopNumber#" id="consigneePickupDate#stopNumber#" value="#dateformat(ConsigneepickupDate,'mm/dd/yyy')#" validate="date" message="Please enter a valid date" type="datefield" tabindex="#evaluate(currentTab+1)#"/>
              </div></div>
            <label class="sm-lbl">Delivery Time</label>
            <input class="pick-input" name="consigneepickupTime#stopNumber#" id="consigneepickupTime#stopNumber#" value="#ConsigneepickupTime#" type="text" tabindex="#evaluate(currentTab+1)#"/>
            <div class="clear"></div>
            <label class="stopsLeftLabel">Time In</label>
            <input class="sm-input" name="consigneeTimeIn#stopNumber#" id="consigneeTimeIn#stopNumber#" value="#ConsigneetimeIn#" message="Please enter a valid time" type="text" tabindex="#evaluate(currentTab+1)#"/>
            <label class="sm-lbl">Time Out</label>
            <input class="pick-input" name="consigneeTimeOut#stopNumber#" id="consigneeTimeOut#stopNumber#" value="#ConsigneeTimeOut#" type="text" message="Please enter a valid time" tabindex="#evaluate(currentTab+1)#"/>
            <div class="clear"></div>
            <label>&nbsp;</label>
            <label class="ch-box">
              <input name="ConsBlind#stopNumber#" id="ConsBlind#stopNumber#" type="checkbox" <cfif ConsBlind is true> checked="checked" </cfif> class="check" tabindex="#evaluate(currentTab+1)#"/>
              Cons. Blind</label>
            <div class="clear"></div>
			<label class="space_it_medium margin_top">Instructions</label>
			<div class="clear"></div>
			<textarea rows="" name="consigneeNotes#stopNumber#" id="consigneeNotes#stopNumber#" class="carrier-textarea-medium" cols="" tabindex="#evaluate(currentTab+1)#">#ConsigneeInstructions#</textarea>
			<div class="clear"></div>
			<label class="space_it_medium margin_top">Directions</label>
			<div class="clear"></div>
			<textarea rows="" name="consigneeDirection#stopNumber#" id="consigneeDirection#stopNumber#" class="carrier-textarea-medium" cols="" tabindex="#evaluate(currentTab+1)#">#Consigneedirection#</textarea>
            <!---<label>Instructions</label>
            <textarea rows="" name="consigneeNotes#stopNumber#" id="consigneeNotes#stopNumber#" style="height:61px;" cols="" tabindex="#evaluate(currentTab+1)#">#ConsigneeInstructions#</textarea>
            <div class="clear"></div>
            <label>Directions</label>
            <textarea rows="" name="consigneeDirection#stopNumber#" id="consigneeDirection#stopNumber#" style="height:62px;" cols="" tabindex="#evaluate(currentTab+1)#">#Consigneedirection#</textarea>--->
            <div class="clear"></div>
          </fieldset>
        </div>
      </div>
      <div align="center"><img src="images/line.jpg" alt="" border="0" /></div>
	  <div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
		  <div class="pg-title-carrier" style="float: left; width: 100%;padding-left:18px;">
			  <h2 style="color:white;font-weight:bold;">#variables.freightBroker#</h2>
		  </div>
	  </div>
      <div class="form-heading-carrier">
        <!---<div class="pg-title-carrier">
          <h2>Carrier</h2>
        </div>--->
        <div class="rt-button">
          <!--- <input name="" type="button" class="bttn" value="New Carrier"  />
					<input name="" type="button" class="bttn" value="Edit Carrier"  />
					<input name="" type="button" class="bttn" value="Delete Carrier" /> --->
        </div>
        <div class="form-con" style="font-weight:bold;text-transform:uppercase;">
          <!---<ul class="load-link">
            <cfif ListContains(session.rightsList,'bookCarrierToLoad',',')>
              <cfset carrierLinksOnClick = "">
              <cfelse>
              <cfset carrierLinksOnClick = "alert('Sorry!! You don\'t have rights to add/edit Carrier.'); return false;">
            </cfif>
            <li><a href="javascript:void(0);" onclick="#carrierLinksOnClick#; chooseCarrierNext(#stopNumber#);">Change carrier</a></li>
            <li><a href="javascript:void(0);" onclick="#carrierLinksOnClick#; noCarrierNext(#stopNumber#);">No carrier</a></li>
          </ul>--->
			<cfif ListContains(session.rightsList,'bookCarrierToLoad',',')>
              <cfset carrierLinksOnClick = "">
              <cfelse>
              <cfset carrierLinksOnClick = "alert('Sorry!! You don\'t have rights to add/edit #variables.freightBroker#.'); return false;">
            </cfif>
			<a href="javascript:void(0);" onClick="#carrierLinksOnClick#; chooseCarrierNext(#stopNumber#);" style="color:##236334">
				<img style="vertical-align:bottom;" src="images/change.png">
				Remove/Change #variables.freightBroker#
			</a>
			<!---
			<a class="carrierNew" href="javascript:void(0);" style="color:##236334;float:right;<cfif len(carrierIDNext) gt 0>display:none<cfelse>display:block</cfif>" id="addCarrierLink#stopNumber#">
				<img style="vertical-align:bottom;" src="images/addnew.gif">
				New Carrier
			</a>
			--->
        </div>
        <!--- <div class="carrier-link"><ul><li><a href="javascript:void(0);" onclick="chooseCarrierNext(#stopNumber#);" onmouseover="this.style.textDecoration='none'" onmouseout="this.style.textDecoration='underline'">Change carrier</a></li><li><a href="javascript:void(0);" onclick="noCarrierNext(#stopNumber#);" onmouseover="this.style.textDecoration='none'" onmouseout="this.style.textDecoration='underline'">No carrier</a></li></ul><div class="clear"></div></div>	 --->
        <div class="clear"></div>
      </div>
      <div class="form-con"><input type="hidden" name="carrier_id#stopNumber#" id="carrier_id#stopNumber#" value="#carrierIDNext#">
        <input name="carrierID#stopNumber#" id="carrierID#stopNumber#" type="hidden" value="#carrierIDNext#" />
        <fieldset>
          <div id="choosCarrier#stopNumber#" style="<cfif len(carrierIDNext) gt 0>display:none<cfelse>display:block</cfif>;">
            <!---<div class="form-con">
              <ul class="load-link">
                <li>Choose a Carrier</li>
                <li><a href="index.cfm?event=addcarrier&#session.URLToken#"  onclick="#carrierLinksOnClick#" onmouseover="this.style.textDecoration='none'" onmouseout="this.style.textDecoration='underline'">New Carrier</a></li>--->
                <!---<li><a href="javascript:void(0);" onclick="#carrierLinksOnClick#; return editCarrierNext('index.cfm?event=addcarrier&#session.URLToken#',#stopNumber#);" onmouseover="this.style.textDecoration='none'" onmouseout="this.style.textDecoration='underline'">Edit Carrier</a></li>
								<li><a href="javascript:void(0);" onclick="#carrierLinksOnClick#; return useCarrierNext('#application.dsn#',1,#stopNumber#,'#session.URLToken#');" onmouseover="this.style.textDecoration='none'" onmouseout="this.style.textDecoration='underline'">Use Carrier</a></li>--->
                <!---<li></li>
                <li></li>
                <li></li>
              </ul>
              <div class="clear"></div>
            </div>--->
            <div class="clear"></div>
			<label class="stopsLeftLabel" style="width: 102px !important;">Choose #variables.freightBroker#</label>
            <input name="selectedCarrier#stopNumber#" id="selectedCarrierValue#stopNumber#" class="carrier-box" style="margin-left: 0;width: 230px !important;" type="text" <cfif carrierLinksOnClick NEQ ''>disabled="disabled"</cfif> tabindex="#evaluate(currentTab+1)#"/>
            <!---
			<cfif isdefined("url.loadid") and len(trim(url.loadid)) gt 1>
                <input type="submit"  class="carrier-filter-image-button" onClick="return saveButStayOnPage_filterCarrier('#url.loadid#');"  value="" />
            <cfelse>
                <input type="submit"  class="carrier-filter-image-button" onClick="return saveButStayOnPage_filterCarrier('#url.loadid#');" onFocus="checkUnload();" value="" />
            </cfif>
			--->
            <input name="selectedCarrier#stopNumber#ValueContainer" id="selectedCarrierValue#stopNumber#ValueContainer" type="hidden" />
            <!---<input id="refreshBtn#stopNumber#" value="" type="button" class="bttn" onclick="getFilterCarrierByString('#application.DSN#','#stopNumber#');" style="width:17px; height:22px; background: url('images/refresh.png');"/>--->
            <div class="clear"></div>
            <!---<label class="big-label">
						   <div class="form-con">
							##
							<a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('A','#application.DSN#',#stopNumber#)">A</a>
							<a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('B','#application.DSN#',#stopNumber#)">B</a>
							<a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('C','#application.DSN#',#stopNumber#)">C</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('D','#application.DSN#',#stopNumber#)">D</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('E','#application.DSN#',#stopNumber#)">E</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('F','#application.DSN#',#stopNumber#)">F</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('G','#application.DSN#',#stopNumber#)">G</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('H','#application.DSN#',#stopNumber#)">H</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('I','#application.DSN#',#stopNumber#)">I</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('J','#application.DSN#',#stopNumber#)">J</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('K','#application.DSN#',#stopNumber#)">K</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('L','#application.DSN#',#stopNumber#)">L</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('M','#application.DSN#',#stopNumber#)">M</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('N','#application.DSN#',#stopNumber#)">N</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('O','#application.DSN#',#stopNumber#)">O</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('P','#application.DSN#',#stopNumber#)">P</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('Q','#application.DSN#',#stopNumber#)">Q</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('R','#application.DSN#',#stopNumber#)">R</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('S','#application.DSN#',#stopNumber#)">S</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('T','#application.DSN#',#stopNumber#)">T</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('U','#application.DSN#',#stopNumber#)">U</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('V','#application.DSN#',#stopNumber#)">V</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('W','#application.DSN#',#stopNumber#)">W</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('X','#application.DSN#',#stopNumber#)">X</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('Y','#application.DSN#',#stopNumber#)">Y</a>
						    <a href="javascript:void(0);" onclick="#carrierLinksOnClick#; getFilterCarrierNext('Z','#application.DSN#',#stopNumber#)">Z</a>

                            </div>
                            <div class="clear"></div>
						</label>
						<div class="clear"></div>
						<div id="carrierList#stopNumber#"><select size="10" class="carrier-select" style="height:162px" >
						<option value=""></option>
						</select></div>--->
            <div class="clear"></div>
          </div>
          <div id="CarrierInfo#stopNumber#" style="<cfif len(carrierIDNext) gt 0>display:block<cfelse>display:none</cfif>;">
            <div class="clear"></div>
            <div class="clear"></div>
            <label>&nbsp;</label>
            <label class="field-textarea" tabindex="#evaluate(currentTab+1)#"><b><a href=""></a></b><br/>
            </label>
            <div class="clear"></div>
            <label>Tel</label>
            <label class="field-text" tabindex="#evaluate(currentTab+1)#"></label>
            <div class="clear"></div>
            <label>Cell</label>
            <label class="field-text" tabindex="#evaluate(currentTab+1)#"></label>
            <div class="clear"></div>
            <label>Fax</label>
            <label class="field-text" tabindex="#evaluate(currentTab+1)#"></label>
            <div class="clear"></div>
            <label>Email</label>
            <label class="field-text" tabindex="#evaluate(currentTab+1)#"></label>
          </div>
          <label class="stopsLeftLabel" style="width: 102px !important;">Satellite Office</label>
          <select name="stOffice#stopNumber#" id="stOffice#stopNumber#" tabindex="#evaluate(currentTab+1)#">
          <option value="">Choose a Satellite Office Contact</option>
          <cfloop query="request.qOffices">
            <option value="#request.qOffices.CarrierOfficeID#" <cfif stofficeidNext is request.qOffices.CarrierOfficeID>selected ="selected"</cfif>>#request.qOffices.location#</option>
          </cfloop>
          </select>
        </fieldset>
      </div>
      <div class="form-con">
        <fieldset>
		
			<div style="width:100%" class="carrierrightdiv">
				<div style="width:200px;float:left;">
					<label class="carrierrightlabel">Booked With</label>
					<input name="bookedWith#stopNumber#" id="bookedWith#stopNumber#" value="#bookedwith1#" type="text" tabindex="#evaluate(currentTab+1)#" class="carriertextbox"/>
				</div>
			</div>
			<div class="clear"></div>
			<div style="width:100%" class="carrierrightdiv">
				<div style="width:200px;float:left;">
					<label class="carrierrightlabel">Equipment</label>
					<select name="equipment#stopNumber#" id="equipment#stopNumber#" tabindex="#evaluate(currentTab+1)#" class="carriertextbox">
						<option value="">Select</option>
						<cfloop query="request.qEquipments">
							<option value="#request.qEquipments.equipmentID#" <cfif equipment1 is request.qEquipments.equipmentID> selected="selected" </cfif>>#request.qEquipments.equipmentname#</option>
						</cfloop>
					</select>
				</div>
				<div style="width:200px;float:left;">
					<label class="carrierrightlabel">#request.qSystemSetupOptions.userDef1#</label>
					<input name="userDef1#stopNumber#" value="#request.LoadStopInfoShipper.userDef1#" type="text" tabindex="#evaluate(currentTab+1)#" class="carriertextbox"/>
				</div>
			</div>
			<div class="clear"></div>
			<div style="width:100%" class="carrierrightdiv">
				<div style="width:200px;float:left;">
					<label class="carrierrightlabel">Driver</label>
					<input name="driver#stopNumber#" value="#driver#" type="text" tabindex="#evaluate(currentTab+1)#" class="carriertextbox"/>
				</div>
				<div style="width:200px;float:left;">
					<label class="carrierrightlabel">#request.qSystemSetupOptions.userDef2#</label>
					<input name="userDef2#stopNumber#" value="#request.LoadStopInfoShipper.userDef2#" type="text" tabindex="#evaluate(currentTab+1)#" class="carriertextbox"/>
				</div>
			</div>
			<div class="clear"></div>
			<div style="width:100%" class="carrierrightdiv">
				<div style="width:200px;float:left;">
					<label class="carrierrightlabel">Driver Cell</label>
					<input name="driverCell#stopNumber#" value="#driverCell#" type="text" tabindex="#evaluate(currentTab+1)#" class="carriertextbox"/>
				</div>
				<div style="width:200px;float:left;">
					<label class="carrierrightlabel">#request.qSystemSetupOptions.userDef3#</label>
					<input name="userDef3#stopNumber#" value="#request.LoadStopInfoShipper.userDef3#" type="text" tabindex="#evaluate(currentTab+1)#" class="carriertextbox"/>
				</div>
			</div>
			<div class="clear"></div>
			<div style="width:100%" class="carrierrightdiv">
				<div style="width:200px;float:left;">
					<label class="carrierrightlabel">Truck ##</label>
					<input name="truckNo#stopNumber#" value="#truckNo#" type="text" tabindex="#evaluate(currentTab+1)#" class="carriertextbox"/>
				</div>
				<div style="width:200px;float:left;">
					<label class="carrierrightlabel">#request.qSystemSetupOptions.userDef4#</label>
					<input name="userDef4#stopNumber#" value="#request.LoadStopInfoShipper.userDef4#" type="text" tabindex="#evaluate(currentTab+1)#" class="carriertextbox"/>
				</div>
			</div>
			<div class="clear"></div>
			<div style="width:100%" class="carrierrightdiv">
				<div style="width:200px;float:left;">
					<label class="carrierrightlabel">Trailer ##</label>
					<input name="TrailerNo#stopNumber#" value="#TrailerNo#" type="text" tabindex="#evaluate(currentTab+1)#" class="carriertextbox"/>
				</div>
				<div style="width:200px;float:left;">
					<label class="carrierrightlabel">#request.qSystemSetupOptions.userDef5#</label>
					<input name="userDef5#stopNumber#" value="#request.LoadStopInfoShipper.userDef5#" type="text" tabindex="#evaluate(currentTab+1)#" class="carriertextbox"/>
				</div>
			</div>
			<div class="clear"></div>
			<div style="width:100%" class="carrierrightdiv">
				<div style="width:200px;float:left;">
					<label class="carrierrightlabel">Ref ##</label>
					<input name="refNo#stopNumber#" value="#refNo#" type="text" tabindex="#evaluate(currentTab+1)#" class="carriertextbox"/>
				</div>
				<div style="width:200px;float:left;">
					<label class="carrierrightlabel">#request.qSystemSetupOptions.userDef6#</label>
					<input name="userDef6#stopNumber#" value="#request.LoadStopInfoShipper.userDef6#" type="text" tabindex="#evaluate(currentTab+1)#" class="carriertextbox"/>
				</div>
			</div>
			<div class="clear"></div>
			<div style="width:100%" class="carrierrightdiv">
				<div style="width:200px;float:left;">
					<label class="carrierrightlabel">Miles ##</label>
					<input name="milse#stopNumber#" class="careermilse carriertextbox" id="milse#stopNumber#" value="#milse#" type="text" onclick="showWarningEnableButton('block','#stopNumber#');" onblur="showWarningEnableButton('none','#stopNumber#');changeQuantityWithValue(this,#stopNumber#);" onChange="changeQuantity(this.id,this.value,'unit');calculateTotalRates('#application.DSN#');" tabindex="#evaluate(currentTab+1)#" style="width:168px;"/>
				</div>
				<div style="width:200px;float:left;">
					<input id="refreshBtn#stopNumber#" title="Refresh Miles" value=" " type="button" class="bttn" disabled="disabled" onclick="refreshMilesClicked('#stopNumber#');" style="width:17px; height:22px; background: url('images/refresh.png');"/>
					<input id="milesUpdateMode#stopNumber#" name="milesUpdateMode#stopNumber#" type="hidden" value="auto" >
				</div>			
			</div>
			<!---
          <label>Booked With</label>
          <input name="bookedWith#stopNumber#" id="bookedWith#stopNumber#" value="#bookedwith1#" type="text" tabindex="#evaluate(currentTab+1)#"/>
          <div class="clear"></div>
          <label>Equipment</label>
          <select name="equipment#stopNumber#" id="equipment#stopNumber#" tabindex="#evaluate(currentTab+1)#">
            <option value="">Select</option>
            <cfloop query="request.qEquipments">
              <option value="#request.qEquipments.equipmentID#" <cfif equipment1 is request.qEquipments.equipmentID> selected="selected" </cfif>>#request.qEquipments.equipmentname#</option>
            </cfloop>
          </select>
          <div class="clear"></div>
          <label>Driver</label>
          <input name="driver#stopNumber#" value="#driver#" type="text" tabindex="#evaluate(currentTab+1)#"/>
          <div class="clear"></div>
          <label>Driver Cell</label>
          <input name="driverCell#stopNumber#" value="#driverCell#" type="text" tabindex="#evaluate(currentTab+1)#"/>
          <div class="clear"></div>
          <label>Truck ##</label>
          <input name="truckNo#stopNumber#" value="#truckNo#" type="text" tabindex="#evaluate(currentTab+1)#"/>
          <div class="clear"></div>
          <label>Trailer ##</label>
          <input name="TrailerNo#stopNumber#" value="#TrailerNo#" type="text" tabindex="#evaluate(currentTab+1)#"/>
          <div class="clear"></div>
          <label>Ref ##</label>
          <input name="refNo#stopNumber#" value="#refNo#" type="text" tabindex="#evaluate(currentTab+1)#"/>
          <div class="clear"></div>
          <label>Miles ##</label>
          <input name="milse#stopNumber#" class="careermilse" id="milse#stopNumber#" value="#milse#" type="text" onclick="showWarningEnableButton('block','#stopNumber#');" onblur="showWarningEnableButton('none','#stopNumber#');" onChange="changeQuantity(this.id,this.value,'unit');calculateTotalRates('#application.DSN#');" tabindex="#evaluate(currentTab+1)#" style="width:168px;"/>
          <input id="refreshBtn#stopNumber#" value="" type="button" class="bttn" disabled="disabled" onclick="refreshMilesClicked('#stopNumber#');" style="width:17px; height:22px; background: url('images/refresh.png');"/>
          <input id="milesUpdateMode#stopNumber#" name="milesUpdateMode#stopNumber#" type="hidden" value="auto" >
         --->
		  <div class="clear"></div>
          <div id="warning#stopNumber#" class="msg-area" style="display:none; width:180px;">Warning!! Mannual Miles change has disabled automatic miles update on address change for Stop#stopNumber#. After changing an address use <b>Recalculate Miles</b> button to calculate miles again.</div>
        </fieldset>
      </div>
      <div class="clear"></div>
      <div class="carrier-gap">&nbsp;</div>
      <div class="clear"></div>
      <div class="carrier-mid">
         <table width="100%" class="noh carrierCalTable" border="0" cellspacing="0" cellpadding="0">
      <thead>
        <tr>
          <th width="5" align="right" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
          <th align="right" valign="middle" class="head-bg">Fee</th>
          <th align="right" valign="middle" width="10%" class="head-bg">Qty</th>
          <th align="right" valign="middle" class="head-bg textalign">Type</th>
          <th align="right" valign="middle" class="head-bg" width="30%">Description</th>
          <th align="right" valign="middle" class="head-bg">Wt(lbs)</th>
          <th align="right" valign="middle" class="head-bg" style="width:60px;"  >Class</th>
		  <th align="right" valign="middle" class="head-bg" >Cust. Rate</th>
          <th align="right" valign="middle" class="head-bg textalign">#variables.freightBrokerShortForm#. Rate</th>
		  <th align="right" valign="middle" class="head-bg textalign">#variables.freightBrokerShortForm#.% of Cust Total</th>
          <th align="right" valign="middle" class="head-bg textalign">Cust. Total</th>
          <th align="right" valign="middle" class="head-bg2 textalign">#variables.freightBrokerShortForm#. Total</th>
          <th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
        </tr>
      </thead>
          <tbody>
            <cfif  loadIDN neq "" and showItems is true>	
			<cfloop query="request.qItems">
                <tr <cfif request.qItems.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>  bgcolor="##f7f7f7"</cfif> >
                  <td height="20" class="lft-bg">&nbsp;</td>
                  <td class="lft-bg2" valign="middle" align="center"><input name="isFee#request.qItems.currentRow##stopNumber#" id="isFee#request.qItems.currentRow##stopNumber#" class="check isFee" <cfif request.qItems.fee is 1> checked="checked" </cfif> type="checkbox" tabindex="#evaluate(currentTab+1)#"/></td>
                  <td class="normaltdC" valign="middle" align="left"><input name="qty#request.qItems.currentRow##stopNumber#" id="qty#request.qItems.currentRow##stopNumber#" onchange="CalculateTotal()" class="qty q-textbox" type="text" value="#request.qItems.qty#"  tabindex="#evaluate(currentTab+1)#" /></td>
                  <td class="normaltdC" valign="middle" align="left"><select name="unit#request.qItems.currentRow##stopNumber#" id="unit#request.qItems.currentRow##stopNumber#" class="t-select typeSelect#stopNumber#" onchange="changeQuantityWithtype(this,#stopNumber#);checkForFee(this.value,'#request.qItems.currentRow#','#stopNumber#','#application.dsn#')" tabindex="#evaluate(currentTab+1)#">
                      <option value=""></option>
                      <cfloop query="request.qUnits">
                        <option value="#request.qUnits.unitID#" <cfif request.qUnits.unitID is request.qItems.unitid> selected="selected" </cfif>>#request.qUnits.unitName#<cfif trim(request.qUnits.unitCode) neq ''>(#request.qUnits.unitCode#)</cfif></option>
                      </cfloop>
                    </select></td>
                  <td class="normaltdC" valign="middle" align="left"><input name="description#request.qItems.currentRow##stopNumber#" id="description#request.qItems.currentRow##stopNumber#" class="t-textbox" value="#replace(request.qItems.description,'"','&quot;','all')#" type="text" tabindex="#evaluate(currentTab+1)#" /></td>
                  <td class="normaltdC" valign="middle" align="left"><input name="weight#request.qItems.currentRow##stopNumber#" class="wt-textbox" value="#request.qItems.weight#" type="text" tabindex="#evaluate(currentTab+1)#" /></td>
                  <td class="normaltdC" valign="middle" align="left"><select name="class#request.qItems.currentRow##stopNumber#" id="class#request.qItems.currentRow##stopNumber#" class="t-select" tabindex="#evaluate(currentTab+1)#" style="width:60px;" >
                      <option></option>
                      <cfloop query="request.qClasses">
                        <option value="#request.qClasses.classId#" <cfif request.qClasses.classId is request.qItems.classid> selected="selected" </cfif>>#request.qClasses.className#</option>
                      </cfloop>
                    </select></td>
				  <cfset variables.CustomerRate = request.qItems.CUSTRATE >
				  <cfset variables.CarrierRate = request.qItems.CARRRATE >
				  <cfif request.qItems.CUSTRATE eq ""><cfset variables.CustomerRate = '0.00' ></cfif>
				  <cfif request.qItems.CARRRATE eq ""><cfset variables.CarrierRate = '0.00' ></cfif>
				  <cfset variables.carrierPercentage = 0 >
				  <cfif isdefined("request.qItems.CarrRateOfCustTotal") and IsNumeric(request.qItems.CarrRateOfCustTotal)>
					<cfset variables.carrierPercentage = request.qItems.CarrRateOfCustTotal >
				  </cfif>
				  
				  <td class="normaltdC" valign="middle" align="left"><input name="CustomerRate#request.qItems.currentRow##stopNumber#" id="CustomerRate#request.qItems.currentRow##stopNumber#" onChange="CalculateTotal();formatDollar(this.value, this.id);" class="q-textbox CustomerRate" value="#myCurrencyFormatter(variables.CustomerRate)#"  type="text" tabindex="#evaluate(currentTab+1)#"/></td>
                  <td class="normaltd2C" valign="middle" align="left"><input name="CarrierRate#request.qItems.currentRow##stopNumber#" id="CarrierRate#request.qItems.currentRow##stopNumber#" onChange="CalculateTotal();formatDollar(this.value, this.id);" class="q-textbox CarrierRate" value="#myCurrencyFormatter(variables.CarrierRate)#"  type="text" tabindex="#evaluate(currentTab+1)#" /></td>
                  <td class="normaltd2C" valign="middle" align="left"><input  onChange="ConfirmMessage('#request.qItems.currentRow#',#stopNumber#)" name="CarrierPer#request.qItems.currentRow##stopNumber#" id="CarrierPer#request.qItems.currentRow##stopNumber#" style="width:105px;" class="q-textbox CarrierPer" value="#variables.carrierPercentage#%" onChange=""  type="text" tabindex="" /></td>
				  <td class="normaltdC" valign="middle" align="left"><input name="custCharges#request.qItems.currentRow##stopNumber#" id="custCharges#request.qItems.currentRow##stopNumber#" onchange="CalculateTotal();" class="custCharges q-textbox" value="#request.qItems.custCharges#" type="text" tabindex="#evaluate(currentTab+1)#" /></td>
                  <td class="normaltd2C" valign="middle" align="left"><input name="carrCharges#request.qItems.currentRow##stopNumber#" id="carrCharges#request.qItems.currentRow##stopNumber#" onchange="CalculateTotal();" class="carrCharges q-textbox" value="#request.qItems.carrCharges#" type="text" tabindex="#evaluate(currentTab+1)#" /></td>
                  <td class="normal-td3C normal-td3">&nbsp;</td>
                </tr>
              </cfloop>
              <cfif request.qItems.recordcount lt 7>
                <cfset remainCol=request.qItems.recordcount+1>
                <cfloop from ="#remainCol#" to="7" index="rowNum">
                  <tr <cfif rowNum mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>  bgcolor="##f7f7f7"</cfif> >
                    <td height="20" class="lft-bg">&nbsp;</td>
                    <td class="lft-bg2" valign="middle" align="center"><input name="isFee#rowNum##stopNumber#" id="isFee#rowNum##stopNumber#" class="isFee check" type="checkbox" tabindex="#evaluate(currentTab+1)#"/></td>
                    <td class="normaltdC" valign="middle" align="left"><input name="qty#rowNum##stopNumber#" id="qty#rowNum##stopNumber#" onChange="CalculateTotal()" value="1" class="qty q-textbox" type="text"  tabindex="#evaluate(currentTab+1)#"/></td>
                    <td class="normaltdC" valign="middle" align="left"><select style="60px;" name="unit#rowNum##stopNumber#" id="unit#rowNum##stopNumber#" class="unit t-select" onchange="changeQuantityWithtype(this,#stopNumber#);checkForFee(this.value,'#rowNum#','#stopNumber#','#application.dsn#')" tabindex="#evaluate(currentTab+1)#">
                        <option value=""></option>
                        <cfloop query="request.qUnits">
                          <option value="#request.qUnits.unitID#">#request.qUnits.unitName#<cfif trim(request.qUnits.unitCode) neq ''>(#request.qUnits.unitCode#)</cfif></option>
                        </cfloop>
                      </select></td>
                    <td class="normaltdC" valign="middle" align="left"><input name="description#rowNum##stopNumber#" id="description#rowNum##stopNumber#" class="t-textbox" type="text" tabindex="#evaluate(currentTab+1)#"/></td>
                    <td class="normaltdC" valign="middle" align="left"><input name="weight#rowNum##stopNumber#" class="wt-textbox" type="text" tabindex="#evaluate(currentTab+1)#"/></td>
                    <td class="normaltdC" valign="middle" align="left"><select name="class#rowNum##stopNumber#" id="class#rowNum##stopNumber#" style="width:60px;" class="t-select" tabindex="#evaluate(currentTab+1)#">
                        <option value=""></option>
                        <cfloop query="request.qClasses">
                          <option value="#request.qClasses.classId#">#request.qClasses.className#</option>
                        </cfloop>
                      </select></td>
					<!---
					<td class="normaltdC" valign="middle" align="left"><input name="CustomerRate#rowNum##stopNumber#" id="CustomerRate#rowNum#" tabindex="#evaluate(currentTab+1)#" onChange="CalculateTotal();formatDollar(this.value, this.id);" class="CustomerRate q-textbox"  type="text" value="#DollarFormat(variables.CustomerRate)#" /></td>
                    <td class="normaltd2C" valign="middle" align="left"><input name="CarrierRate#rowNum##stopNumber#" id="CarrierRate#rowNum#" tabindex="#evaluate(currentTab+1)#"  onChange="CalculateTotal();formatDollar(this.value, this.id);" class="CarrierRate q-textbox"  type="text" value="#DollarFormat(variables.CarrierRate)#"/></td>
                    <td class="normaltd2C" valign="middle" align="left"><input name="CarrierPer#rowNum##stopNumber#" id="CarrierPer#rowNum#" style="width:105px;" class="q-textbox CarrierPer" value="#request.qItems.CarrRateOfCustTotal#%" onChange="ConfirmMessage('#request.qItems.currentRow#',0)"  type="text" tabindex="" /></td>
					--->
					<td class="normaltdC" valign="middle" align="left"><input name="CustomerRate#rowNum##stopNumber#" id="CustomerRate#rowNum#" tabindex="#evaluate(currentTab+1)#" onChange="CalculateTotal();formatDollar(this.value, this.id);" class="CustomerRate q-textbox"  type="text" value="$0.00" /></td>
                    <td class="normaltd2C" valign="middle" align="left"><input name="CarrierRate#rowNum##stopNumber#" id="CarrierRate#rowNum#" tabindex="#evaluate(currentTab+1)#"  onChange="CalculateTotal();formatDollar(this.value, this.id);" class="CarrierRate q-textbox"  type="text" value="$0.00"/></td>
					<td class="normaltd2C" valign="middle" align="left"><input name="CarrierPer#rowNum##stopNumber#" id="CarrierPer#rowNum#" style="width:105px;" class="q-textbox CarrierPer" value="0.00%" onChange="ConfirmMessage('#request.qItems.currentRow#',0)"  type="text" tabindex="" /></td>
					<td class="normaltdC" valign="middle" align="left"><input name="custCharges#rowNum##stopNumber#" id="custCharges#rowNum##stopNumber#" onchange="CalculateTotal();" class="custCharges q-textbox" type="text" tabindex="#evaluate(currentTab+1)#"/></td>
                    <td class="normaltd2C" valign="middle" align="left"><input name="carrCharges#rowNum##stopNumber#" id="carrCharges#rowNum##stopNumber#" onchange="CalculateTotal();" class="carrCharges q-textbox" type="text" tabindex="#evaluate(currentTab+1)#"/></td>
                    <td class="normal-td3C normal-td3">&nbsp;</td>
                  </tr>
                </cfloop>
              </cfif>
              <cfelse>
              <cfloop from ="1" to="7" index="rowNum">
                <tr <cfif rowNum mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>  bgcolor="##f7f7f7"</cfif> >
                  <td height="20" class="lft-bg">&nbsp;</td>
                  <td class="lft-bg2" valign="middle" align="center"><input name="isFee#rowNum##stopNumber#" id="isFee#rowNum##stopNumber#" class="isFee check" type="checkbox" tabindex="#evaluate(currentTab+1)#"/></td>
                  <td class="normaltdC" valign="middle" align="left"><input name="qty#rowNum##stopNumber#" id="qty#rowNum##stopNumber#" onChange="CalculateTotal()" value="1" class="qty q-textbox" type="text"  tabindex="#evaluate(currentTab+1)#"/></td>
                  <td class="normaltdC" valign="middle" align="left"><select name="unit#rowNum##stopNumber#" id="unit#rowNum##stopNumber#" class="unit t-select" onchange="changeQuantityWithtype(this,#stopNumber#);checkForFee(this.value,'#rowNum#','#stopNumber#','#application.dsn#')" tabindex="#evaluate(currentTab+1)#">
                      <option value=""></option>
                      <cfloop query="request.qUnits">
                        <option value="#request.qUnits.unitID#">#request.qUnits.unitName#<cfif trim(request.qUnits.unitCode) neq ''>(#request.qUnits.unitCode#)</cfif></option>
                      </cfloop>
                    </select></td>
                  <td class="normaltdC" valign="middle" align="left"><input name="description#rowNum##stopNumber#" id="description#rowNum##stopNumber#" class="t-textbox" type="text" tabindex="#evaluate(currentTab+1)#"/></td>
                  <td class="normaltdC" valign="middle" align="left"><input name="weight#rowNum##stopNumber#" class="wt-textbox" type="text" tabindex="#evaluate(currentTab+1)#"/></td>
                  <td class="normaltdC" valign="middle" align="left"><select name="class#rowNum##stopNumber#" id="class#rowNum##stopNumber#" class="t-select" tabindex="#evaluate(currentTab+1)#" style="width:60px;">
                      <option value=""></option>
                      <cfloop query="request.qClasses">
                        <option value="#request.qClasses.classId#">#request.qClasses.className#</option>
                      </cfloop>
                    </select></td>
				  <cfset variables.carrierPercentage = 0>
				  <cfif IsDefined("request.qItems.CarrRateOfCustTotal") and IsNumeric(request.qItems.CarrRateOfCustTotal)>
						<cfset variables.carrierPercentage = request.qItems.CarrRateOfCustTotal>
				  </cfif>
				  <!---
				  <td class="normaltdC" valign="middle" align="left"><input name="CustomerRate#rowNum##stopNumber#" id="CustomerRate#rowNum##stopNumber#" tabindex="#evaluate(currentTab+1)#" onChange="CalculateTotal();formatDollar(this.value, this.id);" class="CustomerRate q-textbox"  type="text" value="#DollarFormat(variables.CustomerRate)#" /></td>
                  <td class="normaltd2C" valign="middle" align="left"><input name="CarrierRate#rowNum##stopNumber#" id="CarrierRate#rowNum##stopNumber#" tabindex="#evaluate(currentTab+1)#"  onChange="CalculateTotal();formatDollar(this.value, this.id);" class="CarrierRate q-textbox"  type="text" value="#DollarFormat(variables.CarrierRate)#"/></td>
                  <td class="normaltd2C" valign="middle" align="left"><input name="CarrierPer#rowNum##stopNumber#" id="CarrierPer#rowNum##stopNumber#" style="width:105px;" class="q-textbox CarrierPer" value="#variables.carrierPercentage#%" onChange="ConfirmMessage('#rowNum##stopNumber#',0)"  type="text" tabindex="" /></td>
				  --->
				  <td class="normaltdC" valign="middle" align="left"><input name="CustomerRate#rowNum##stopNumber#" id="CustomerRate#rowNum##stopNumber#" tabindex="#evaluate(currentTab+1)#" onChange="CalculateTotal();formatDollar(this.value, this.id);" class="CustomerRate q-textbox"  type="text" value="$0.00" /></td>
                  <td class="normaltd2C" valign="middle" align="left"><input name="CarrierRate#rowNum##stopNumber#" id="CarrierRate#rowNum##stopNumber#" tabindex="#evaluate(currentTab+1)#"  onChange="CalculateTotal();formatDollar(this.value, this.id);" class="CarrierRate q-textbox"  type="text" value="$0.00"/></td>
				  <td class="normaltd2C" valign="middle" align="left"><input name="CarrierPer#rowNum##stopNumber#" id="CarrierPer#rowNum##stopNumber#" style="width:105px;" class="q-textbox CarrierPer" value="0.00%" onChange="ConfirmMessage('#rowNum##stopNumber#',0)"  type="text" tabindex="" /></td>
				  <td class="normaltdC" valign="middle" align="left"><input name="custCharges#rowNum##stopNumber#" id="custCharges#rowNum##stopNumber#" onchange="CalculateTotal();" class="custCharges q-textbox" type="text" value="0.0000" tabindex="#evaluate(currentTab+1)#"/></td>
                  <td class="normaltd2C" valign="middle" align="left"><input name="carrCharges#rowNum##stopNumber#" id="carrCharges#rowNum##stopNumber#" onchange="CalculateTotal();" class="carrCharges q-textbox" type="text"  value="0.0000" tabindex="#evaluate(currentTab+1)#"/></td>
                  <td class="normal-td3C normal-td3">&nbsp;</td>
                </tr>
              </cfloop>
            </cfif>
          </tbody>
          <tfoot>
            <tr>
              <td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
              <td colspan="11" align="left" valign="middle" class="footer-bg"></td>
              <td width="5" align="right" valign="top"><img src="images/right-bot.gif" alt="" width="5" height="23" /></td>
            </tr>
          </tfoot>
        </table>
        <div class="clear"></div>
      </div>
      <div class="carrier-gap">&nbsp;</div>
	</div>

  <script type="text/javascript">
$(function() {

	function format(mail) {
		//alert(mail.location);
		return mail.name + "<br/><b><u>Address</u>:</b> " + mail.location+"&nbsp;&nbsp;&nbsp;<b><u>City</u>:</b>" + mail.city+"&nbsp;&nbsp;&nbsp;<b><u>State</u>:</b> " + mail.state+"<br><b><u>Zip</u>:</b> " + mail.zip;
	}

	function Cityformat(mail) 
		{
			return mail.city + "<br/><b><u>State</u>:</b> " + mail.state+"&nbsp;&nbsp;&nbsp;<b><u>Zip</u>:</b> " + mail.zip;
		}
		
		function Zipformat(mail) 
		{
			return mail.zip + "<br/><b><u>State</u>:</b> " + mail.state+"&nbsp;&nbsp;&nbsp;<b><u>City</u>:</b> " + mail.city;
		}

	// Shippper DropBox
	$("##shipper#stopNumber#, ##consignee#stopNumber#").each(function(i, tag) {
		$(tag).autocomplete({
			multiple: false,
			width: 400,
			scroll: true,
			scrollHeight: 300,
			cacheLength: 1,
			highlight: false,
			dataType: "json",
			source: 'searchCustomersAutoFill.cfm?queryType=getShippers',
			select: function(e, ui) {
				$(this).val(ui.item.name);
				$(this).parent().find('.updateCreateAlert').val(ui.item.isPayer);
				var controlType = '';
				if(this.id.substring(0, 4) == 'ship')
					controlType = 'shipper';
				else
					controlType = 'consignee';
				$('##'+controlType+'ValueContainer#stopNumber#').val(ui.item.value);

				$('##'+controlType+'Name#stopNumber#').val(ui.item.name);
				$('##'+controlType+'NameText#stopNumber#').val(ui.item.name);
				$('##'+controlType+'location#stopNumber#').val(ui.item.location);
				$('##'+controlType+'city#stopNumber#').val(ui.item.city);
				$('##'+controlType+'Zipcode#stopNumber#').val(ui.item.zip);
				$('##'+controlType+'ContactPerson#stopNumber#').val(ui.item.contactPerson);
				$('##'+controlType+'Phone#stopNumber#').val(ui.item.phoneNo);
				$('##'+controlType+'Fax#stopNumber#').val(ui.item.fax);
				$('##'+controlType+'state#stopNumber#').val(ui.item.state);
				$('##'+controlType+'StateName#stopNumber#').val(ui.item.state);
				$('##'+controlType+'Email#stopNumber#').val(ui.item.email);
				addressChanged('#stopNumber#');
				var stopNum ="";
				var customerType ="";
				var idText = $(this).attr('id');

				 if(idText.indexOf("shipper")!=-1)
				{
					customerType= 'shipper';
					idText = idText.split("shipper");
				}
				else if(idText.indexOf("consignee")!=-1)
				{
					customerType= 'consignee';
					var idText = idText.split("consignee");
				}

				stopNum =idText[1];
				showChangeAlert(customerType,stopNum);
				return false;
			}
		});
		$(tag).data("ui-autocomplete")._renderItem = function(ul, item) {
			return $( "<li>"+item.name+"<br/><b><u>Address</u>:</b> "+ item.location+"&nbsp;&nbsp;&nbsp;<b><u>City</u>:</b>" + item.city+"&nbsp;&nbsp;&nbsp;<b><u>State</u>:</b> " + item.state+"<br/><b><u>Zip</u>:</b> " + item.zip+"</li>" )
					.appendTo( ul );
		}
	});

	
	//City Shippper City
	$("##shippercity#stopNumber#, ##consigneecity#stopNumber#").each(function(i, tag) {
		$(tag).autocomplete({
			multiple: false,
			width: 400,
			scroll: true,
			scrollHeight: 300,
			cacheLength: 1,
			highlight: false,
			dataType: "json",
			source: 'searchCustomersAutoFill.cfm?queryType=getCity',
			select: function(e, ui) {
				$(this).val(ui.item.city);
				strId = this.id;
				initialStr = strId.substr(0, 7);
				if(initialStr != 'shipper') {
					initialStr = 'consignee';
				}
				$('##'+initialStr+'state#stopNumber#').val(ui.item.state);
				$('##'+initialStr+'StateName#stopNumber#').val(ui.item.state);
				$('##'+initialStr+'Zipcode#stopNumber#').val(ui.item.zip);
				return false;
			}
		});
		$(tag).data("ui-autocomplete")._renderItem = function(ul, item) {
			return $( "<li>"+item.city+"<br/><b><u>State</u>:</b> "+ item.state+"&nbsp;&nbsp;&nbsp;<b><u>Zip</u>:</b>" + item.zip+"</li>" )
					.appendTo( ul );
		}
	});
		

	//zip AutoComplete
	$("##shipperZipcode#stopNumber#, ##consigneeZipcode#stopNumber#").each(function(i, tag) {
		$(tag).autocomplete({
			multiple: false,
			width: 400,
			scroll: true,
			scrollHeight: 300,
			cacheLength: 1,
			minLength: 1,
			highlight: false,
			dataType: "json",
			source: 'searchCustomersAutoFill.cfm?queryType=GetZip',
			select: function(e, ui) {
				$(this).val(ui.item.zip);
				strId = this.id;
				zipCodeVal=$('##'+strId).val();
				//auto complete the state and city based on first 5 characters of zip code
				if(zipCodeVal.length == 5)
				{
					initialStr = strId.substr(0, 7);
					if(initialStr != 'shipper')
						initialStr = 'consignee';
					//Donot update a field if there is already a value entered	
					if($('##'+initialStr+'state#stopNumber#').val() == '')
					{
						$('##'+initialStr+'state#stopNumber#').val(ui.item.state);
						$('##'+initialStr+'StateName#stopNumber#').val(ui.item.state);
					}	
					
					if($('##'+initialStr+'city#stopNumber#').val() == '')
					{
						$('##'+initialStr+'city#stopNumber#').val(ui.item.city);	
					}
					addressChanged('');
				}
				return false;
			}
		});
		$(tag).data("ui-autocomplete")._renderItem = function(ul, item) {
			return $( "<li>"+item.zip+"<br/><b><u>State</u>:</b> "+ item.state+"&nbsp;&nbsp;&nbsp;<b><u>City</u>:</b>" + item.city+"</li>" )
					.appendTo( ul );
		}
		
	});
	
	function formatCarrier#stopNumber#(mail) {
		return mail.name + "<br/><b><u>City</u>:</b> " + mail.city+"&nbsp;&nbsp;&nbsp;<b><u>State</u>:</b> " + mail.state+"&nbsp;&nbsp;&nbsp;<b><u>Zip</u>:</b> " + mail.zip+"&nbsp;&nbsp;&nbsp;<b><u>Insurance Expiry</u>:</b> " + mail.InsExpDate;
	}
	// Customer TropBox
	$("##selectedCarrierValue#stopNumber#").each(function(i, tag) {
		$(tag).autocomplete({
			multiple: false,
			width: 450,
			scroll: true,
			scrollHeight: 300,
			cacheLength: 1,
			highlight: false,
			dataType: "json",
			source: 'searchCarrierAutoFill.cfm?queryType=getCustomers&loadid=#loadid#',
			select: function(e, ui) {
				$(this).val(ui.item.name);
				$('##'+this.id+'ValueContainer#stopNumber#').val(ui.item.value);
				var strHtml = "<div class='clear'></div>"
					strHtml = strHtml + "<input name='carrierID#stopNumber#' id='carrierID#stopNumber#' type='hidden' value='"+ui.item.value+"' />"
					strHtml = strHtml + "<div class='clear'></div>"
					strHtml = strHtml + "<label>&nbsp;</label>"
					strHtml = strHtml + "<label class='field-textarea'>"
					strHtml = strHtml + "<b>"
					<cfif ListContains(session.rightsList,'bookCarrierToLoad',',')>
						strHtml = strHtml + "<a href='index.cfm?event=addcarrier&carrierid="+ui.item.value+"' style='color:##4322cc;text-decoration:underline;'>"
					<cfelse>
						strHtml = strHtml + "<a href='javascript: alert('Sorry!! You don\'t have rights to add/edit #variables.freightBroker#.'); return false;' style='color:##4322cc;text-decoration:underline;'>"
					</cfif>
					strHtml = strHtml + ui.item.name
					strHtml = strHtml + "</a>"
					strHtml = strHtml + "</b>"
					strHtml = strHtml + "<br/>"
					strHtml = strHtml + ""+ui.item.name+"<br/>"+ui.item.city+"<br/>"+ui.item.state+"&nbsp;-&nbsp;"+ui.item.zip+""
					strHtml = strHtml + "</label>"
					strHtml = strHtml + "<div class='clear'></div>"
					strHtml = strHtml + "<label>Tel</label>"
					strHtml = strHtml + "<label class='field-text'>"+ui.item.phoneNo+"</label>"
					strHtml = strHtml + "<div class='clear'></div>"
					strHtml = strHtml + "<label>Cell</label>"
					strHtml = strHtml + "<label class='field-text'>"+ui.item.cell+"</label>"
					strHtml = strHtml + "<div class='clear'></div>"
					strHtml = strHtml + "<label>Fax</label>"
					strHtml = strHtml + "<label class='field-text'>"+ui.item.fax+"</label>"
					strHtml = strHtml + "<div class='clear'></div>"
					strHtml = strHtml + "<label>Email</label>"
					strHtml = strHtml + "<label class='emailbox'>"+ui.item.email+"</label>";
				if(ui.item.insuranceExpired == 'yes')
				{
					alert('Warning!! This #variables.freightBroker# has expired insurance, please make sure this carrier�s insurance is updated.')
				}
				document.getElementById("CarrierInfo#stopNumber#").style.display = 'block';
				document.getElementById('choosCarrier#stopNumber#').style.display = 'none';
				//document.getElementById('addCarrierLink#stopNumber#').style.display = 'none';
				DisplayIntextFieldNext(ui.item.value, '#stopNumber#','#Application.dsn#');
				$('##CarrierInfo#stopNumber#').html(strHtml);
				getCarrierCommodityValue(ui.item.value,"unit",#stopNumber#);
				return false;
			}
		});
		$(tag).data("ui-autocomplete")._renderItem = function(ul, item) {
			return $( "<li>"+item.name+"<br/><b><u>City</u>:</b> "+ item.city+"&nbsp;&nbsp;&nbsp;<b><u>State</u>:</b>" + item.state+"&nbsp;&nbsp;&nbsp;<b><u>Zip</u>:</b> " + item.zip+"&nbsp;&nbsp;&nbsp;<b><u>Insurance Expiry</u>:</b> " + item.InsExpDate+"</li>" )
					.appendTo( ul );
		}
		
	});
});

</script>
</cfoutput>