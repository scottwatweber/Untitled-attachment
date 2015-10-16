	<cfset variables.Loads=arraynew(1)>
	<cfset variables.Loads=["Texas","TX","2015-05-29T00:00:00","Arkansas","AR","7EB896E7-D13A-4352-9E43-FF04344B07C0","LTL","F","2015-05-28T12:00:00","false"]>
	
	<cfscript>
		postMyLoad = postLoad ('LMGR428AP', 'scottw@webersystems.com', 'weber908', variables.Loads );
		writeDump(postMyLoad); //output of soap api
		//details=xmlParse(postMyLoad.filecontent);
		//writeDump(getHttpResponse);
		//writeDump(details);
	</cfscript>
		<cffunction name="postLoad" access="public" returntype="any">	
			<cfargument name="PostProviderID" type="string" required="yes"> 
			<cfargument name="username" type="string" required="yes">
			<cfargument name="password" type="string" required="yes">
			<cfargument name="Load" type="array" required="yes">
			<cfscript>
				savecontent variable="myVariable" { 
					WriteOutput('<?xml version="1.0" encoding="UTF-8"?>
								<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
									<s:Header>
										<Action>http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0</Action>
									</s:Header> 
									<s:Body>
										<PostLoad xmlns="http://schemas.123loadboard.com/2009/05/06">
											<PostProviderID>LMGR428AP</PostProviderID>
											<UserName>scottw@webersystems.com</UserName>
											<Password>weber908</Password>
											<Loads xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
												<Load>
													<AmountType i:nil="true"/>
													<Commodity i:nil="true"/>
													<DelivDate>#arguments.Load[3]#</DelivDate>
													<DelivTime i:nil="true"/>
													<DestCity>#arguments.Load[1]#</DestCity>
													<DestState>#arguments.Load[2]#</DestState>
													<DestZipcode i:nil="true"/>
													<DispatcherEmail i:nil="true"/>
													<DispatcherExt i:nil="true"/>
													<DispatcherName i:nil="true"/>
													<DispatcherPhone i:nil="true"/>
													<EquipCode>#arguments.Load[8]#</EquipCode>
													<EquipInfo i:nil="true"/>
													<LoadID>#arguments.Load[6]#</LoadID>
													<LoadSize>#arguments.Load[7]#</LoadSize>
													<Notes i:nil="true"/>
													<OrigCity>#arguments.Load[4]#</OrigCity>
													<OrigLatitude>0</OrigLatitude>
													<OrigLongitude>0</OrigLongitude>
													<OrigState>#arguments.Load[5]#</OrigState>
													<OrigZipcode i:nil="true"/>
													<PickUpDate>#arguments.Load[9]#</PickUpDate>
													<PickUpTime i:nil="true"/>
													<RepeatDaily>#arguments.Load[10]#</RepeatDaily>
													<TeamLoad i:nil="true"/>
													<TrackNo i:nil="true"/>
												</Load>
											</Loads>
										</PostLoad>
									</s:Body>
								</s:Envelope>
								');
				}
				var getHttpResponse = "";
				var httpServiceParams = [
					{
						type = "xml",
						value = trim(myVariable)
					}
				];
				getHttpResponse = getHttpResponseMagnetMail ( method = "post", setUrl = "http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0", httpParameters = httpServiceParams );
				return getHttpResponse;
			</cfscript>
		</cffunction>
		
		<cffunction name="getHttpResponseMagnetMail" access="public" returntype="any">	
			<cfargument name="method" type="string" required="yes"> 
			<cfargument name="setUrl" type="string" required="yes">
			<cfargument name="httpParameters" type="array" required="yes">
			<cfscript>
				var httpService = new http();
				httpService.setMethod(arguments.method); 
				httpService.setUrl(arguments.setUrl);
				httpService.addParam(type="header",name="Content-Type", value="text/xml; charset=utf-8"); 
				httpService.addParam(type="header",name="host", value="ws.123loadboard.com"); 
				httpService.addParam(type="header",name="SOAPAction", value="PostLoad");
				if(arrayLen(arguments.httpParameters)){
					for(var parameter = 1; parameter <= arrayLen(arguments.httpParameters); parameter++) {
						httpService.addParam(type = arguments.httpParameters[parameter].type,value = arguments.httpParameters[parameter].value);  			
					}	
				}
				var httpResponse = httpService.send().getPrefix();
				return httpResponse;
			</cfscript>
		</cffunction>