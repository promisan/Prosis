
<cfset pending = "">

<table width="99%" class="navigation_table" navigationselected="transparent" 
      navigationhover="transparent" style="padding-right:4px" align="center" cellspacing="0" cellpadding="3"> 
				
		<cfoutput query="Deliveries" group="OrgUnitOwner">
		
		<tr class="line clsDeliveryRow_s labelmedium" style="border-top:0px solid black">			  			    				
				<td class="cconten_zt" colspan="6" style="padding:2px;font-size:22px;height:40px">				
						<cfif currentrow eq "1"><cf_space spaces="60"></cfif>#OrgUnitName#
				</td>											
		</tr>			
		
		<cfoutput>
				
			<cfparam name="form.color_#orgunitOwner#" default="FFFF00">			
			<cfset color = evaluate("form.color_#orgunitOwner#")>
									
			<cfif color eq "0000FF">
				<cfset color="5f9fe8">
			<cfelseif color eq "FF0000">
				<cfset color="f53b3b">
			<cfelseif color eq "008000">
				<cfset color="4ea84e">
			<cfelseif color eq "FFFF00">
				<cfset color="e5e574">
			</cfif>
			<cfif color eq "0000FF" or color eq "FF0000" or color eq "008000">
			  <cfset fontcolor = "black">
			<cfelse>
			  <cfset fontcolor = "black" >
			</cfif>
			
		   <!--- get info on the branch --->	
				   
		   <cfquery name="Branch"
			datasource="appsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				SELECT *
				FROM   PostalCode
				WHERE  Country = '#nat#'
				AND    PostalCode = (
				
							 SELECT TOP 1 PostalCode
							 FROM   Organization.dbo.vwOrganizationAddress
							 WHERE  OrgUnit     = '#OrgUnitOwner#'
							 AND    AddressType = 'Office' 
							 
							 )				
				
		   	</cfquery>	
																		
			<cfif Branch.Latitude eq "">				   
				<cfset vOrigin = PostalCode>
			<cfelse>
				<cfset vOrigin = "#Branch.latitude#,#Branch.longitude#">
			</cfif>
			
			<cfset vOrigin = "11">
			
			<cfif latitude eq "">				   
				<cfset vDestination = PostalCode>
			<cfelse>
				<cfset vDestination = "#Latitude#,#Longitude#">
			</cfif>
			
			<tr class="line clsDeliveryRow navigation_row labelmedium" style="border-top:1px solid black" bgcolor="#color#">
			    <td class="hide ccontent">#OrgUnitName#</td>	 
			    <td style="width:20px;padding-right:5px" class="navigation_pointer"></td> 
				<td style="padding-left:2px">#currentrow#.</td>						
				<td class="ccontent" style="padding:2px">#CustomerName#</td>
				<td class="ccontent" style="padding:2px">#Address# #AddressNo#</td>
				<td class="ccontent" style="padding:2px">#PostalCode#</td>				
				<td class="ccontent" style="padding:2px">#City#</td>   				
			</tr>				
			
			<!--- provisioning --->
			
			<cfinvoke component = "Service.Process.WorkOrder.Provisioning"  
			   method           = "getProvisioning" 
			   workorderid      = "#workorderid#" 
			   workorderline    = "#workorderline#"			   
			   returnvariable   = "resultset">	
			
			<cfif resultset.recordcount gte "1">
			
				<tr class="clsDeliveryRow line">		
				    <td></td>
					<td class="hide ccontent">#OrgUnitName# #CustomerName# #Address# #AddressNo# #PostalCode# #City#</td>	   
				    <td bgcolor="green" align="center" colspan="6" style="filter: alpha(opacity=70);-moz-opacity: .70;opacity: .70;" class="labelit">
					<table>
					<cfloop query="resultset">
						<tr><td class="labelit"><font color="FFFFFF">#UnitDescription# (#quantity#)</td></tr>			
					</cfloop>
					</table>			
				</td></tr>
			
			</cfif>		
								
			<tr class="clsDeliveryRow line">
			
				<td class="hide ccontent">#OrgUnitName# #CustomerName# #Address# #AddressNo# #PostalCode# #City#</td>	
				<td></td>
			    <td colspan="6">
				
					<table width="100%" cellspacing="0" cellpadding="0">
					
					<cfif len(instructions) gte "3">
					<tr bgcolor="#color#">						
						<td colspan="2" style="padding-left:5px;filter: alpha(opacity=70);-moz-opacity: .70;opacity: .70;" class="labelmedium">						
						<cfif len(instructions) lte "2">- No instructions -<cfelse>#Instructions#</cfif>
						
						</td>
					</tr>
					</cfif>
					
					<tr bgcolor="f4f4f4" class="line">						
						<td colspan="2" style="padding-left:5px" class="labelmedium"><font color="black">#item# #size#</font></td>
					</tr>	
					<tr bgcolor="f4f4f4" class="line">													
						<td style="padding:2px" colspan="1" class="labelit"><font size="1" color="#fontcolor#"><cf_tl id="Mobile">:&nbsp;<font size="2" color="#fontcolor#"><cfif MobileNumber neq ""><b>#MobileNumber#<cfelse> <font color="FF0000">n/a</cfif></td>
						<td style="padding:2px" colspan="1" class="labelit"><font size="1" color="#fontcolor#"><cf_tl id="Phone">:&nbsp;<font size="2" color="#fontcolor#"><cfif PhoneNumber neq ""><b>#PhoneNumber#<cfelse> n/a</cfif></td>			
					</tr>					
									
					<tr>
											   		   
						   <td colspan="2" id="#workorderlineid#">	   			    
						   
						   <cfif schedule neq "">
						      <cfset  co = "FEDFA5">
						   <cfelse>
						      <cfset  co = "">
						   </cfif>		
						   
						   <table width="100%" align="center">
							
							   <tr>
							   														   				   					
								<td width="25" valign="top" style="padding-top:3px">					
								
								<cfif DateTimeActual eq ""> <!--- line is not completed yet --->										
									<cfif len(MobileNumber) gte "6">					
										<img src="#SESSION.root#/images/sms.png" style="cursor:pointer"							   
										   onclick="ptoken.navigate('Planner/setNotification.cfm?dts=#url.dts#&workorderlineid=#workorderlineid#&topic=f010','#workorderlineid#_notification')">						
									</cfif>	   					
								</cfif>					
								
								</td>	
																								
								<td width="30" valign="top" class="labelit" style="padding-top:3px;padding-left:5px" id="#workorderlineid#_notification">																		
								<cfif Notification neq "1">
									<font color="FF0000"><b><cf_tl id="No"></b></font>	
								<cfelse>						
									<font color="green"><b><cf_tl id="Yes"></b></font>						
								</cfif>
								</td>
								
								<td></td>	
												
								<!--- schedule , if the line is delivered, you can no longer apply the scheduling anymore : 3/1/2015 --->					
								
								<td class="hide" id="#workactionid#_process"></td> 					
							 	
								<td class="labelmedium" style="padding:5px">															
								 <table width="400"><tr>			
								 			   
									 <td align="right" valign="top" style="width:20px;padding-top:2px;padding-right:5px" class="labelmedium">					
									
									    <cfif DateTimeActual eq "">													
										    <cfset link = "_cf_loadingtexthtml='';ptoken.navigate('Planner/WorkPlan.cfm?action=apply&row=#currentrow#&workactionid=#workactionid#&workorderlineid=#workorderlineid#&dts=#url.dts#&mission=#url.mission#&positionno='+document.getElementById('positionno').value,'#workactionid#_workplan')">
											<cf_img icon="open" onclick="#link#">	   											
										<cfelse>						
											<font color="008080">#dateformat(DateTimeActual,client.dateformatshow)# #timeformat(DateTimeActual,"HH:MM")#</font>
										</cfif>						
										
									 </td>
									 							 
									 <cfif lastname eq "">
									   <cfif pending eq "">
									   	   <cfset pending = "'#workactionid#'">
									   <cfelse>
										   <cfset pending = "#pending#,'#workactionid#'">
									   </cfif>
									 </cfif>
									 
									 <td bgcolor="e4e4e4" class="labelmedium" id="#workactionid#_workplan" 
									  style="border-radius:2px;padding-left:8px;border:1px solid silver;width:200px">
									  
									     <cfif schedule eq "">
										 
										 <table><tr><td>
										 
												<table>
												<tr>
													<td valign="top" style="padding:6px">
													
													<table width="100%">	
													
													<tr class="labelmedium"><td style="padding-left:6px;padding-right:10px"><cf_tl id="Actor">:</td>
														<td>
																																																														
														<select name="PositionNo_#currentrow#" style="width:200px" class="regularxl PositionSync">
														    <!--- <option value=""></option> --->
															<cfloop query="Actor">
																<option value="#PositionNo#">#LastName# #FirstName# [#PositionNo#]</option>
															</cfloop>	
														</select>
																
														</td>
													</tr>													
													
													<tr class="labelmedium"><td style="padding-left:6px;padding-right:10px"><cf_tl id="Callsign">:</td>
													
														<td>	
																																   					   
														<select name="Topic_f004_#currentrow#" style="width:200px" class="regularxl f004Sync">
														    <!---
															<option value=""></option>																												
															--->
															<cfloop query="GetList">					  
																<option value="#ListCode#">#GetList.ListValue#</option>
															</cfloop>									
														</select>	
															
														</td>
													</tr>
													
													<tr class="labelmedium"><td style="padding-left:6px;padding-right:11px"><cf_tl id="Schedule">:</td>
														<td>
																																										
														<select name="PlanOrderCode_#currentrow#" style="width:200px" class="regularxl">	
														    <!---														
															<option value=""></option>															
															--->
															<cfloop query="PlanOrder">
																<option value="#Code#">#Description#</option>
															</cfloop>	
														</select>
														
														</td>
													</tr>
																										
													<tr>
														<td></td>
														<td style="height:31px" colspan="1">
																												
														   <input type="button" type="text" name="Save" value="Update" class="button10g" 
														    onclick="applyPlan('#workactionid#','#url.date#','#currentrow#')">
														</td>
													</tr>
																										
													</table>
													
													</td>
													</tr>
												
												</table>		 
										 										 
										 </td></tr></table>
										 
										 <cfelse>
									  																							  										  
										  <table style="width:100%">
											  <tr class="fixlengthlist labelmedium2">
												  
												  <td>
												  
												  <cfset link = "_cf_loadingtexthtml='';ptoken.navigate('Planner/WorkPlanDelete.cfm?action=revert&personno=#personno#&workactionid=#workactionid#&dts=#url.dts#&mission=#url.mission#','#workactionid#_workplan')">					
											
												  <cfif DateTimeActual eq "" and lastName neq "">		
											  		<cf_img icon="delete" onclick="#link#">						  	 
												  </cfif>							  
												  </td>
												  
												  <td>#firstname# #lastName# <cfif schedule neq "">/</cfif> #ScheduleName#</td>
											  </tr>
										  </table>		
										  
										 </cfif> 								  
										  											  
									  </td>							 
									 
								</tr></table>											
								</td>														
														
							   </tr>				   
							
							</table>					   
							
						   </td>
						   </tr>
					
						   <tr><td height="6"></td></tr>
						
					</table>
				</td>	
			</tr>		
			
		</cfoutput>		
											
		</cfoutput>
				
		<tr><td id="pendingbox"></td></tr>
		
		<tr><td>
				
		<cfoutput>
			<input type="hidden" name="pendingmanual" value="#pending#">
		</cfoutput>
				
		</td></tr>
				
</table>

<cfset ajaxonload("doHighlight")>