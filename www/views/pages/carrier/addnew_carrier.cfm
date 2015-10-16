<cfoutput>
<cfajaxproxy cfc="#request.cfcpath#.loadgateway" jsclassname="ajaxLoadCutomer">
<!---Init the default value------->	  
<cfsilent>
 <cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />
 <cfset requireValidMCNumber = request.qGetSystemSetupOptions.requireValidMCNumber>
						
 <cfparam name="MCNumber" default=""> 
 <cfparam name="carrierid" default="">  
</cfsilent>

<cfif isDefined("url.carrierid") and len(url.carrierid)>
<div class="search-panel"><div class="delbutton"><a href="index.cfm?event=carrier&carrierid=#editid#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?','Delete Carrier');">  Delete</a></div></div>	
<h1>Edit Carrier <span style="padding-left:180px;">#Ucase(CarrierName)#</span></h1>
<cfelse>
 <cfset session.checkUnload ='add'>
<h1>Enter New Carrier</h1>
</cfif>
 <cfif isDefined("SaveContinue")>
	<cfif isDefined("MCNumber") and len(MCNumber) gt 0>
         <cfinvoke component="#request.cfcpath#.loadgateway" method="checkcarrierMCNumber" returnvariable="request.qcarrier"> 
         <cfinvokeargument name="McNumber" value="#McNumber#">
         <cfinvokeargument name="dsn" value="#application.dsn#">
         </cfinvoke>
         <cfif request.qcarrier.recordcount gte 1>
            <cfset carierid=request.qcarrier.CarrierID>
            <cfset message='<a href="index.cfm?event=addcarrier&carrierid=#request.qCarrier.CarrierID#&#session.URLToken#" style="text-decoration:font:bold;padding-left:96px;"> MC##  #McNumber# </a>'  &"already existed">
         <cfelse>
	        <cflocation url="index.cfm?event=addcarrier&mcno=#McNumber#&#session.urltoken#">         
         </cfif>  
	<cfelse>
		 <cflocation url="index.cfm?event=addcarrier&mcno=&#session.urltoken#">              
    </cfif>    
</cfif>

<!--- <cfif isdefined("message") and len(message)>
<div class="msg-area">#message#</div>
</cfif> --->


<div class="white-con-area">
		<div class="white-top"></div>
		<div class="white-mid-carrier">
		 <cfform name="frmNewCarrier" action="index.cfm?event=addnewcarrier:process&#session.urltoken#" method="post">
				<div class="form-con">
				 <fieldset>
				   <cfinput type="hidden" name="carrierid" id="carrierid" value="#carrierid#">
			       <cfif isdefined("message") and len(message)>
			         <div class="msg-carr">
			           
			           <div class="form-con">  
			           <ul class="load-link">                                                                  
			       <li>  <font size="3">#message#</font></li>
                       </ul> 
                       </div>                        
			         </div>
			       </cfif>
					    <div class="clear"></div>
				        <label>MC ##</label>
						<cfif requireValidMCNumber EQ True>
                    	  <cfinput name="MCNumber" id="MCNumber" type="text" tabindex="1"  value="#MCNumber#"  required="yes" message="Please enter MC Number"/> 				<cfelse>
						  <cfinput name="MCNumber" id="MCNumber" type="text" tabindex="1"  value="#MCNumber#"  />
						</cfif>
                        <cfinput name="SaveContinue" type="submit" class="normal-bttn" value="Continue>>"  onfocus="checkUnload();"/>                    		 
                  </fieldset>
				  </div>						
			<div class="clear"></div>					
		</cfform>
		<div class="clear"></div>
		</div>					
		<div class="white-bot"></div>
</div>
</cfoutput>	
