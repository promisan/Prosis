<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfparam name="url.init" default="0">

<!--- ----------------------- --->
<!--- ------end of check----- --->
<!--- ----------------------- --->

<cfif url.init eq "0">

	<!--- we are refreshing here --->

	<cfinclude template="InquiryWarehouseData.cfm">
	
</cfif>
						
	<table width="100%" border="0" bordercolor="white" cellspacing="0" cellpadding="0">				
		<tr>	
			<td width="30%"><cf_space spaces="7"></td>  
			<td align="right"><cf_space spaces="23"></td>
			<td align="right"><cf_space spaces="23"></td>
			<td width="30"></td>
			<td align="right"><cf_space spaces="25"></td>
			<td align="right"><cf_space spaces="20"></td>
			<td align="right"><cf_space spaces="20"></td>				   				   
			<td align="right"><cf_space spaces="20"></td>				
			<td width="30"></td>
			<td align="right"><cf_space spaces="20"></td>
			<td align="right"><cf_space spaces="20"></td>			
			<td align="right"><cf_space spaces="20"></td>	
			<td width="3"></td>									  
		</tr>

		<cfif WarehouseList.recordcount eq "0">		
				
		<tr>
			<td colspan="12" height="50" align="center" class="labelit">
				<font color="9E8956">There are no locations to be shown under your control.</font>
			</td>
		</tr>				
		
		</cfif>

		<cfset row = 0>
		
		<cfoutput query="WarehouseList" group="City">	
										
		<tr>
			<td colspan="12" style="padding-bottom:2px;padding-top:3px;padding-left:6px" class="labellarge"><font size="5" color="408080"><b>#City#</font></td>
		</tr>				
			

		<cfoutput group="Warehouse">				
					
			<tr>
				<td colspan="12" style="padding-top:8px;padding-left:7px;padding-bottom:3px">
				    <table cellspacing="0" cellpadding="0"><tr><td  class="labellarge">				
						<a href="javascript:warehouse('#warehouse#')">
							<cfif Pending gte "1"><font color="FF0000"><b>#WarehouseName#</b></font>
							<cfelse>
							<b>#WarehouseName#</b>
							</cfif> 
						</a>						
					</td>
					
					<td class="labelit" style="padding-top:4px;padding-left:4px">
					   <cfif Pending gte "1">
					   <img src="#session.root#/images/workflow3.gif" alt="Pending Confirmation" border="0" align="absmiddle">
					   <a href="javascript:stockconfirmation('#mission#','#warehouse#','#url.systemfunctionid#')"><font color="FF0000">#Pending# transaction<cfif Pending gte "2">s</cfif></font></a>
					   </cfif>
					   </td>
					
					<td style="padding-left:10px">
					
						<img src="#SESSION.root#/images/print.png" 
							height="20" 
							style="cursor:pointer;" 
							title="printable version" 
							onclick="window.open('Stock/InquiryWarehousePrint.cfm?warehouse=#warehouse#&location=', 'WarehouseStatistics', 'left=100, top=100, width=1000, height=700, toolbar=no, status=no, scrollbars=no, resizable=no');">
							
					</td>
					</tr></table>
				</td>
			</tr>		
			<tr><td colspan="12" class="linedotted"></td></tr>
		
			<cfoutput group="LocationId">	
			
			<cfquery name="Cat" dbtype="query">
				SELECT DISTINCT CategoryDescription				   
				FROM   WarehouseList
				WHERE  Warehouse  = '#warehouse#'						
			</cfquery>		
													
			<tr id="line#warehouse#">
			   
				<td colspan="12" style="padding-top:4px;padding-left:18px" class="labelmedium">	
				
					<table cellspacing="0" cellpadding="0">
									    
						<tr>
						
							<cfif url.webapp eq "backoffice">
							    <cfset jvlink = "">
							<cfelse>
								<cfset jvlink = "itmrequest('#category#','','','#warehouse#','#storageid#')">
							</cfif>	
						
							<td class="labelmedium">		
							
								<cfif Cat.recordcount eq "1">	
								
									<a href="javascript:#jvlink#">
										<font color="0080C0">
											<cfif storagelocation eq "">			
												<font size="2" color="808080"><i>[<cf_tl id="Undefined">]</font>		
											<cfelse>												
												#StorageLocation#			
											</cfif>
										</font>
									</a>
								
								<cfelse>
															
									<cfif storagelocation eq "">			
										<font size="2" color="808080"><i>[<cf_tl id="Undefined">]</font>		
									<cfelse>												
										#StorageLocation#	
									</cfif>
								
								</cfif>
								
								
								</td>
								
								<cfif Cat.recordcount eq "1" and url.webapp neq "backoffice">	
									
									<td style="padding-left:15px">
																										
								    <img src="#client.virtualdir#/Images/request.jpg" 
										    style="cursor:pointer" 
											height="15" 
											width="15" 
											alt="Request" 
											onclick="#jvlink#">
								
									</td>		
								
								</td>
								
							</cfif>
										
							</td>
						
						</tr>
					
					</table>		
				
				</td>
			</tr>	
			
			<cfoutput group="CategoryDescription">																	
			
				<cfif Cat.recordcount gte "2">		
				
					<tr id="line#warehouse#">		
						<td colspan="12" style="padding-left:19px" class="label">
						
							<table cellspacing="0" cellpadding="0">
							
								<cfif url.webapp eq "backoffice">
								    <cfset jvlink = "">
								<cfelse>
									<cfset jvlink = "itmrequest('#category#','','','#warehouse#','#storageid#')">
								</cfif>	
													
								<tr><td class="labelmedium">			
									<i>
									<a href="javascript:#jvlink#">
									#CategoryDescription#
									</a></i>			
									</td>			
									<td style="padding-left:3px">
									
									<cfif url.webapp neq "backoffice">												
									
								    <img src="#client.virtualdir#/Images/request.jpg" 
										    style="cursor:pointer" 
											height="15" 
											width="15" 
											alt="Request" 
											onclick="#jvlink#">
											
									</cfif>		
								
									</td>		
								
								</tr>
							
							</table>
						
						</td>
					</tr>	
										
				</cfif>			
	
			<cfoutput group="ItemDescription">								
			
			<!--- define precision --->	
			<cf_precision number="#ItemPrecision#">
					
			<cfoutput group="UoMDescription">
																					
			<cfset row = row+1>		
			
			<!--- sum the details ON THE WAREHOUSE level make a special condition
			for summing the usable stock by not counting loweststock if not used in a location --->							    
			
			<cfquery name="Total" dbtype="query">
			
				SELECT SUM(MinimumStock) as tMinimumStock, 
				       SUM(OnDraft)      as tOnDraft, 
				       SUM(OnRequest)    as tOnRequest,
					   SUM(OnCancel)     as tOnCancel,
				       SUM(OnHand)       as tOnHand,
				       SUM(MaximumStock) as tMaximumStock,
					   SUM(LowestStock)  as tLowestStock,
					   SUM(Usable)       as tUsable
					   
				FROM   WarehouseList
				WHERE  ItemNo     = '#ItemNo#'
				AND    UoM        = '#uom#'
				AND    Warehouse  = '#warehouse#'
				<cfif locationid eq "">
				AND    LocationId is NULL
				<cfelse>
				AND    LocationId = '#locationid#'
				</cfif>
				
			</cfquery>															
	
			<tr id="line#warehouse#">			
				<td width="30%" height="20" class="linedotted">			
					<table width="100%" cellspacing="0" cellpadding="0">									
						<tr>									
							
							<td width="5%" style="padding-left:20px;padding-right:9px">							
								<cf_img icon="expand" id="detsel_#row#" toggle="Yes" onclick="maximizecss('det_#row#')">													
							</td>		
																					
							<td>
							    							
								<table width="100%">
								<tr>		
								
								<cfset jvlink = "itmrequest('#category#','#itemno#','#uom#','#warehouse#','#storageid#')">	
																
								<td class="verdana">								
								<cfif enablePortal eq "1" and url.webapp neq "Backoffice">	
								<!---			    
								<a href="javascript:#jvlink#">							
									<font color="0080C0">
									--->
									#ItemDescription# [#UoMDescription#]
									<!---
									</font>								
								</a>
								--->
								<cfelse>
								#ItemDescription# [#UoMDescription#]
								</cfif>
								</td>
								
								<!--- disabled on the item level as we allow for multile request 
								
								<td width="40%" align="left" style="padding-right:2px">
								
								<cfif Cat.recordcount eq "1">
															
								    <cfif enablePortal eq "1" and url.webapp neq "Backoffice">
									
										<cfset jvlink = "itmrequest('#category#','#itemno#','#uom#','#warehouse#','#storageid#')">	
									
									    <img src="#client.virtualdir#/Images/request.jpg" 
											    style="cursor:pointer" 
												height="15" 
												width="15" 
												alt="Request" 
												onclick="#jvlink#">
											
									</cfif>
								
								</cfif>
								
							    </td>	
								--->
									
								</tr>
								</table>
								
							</td>													
														
						</tr>									
					</table>			  
				</td>				
				<!--- totals --->																		
				<td bgcolor="ffffdf" 
				    class="linedotted" 
					align="right" 
					id="draft_#warehouse#_#storageid#_#itemno#_#uom#"
					class="verdana" style="cursor:pointer" 
					onclick="maximizecss('det_#row#');do_toggle('id','detsel_#row#')">								
					#numberformat(total.tOnDraft,'#pformat#')#</td>
					
				<td bgcolor="ffffdf" 
				    class="linedotted" 
					align="right" 
					id="request_#warehouse#_#storageid#_#itemno#_#uom#" 
					class="Verdana" 
					style="cursor:pointer;padding-right:3px" onclick="maximizecss('det_#row#');do_toggle('id','detsel_#row#')">
					<cfif total.tOnCancel gt "0"><font color="FF0000"></cfif>#numberformat(total.tOnRequest,'#pformat#')#</font></td>
				
				<td width="30" bgcolor="ffffff"></td>
				<td align="right" bgcolor="ECFFFF" class="linedotted"><font face="Verdana">#numberformat(total.tMinimumstock,'#pformat#')#</td>				
				<td class="linedotted" bgcolor="ECFFFF" style="padding-right:3px" align="right"><font face="Verdana">#numberformat(total.tMaximumstock,'#pformat#')#</td>				
				
				<cfif total.tMaximumstock neq "">
					<cfif total.tOnHand neq "">
						<cfset susage = total.tMaximumstock - total.tOnHand>				
					<cfelse>
						<cfset susage = total.tMaximumstock>
					</cfif>	
				<cfelseif total.tOnHand neq "">
					<cfset susage = -1 *  total.tOnHand>				
				<cfelse>
					<cfset susage = 0>				
				</cfif>
				
				<cfif susage lt "0">
					<td align="right" bgcolor="FF6464" style="border:1px dashed red">				
						<font color="FFFFFF">#numberformat(susage,'#pformat#')#
					</td>
				<cfelse>
					<td align="right"  bgcolor="ECFFFF" class="linedotted">
						#numberformat(susage,'#pformat#')#
					</td>
				</cfif>				
				
				<cfif total.tOnHand lt "0">		
				    <td align="right" class="verdana" bgcolor="FF6464" style="border:1px dashed red;padding-right:3px">	   	
					<font color="white">#numberformat(total.tOnHand,'(#pformat#)')#</font>
					</td>
				<cfelseif total.tOnHand gt  total.tMaximumstock and total.tMaximumstock gt "0">	
				     <td align="right" class="verdana" bgcolor="black" style="border:1px dashed red;padding-right:3px">	   	
					<font color="white">#numberformat(total.tOnHand,'(#pformat#)')#</font>
					</td>
				<cfelse>
				    <td align="right" bgcolor="ECFFFF">
					#numberformat(total.tOnHand,'(#pformat#)')#
					</td>
				</cfif>		
					
				</td>	
					
				<td></td>													
				
				<cfif total.tMinimumStock gt total.tUsable>
				   <td align="right" class="verdana" bgcolor="FF6464" style="border:1px dashed red;padding-right:3px">	   
				   <font color="FFFFFF"><b>#numberformat(total.tUsable,'#pformat#')#</font>
				   </td>
				<cfelse>
				   <td class="linedotted" class="verdana" bgcolor="ECFFFF" align="right">			   
				   #numberformat(total.tUsable,'#pformat#')#
				   </td>
				</cfif>	
				
				<td class="linedotted" bgcolor="ECFFFF" align="right">
					<cfif WarehouseDistributionAverage gte "1" and WarehouseOnHand gte "1">
						#numberformat(WarehouseOnHand/WarehouseDistributionAverage,'__._')#									  
					</cfif>
				</td>
				<td class="linedotted" bgcolor="ECFFFF" align="right"></td>					 				   			  	
				<td></td>
			</tr>	
			
			<cfset clrow = "0">													
	
			<cfoutput group="LocationClass">
			
			<cfset clrow = clrow+1>
	
			<tr id="det_#row#" name="det_#row#" class="hide">
				<td colspan="9" style="padding-left:30px;padding-top:3px">
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td width="13px" style="padding-left:10px;padding-right:5px" 
							     onClick="storageinfo('#storagelocation#', '#Warehouse#','#LocationId#','#LocationClassCode#','#itemno#','#itemuom#')">
								 
								<cf_img icon="expand" toggle="Yes" id="locdet_#row#_#clrow#">
															
							</td>
							
							<td class="verdana">
								<a title="View Fuel Levels" style="cursor:pointer;" 
								href="javascript:storageinfo('#storagelocation#', '#Warehouse#','#LocationId#','#LocationClassCode#','#itemno#','#itemuom#');do_toggle('id','locdet_#row#_#clrow#')">			 
								<font size="2" color="0080C0"><b>#LocationClass#</b></font></a>
							</td>
						</tr>
						
					</table>									
				</td>
			</tr>		
	
			<tr id="det_#row#" name="det_#row#" class="hide"><td height="1" colspan="9"></td></tr>
	
			<cfset prior = "">	
			
			<cfoutput>
	
			<tr id="det_#row#" name="det_#row#" class="hide"><td height="1" colspan="9"></td></tr>
			
			<tr id="det_#row#" name="det_#row#" class="hide">	
				<td style="padding-left:40px">		
					<table cellspacing="0" width="100%" cellpadding="0">
						<tr onmouseout="selectrow('id_#warehouse#_#location#_#itemno#_#uom#', 0, 'E9F3FC', '8EC6EE', 'C0C0C0');" 
							onmouseover="selectrow('id_#warehouse#_#location#_#itemno#_#uom#', 1, 'E9F3FC', '8EC6EE', 'C0C0C0');">
							<td width="5%" id="td1_id_#warehouse#_#location#_#itemno#_#uom#" style="padding-left:20px">														
								<cfset jvlink = "history('#warehouse#','#location#','#itemno#','#uom#')">
								<img src="#client.virtualdir#/images/history2.png" 
									alt="Stock History" height="14" style="cursor:pointer" border="0" onclick="#jvlink#">								
							</td>									
							<td style="padding-left:10px" id="td2_id_#warehouse#_#location#_#itemno#_#uom#"><font face="Verdana"><cfif location neq prior><!---#Location#--->#LocationDescription#</cfif></td>	
							<td align="right" width="40%" style="padding-right:30px" id="td3_id_#warehouse#_#location#_#itemno#_#uom#">#StorageCode#</td>   			 											
						</tr>									
					</table>	
				</td>	
				<td align="right" id="draft_#itemlocationid#" class="verdana">										
					<cfif ondraft gte "1">
					<a href="javascript:showcart('#itemlocationid#','#mission#','#warehouse#','#location#','#itemno#','#itemuom#','#onrequest#')">			 
					<font color="0080C0">
					#numberformat(ondraft,'#pformat#')#
					</font>
					</a>
					<cfelse>
					#numberformat(ondraft,'#pformat#')#
					</cfif>
				</td>
				<td align="right" id="request_#itemlocationid#" class="verdana" style="padding-right:3px">
					<cfif onrequest gte "1" or oncancel gt "0">
					<a href="javascript:showrequest('#itemlocationid#','#mission#','#onrequest#')">	
					<cfif onCancel gt "0"><font color="red"><cfelse><font color="0080C0"></cfif>		 
					#numberformat(onrequest,'#pformat#')#</font>
					</a>
					<cfelse>				
					#numberformat(onrequest,'#pformat#')#
					</font>
					</cfif>
				</td>
				<td width="30"></td>
				<td align="right" class="verdana">#numberformat(minimumstock,'#pformat#')#</td>
				<td align="right" class="verdana" style="padding-right:3px">#numberformat(maximumstock,'#pformat#')#</td>		
		
					<cfif maximumstock neq "">
						<cfif onhand gte "0">
							<cfset susage = maximumstock - onhand>
						<cfelse>
							<cfset susage = maximumstock>
						</cfif>
					<cfelseif onhand neq "">
						<cfset susage = -1 * onhand>
					<cfelse>
						<cfset susage = 0>	
					</cfif>
					
					<cfif susage lt "0">
					<td align="right" bgcolor="FF6464" style="border:1px dashed red">
					<font color="white">#numberformat(susage,'#pformat#')#
					</td>
					<cfelse>
					<td align="right"  bgcolor="ECFFFF" class="linedotted">
					#numberformat(susage,'#pformat#')#
					</td>
					</cfif>
					
				<cfif OnHand lt "0">		
				    <td align="right" class="verdana" bgcolor="FF6464" style="border:1px dashed red;padding-right:3px">	   	
					<a href="javascript:#jvlink#"><font color="white">#numberformat(OnHand,'(#pformat#)')#</font></a>
					</td>
				<cfelseif OnHand gt Maximumstock and Maximumstock gt "0">	
				     <td align="right" class="verdana" bgcolor="black" style="border:1px dashed red;padding-right:3px">	   	
					<a href="javascript:#jvlink#"><font color="white">#numberformat(OnHand,'(#pformat#)')#</font></a>
					</td>
				<cfelse>
				    <td align="right" bgcolor="ECFFFF">								
					<a href="javascript:#jvlink#">#numberformat(OnHand,'(#pformat#)')#</a>
					</td>
				</cfif>			
												
				<td></td>		
					
				<cfif onhand eq "">
				      <cfset low = "0">
				<cfelseif onhand lte loweststock>
				      <cfset low = "0">	  
				<cfelse>			
					<cfif loweststock eq "">
					   <cfset low = onhand>
					<cfelse>			  
					   <cfset low = onhand-loweststock>   			
					</cfif>				
				</cfif>
				
				<cfif minimumstock gt low>
				
				  <td align="right" class="verdana" bgcolor="FF6464" style="border:1px dashed red;padding-right:3px">			   
					<font color="white">#numberformat(low,'(#pformat#)')#</font>
				  </td>						
				  
				<cfelse>
				
				  <td align="right" class="verdana">															
					#numberformat(low,'(#pformat#)')#						
				  </td>						
				  
				</cfif>	
										 
				<td align="right">
				   <cfif DistributionAverage gte "1" and OnHand gte "1">
						#numberformat(onhand/DistributionAverage,'__._')#									  
					</cfif>	
				</td>
				<td align="right" class="verdana" style="padding-right:5px">											  
					<cfif lastupdated eq "">never
					<cfelse><cfset diff = dateDiff("d",lastupdated,now())>
						<cfif diff lte 1>today
						<cfelseif diff eq 2>yesterday
						<cfelseif diff gte 3><font color="FF0000">#diff#d ago	  
						</cfif>
					</cfif>
				</td>
				<td></td>								
			</tr>	
			
			<!--- contentbox for detailed drill --->															
			<tr id="det_#row#" name="det_#row#" class="hide">								
				<td colspan="12" 
				    height="1" 
				    style="padding-top:10px;padding-bottom:10px" 
					align="center" 
					id="content_#itemlocationid#" 
					class="hide"></td>
			</tr>																																
			
			<tr id="det_#row#" name="det_#row#" class="hide">
			    <td height="0" colspan="12"></td>
			</tr>		
											
			<cfset prior = location>
			</cfoutput>	
			
			<!--- location tank info --->
						
			<tr id="det_#row#" name="det_#row#" class="hide">			   				
				<td colspan="12" align="center">	
										
					<table width="100%" align="center" cellspacing="0" cellpadding="0">		
					
						<cfset vTankId = "#storagelocation#_#Warehouse#_#LocationId#_#ItemNo#_#UoM#_#LocationClassCode#">
						<cfset vTankId = replace(vTankId, " ", "_", "ALL")>		
									
						<tr id="storage_#vTankId#" class="hide">
							<td style="padding-left:46px;padding-right:43" align="center" id="storagecontent_#vTankId#"></td>
						</tr>			
										
					</table>							
					
				</td>							
			</tr>		
									
			</cfoutput>							
			<!--- uom --->		
			</cfoutput>		
			<!--- item --->	
			</cfoutput>	
			<!--- cat --->		
			</cfoutput>	
			<!--- geo --->	
		</cfoutput>	
		<!--- warehouse --->	
		</cfoutput>
		<!--- city --->	
		</cfoutput>
	
	</table>
							