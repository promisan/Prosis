
<cfparam name="URL.show" default="0">
<cfparam name="URL.calendar" default="0">
		
<cfoutput>

<table width="100%" border="0" cellspacing="2" cellpadding="1">
		        
	    <cfif stopover eq "0">							
			<cfset cls = "regular">			
		<cfelse>
			
		    <!--- show expansion line ---> 				
			<cfif show eq "3">					
			    <cfset cls = "regular">				   
			<cfelse>
											
				<cfif #TripArrival.LocationCity# eq "">
				    <cfset cls = "Add Connection/Stopover">
				<cfelse>
					<cfset cls = "Add Connection/Stopover">
				</cfif>

				<tr><td colspan="2" height="30" align="left">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="submit" name="addstopover" value="#cls#" class="button10s">
															
				</td></tr>
														
				<cfset cls = "hide">
				   
				</cfif>
												
			</cfif>
			
			<cfif cls neq "hide">
													
				<tr><td colspan="2">
				
					<table 
						width="100%" 
						border="0" 
						cellspacing="0" 
						cellpadding="0" 
						id="s#stopover#" 
						class="#cls#">
											
						<cfif stopover neq "0">	
						
							<tr>
								<td colspan="3" height="23">&nbsp;<b>Connection/Stopover #stopover#</b>
								<img src="#SESSION.root#/Images/claim/stopover.gif" alt="Stopover/connection" border="0" align="absmiddle">														
								</td>
								<td align="center">
								<button name="delstopover"  type="button" class="button10g" onclick="delleg('#claimeventId#','#stopover#')">
								<font color="0080C0"><b>Remove Stopover</b></font>
								</button>&nbsp;
								</td>
							</tr>
							<tr><td height="1" colspan="4" bgcolor="C0C0C0"></td></tr>
						
						<cfelse>						
						
							<tr><td colspan="2" height="19">&nbsp;<b>Arrival</td></tr>
							<tr><td height="1" colspan="4" bgcolor="C0C0C0"></td></tr>												
							
						</cfif>
					
					</table>
					</td>
				</tr>
																									
				<tr>
					<td width="70" height="20" align="right">&nbsp;City:&nbsp;</td>
					
					<td width="100%">
					
					<table border="0" width="100%" cellspacing="0" cellpadding="0" bordercolor="97A8BB">
					
						<tr>
						
						<td width="20" align="center">							
						
						 <button class="button3" style="height:20"
					          onClick="selectcity('arrcityid_#stopover#','#triparrival.claimtripid#')">
							     					  
							   <img src="#SESSION.root#/Images/locate.gif" 
							    name   = "img1_#StopOver#" 
								onMouseOver= "document.img1_#StopOver#.src='#SESSION.root#/Images/locate.gif'" 
								onMouseOut = "document.img1_#StopOver#.src='#SESSION.root#/Images/locate.gif'"
							    alt     ="Search" 
							    border  ="0" 
							    align   ="absmiddle" 
							    style   ="cursor: hand;">
								
						 </button>						  
										
						</td>
						
						<td height="25">	
						
							<cfdiv id="arrcityid_#stopover#_fld" 
     						bind="url:ClaimEventEntryCity.cfm?claimtripid=#triparrival.claimtripid#&fld=arrcityid_#stopover#&cityid=#triparrival.countrycityid#"/>							
						</td>
						<td>	
							<cfinput type="text" style="width:1px"						       
							   name="arrcityid_#stopover#"  
							   required="Yes"
							   Message="Please select a stopover location"
							   value="#Triparrival.CountryCityId#">	
								   
						</td>					
						
						</tr>					
						
					</table>
			
					
					</td>		
					
				</tr>							
													
					<cfif stopover eq "0">
					  <cfset list = "Arrival">
					<cfelse>
					  <cfset list = "Arrival,Departure">
					</cfif>
										
					<cfloop index="itm" list="#list#" delimiters=",">
					
						<cfif itm eq "Departure">
						
							<cfset box = box+1>
						
							<cfquery name="TripArrival" 
							datasource="appsTravelClaim" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT TOP 1 *
						    FROM  ClaimEventTrip T,  
							      ClaimEvent E
						    WHERE T.ClaimEventId = '#URL.ID1#'
							AND   T.ClaimEventId = E.ClaimEventId
							AND   T.ClaimTripMode = 'Departure'
							AND   T.ClaimTripStop = '#stopover#'
							ORDER BY LocationDate DESC
							</cfquery>	
																			
						</cfif>
						
						<tr>
						
					    <td align="right" height="25">&nbsp;<cfif #itm# eq "Arrival">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</cfif>#itm#:&nbsp;</td>
						
						<td width="90%">
							<table border="0" cellspacing="0" cellpadding="0">
													
								<tr>
								<td width="120">
																
								<cfif stopover neq "0">
								  <cfset enf = "True">
								<cfelse>
								  <cfset enf = "False"> 
								</cfif>
								
								<cfquery name="TripDeparture" 
									datasource="appsTravelClaim" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT TOP 1 *
									    FROM  ClaimEventTrip T
									    WHERE T.ClaimEventId = '#URL.ID1#'
										AND   T.ClaimTripMode = 'Departure'
										AND   T.ClaimTripStop = '0'
								</cfquery>	
													
							    <cfif TripArrival.recordcount eq "1">
									
									<cfset dte = "#Dateformat(TripArrival.LocationDate, CLIENT.DateFormatShow)#">
									
								<cfelse>
																	
									<cfif TripDeparture.recordcount eq "1">
										<cfset dte = "#Dateformat(TripDeparture.LocationDate, CLIENT.DateFormatShow)#">
									<cfelseif TripRequest.DateDeparture neq "">
										<cfset dte = "#Dateformat(TripRequest.DateDeparture, CLIENT.DateFormatShow)#">
									<cfelse>
									    <cfset dte = "#Dateformat(now(), CLIENT.DateFormatShow)#">
									</cfif>	
									
								</cfif>
									
								<cfif stopover eq "0" or calendar eq "1">  <!--- Parameter.ShowCalendar# eq "1"> --->
																						
										 <cf_intelliCalendarDate7
										FieldName="Date#Itm#_#stopover#" 
										Default="#dte#"
										AllowBlank="false"
										Mask="false"
										Tooltip="#Itm# date (dd/mm/yy) "
										message="Please enter a valid date">	
																											
									<cfelse>
																										
									<cfinput type="Text"
									      name="Date#Itm#_#stopover#"
									      value="#dte#"
									      message="Please enter a valid date"
									      validate="eurodate"
									      required="Yes"
									      visible="Yes"
									      enabled="Yes"
									      style="text-align: center"
									      size="12"
									      class="regular">
										  
									</cfif>	  
															
									<cfset thr  = #Timeformat(TripArrival.LocationDate, "HH")#>
									<cfset tmin = #Timeformat(TripArrival.LocationDate, "MM")#>
									<cfset tsec = #Timeformat(TripArrival.LocationDate, "SS")#>

									<!--- special meaning for null entries --->
									<cfif (tsec eq "15" or tsec eq "45") and thr eq "23" and tmin eq "59">
										<cfset thr = "">
										<cfset tmin = "">									
									</cfif>
																
									<td height="25">
										&nbsp;&nbsp;Time:&nbsp;&nbsp;</td>
								    <td align="center">
									
									<cfif #TripArrival.ActionStatus# eq "0">
										<cfset thr = "">
										<cfset tmin = "">
									</cfif>
									
									<cfif stopover eq "0">
									  <cfset req = "No">
									<cfelse>
									  <cfset req = "Yes">  
									</cfif>
																											
									<cfinput type = "Text"
								       name       = "hour#Itm#_#stopover#" 
								       value      = "#thr#"
								       maxlength  = "2"
									   message    = "Please enter time using 24 hour format"
								       validate   = "regular_expression"
								       pattern    = "[0-1][0-9]|[2][0-3]"
									   onKeyUp    = "return autoTab(this, 2, event);"
								       size       = "1"
									   required   = "#req#"
								       style      = "text-align: center;width:25"
								       class      = "regular">
																			
								    </td>
									<TD align="center">:</TD>
								    <td align="center">
								
									<cfinput type="Text"
								       name="minute#Itm#_#stopover#"
								       value="#tmin#"
								       message="Please enter a valid minute between 00 and 59"
								       maxlength="2"
									   validate="regular_expression"
								       pattern="[0-5][0-9]"
								       required="#req#"
									   size="1"
								       style="text-align: center;width:25"
								       class="regular">
																				
								    </td>
									<td width="10">
									 <cf_helpfile 
									   code = "TravelClaim" 
			    				       id   = "2">
									</td>			
					    			<td height="25">
									
										
									<cfquery name="Event" 
										datasource="appsTravelClaim" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT *
										FROM Ref_ClaimEvent
										WHERE Code = '#triparrival.eventcode#'   
									</cfquery>	
									
										<cfif event.pointertransport eq "1">
										   <cfset m = "hide">
										<cfelse>
										   <cfset m = "regular">  
										</cfif>
									
										<table border="0" cellspacing="0" cellpadding="0">
										<tr><td class="#m#" id="pointer#box#">
																				
										<cfif itm eq "Arrival" and #stopover# eq "0">
										
											<cfquery name="MSA" 
											datasource="appsTravelClaim" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											SELECT   *
											FROM      Ref_CountryCity C INNER JOIN
									                  Ref_CountryCityLocation R ON C.CountryCityId = R.CountryCityId INNER JOIN
								                      Ref_ClaimRates Rate ON R.LocationCode = Rate.ServiceLocation
											WHERE     (Rate.ClaimCategory = 'MSA') 
											AND (C.CountryCityId = '#TripArrival.countryCityId#')
											</cfquery>
										
											<cfif MSA.recordcount gte "1">
											   	<cfset Cat = "'#itm#','MSA'">
											<cfelse>	
												<cfset Cat = "'#itm#'">		
											</cfif>
											
										<cfelse>
										
										    <cfset Cat = "'#itm#'">
											
										</cfif>
																																																		
										 <cf_ClaimEventEntryIndicatorPointer
										 Category  = "#Cat#"
										 tripid   = "#TripArrival.ClaimTripId#"
										 fld      = "#Itm#_#stopover#">
																				
										</td>
									
										</tr>	
										</table>
										
									</td>
									</tr>
															
							</table>
							
						</td></tr>
													
						<cfif itm eq "Departure">
						
							<tr><td></td>
								<td>
								<table cellspacing="0" cellpadding="1">
								
										<tr><td height="4"></td></tr>
										<tr>
										<td>Mode:&nbsp;</td>	
										<td>
											<select name="EventCode#Itm#_#stopover#" 
											onChange="ref(this.value,'#stopover#','pointer#box#')">
											<cfloop query="TravelMode">
											    <option value="#Code#" <cfif #Code# eq "#TripArrival.EventCode#">selected</cfif>>#Description#</option>
											</cfloop>
											</select>
										</td>
										
										<cfif parameter.StopoverHours eq "0">
										<td>&nbsp;&nbsp;&nbsp;Overnight&nbsp;Rest Stop:&nbsp;</td>
										<td>										
										<input type="checkbox" name="OvernightStay#Itm#_#stopover#" <cfif "1" eq "#TripArrival.OvernightStay#">checked</cfif> value="1">
										</td>
										</cfif>
										
										<cfif itm eq "Departure">
										
											<cfif #TripArrival.EventCode# eq "Air" or #TripArrival.EventCode# eq "">
										 	  <cfset cl = "regular">
											<cfelse>
											  <cfset cl = "hide">
											</cfif>
										    <td class="#cl#" id="ref1_#stopover#">&nbsp;&nbsp;Flight&nbsp;No:</td>
										    <td class="#cl#" id="ref2_#stopover#">&nbsp;<input type="text" name="EventReference_#stopover#"  value="#TripArrival.EventReference#" size="10" maxlength="10" class="regular">
											
										</cfif>
														
										</tr>	
										
								</table>
								</td>
							</tr>			
								
							</cfif>	
											
					</cfloop>
				
			</cfif>
											
	</table>
	
</cfoutput>