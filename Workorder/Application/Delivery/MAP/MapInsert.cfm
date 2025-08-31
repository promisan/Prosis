<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="URL.date" 		default = "06/01/2015">
<cfparam name="URL.starttime" 	default = 7>
<cfparam name="URL.id" 			default = "">
<cfparam name="URL.cfmapname" 	default = "">

<cfparam name="url.mode" default="standard">

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTS = dateValue>

<cfset VARIABLES.Instance.date    = DTS/>
<cfset VARIABLES.Instance.dateSQL = DateFormat(dts,"DDMMYYY")/>
<cfset VARIABLES.Instance.Mission = URL.Mission/>

<cfif URL.cfmapname neq "">
	<cfquery name="qNode" datasource="AppsTransaction">
		SELECT * FROM stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
		WHERE Node = '#url.cfmapname#'
		AND Date = #VARIABLES.Instance.date#
	</cfquery>
	
	<cfquery name="qCheck" datasource="AppsTransaction">
		SELECT * FROM stWorkPlanDetails_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
		WHERE Date = #VARIABLES.Instance.date# AND Node = '#url.cfmapname#'
	</cfquery>	
	
	<cfif qCheck.recordcount eq 0 >
		
		<cfquery name="getLast" datasource="AppsTransaction">
			SELECT MAX(ListingOrder) lmax FROM stWorkPlanDetails_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
			WHERE Date = #VARIABLES.Instance.date#
		</cfquery>	
		
		
		<cfif getLast.lmax neq "">
			<cfset vMax = getLast.lmax+1>
		<cfelse>
			<cfset vMax = 0>
		</cfif>	
		
		<!--- It is new we have to gray the one out ---->
		<cfif qNode.Branch eq 0>
				<cfset vIcon = "Icons/white.png">
				<cf_addMarker 
				      name="#URL.cfmapname#" 
					  latitude="#qNode.Latitude#"
					  longitude="#qNode.Longitude#"
					  title="Added #qNode.CustomerName#"
					  markericon="#vIcon#">				
				
			<cfelse>
				<cfset vIcon = "Icons/blue.png">
				<cfquery name="qChildren" datasource="AppsTransaction">
					SELECT WorkOrderLineId
				    FROM   stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
					WHERE  OrgUnitOwner = '#URL.cfmapname#'
				</cfquery>		
		
				<cfoutput>
					<cfsavecontent variable="jRelated">[<cfloop query="qChildren">{"name":"#qChildren.WorkOrderLineId#"},</cfloop>{}]</cfsavecontent>
				</cfoutput>				
				
				<cf_addMarker 
				      name="#URL.cfmapname#" 
					  latitude="#qNode.Latitude#"
					  longitude="#qNode.Longitude#"
					  title="Added #qNode.CustomerName#"
					  markericon="#vIcon#"
					  related="#jRelated#">				
				
		</cfif>	
		
		<cfquery name="qInsertNode" datasource="AppsTransaction">
			INSERT INTO stWorkPlanDetails_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
			           (Date
			           ,Node
			           ,Duration
			           ,Distance
			           ,ListingOrder
			           ,PlanOrder
			           ,ActionStatus)
			     VALUES
			           (
			           #VARIABLES.Instance.date#
			           ,'#url.cfmapname#'
			           ,'0'
			           ,'0'
			           ,'#vMax#'
			           ,NULL
			           ,'1')
		</cfquery>
	
	</cfif>
</cfif>
	
	
<cfquery name="qFlow"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	  SELECT F.ListingOrder,
		     F.Date,
	         F.Node,
	         F.ListingOrder,
	         F.PlanOrder,
	         F.Distance,
	         F.Duration,
	         N.WorkOrderLineId,
	         N.Latitude,
	         N.Longitude,
	         N.Branch,
	         N.ZipCode,
	         N.CustomerName,
			 N.OrgUnitOwner,
	         O.OrgUnitName,
	         F.ActionStatus
	  FROM   stWorkPlanDetails_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# F INNER JOIN stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# N
			ON   F.Node = N.Node AND F.Date = N.Date 
		INNER JOIN Organization.dbo.Organization O
			ON   N.OrgUnitOwner = O.OrgUnit
		WHERE F.ActionStatus!=9
	    ORDER BY F.ListingOrder ASC
</cfquery>


<cfquery name="qTimeSlot"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#"> 
	SELECT Code,Description,ListingOrder
	FROM Ref_PlanOrder
	ORDER BY ListingOrder
</cfquery>	


<div id="dResult">
</div>
	
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" valign="top" style="border:1px dotted gray">

<cfoutput>
	<cfsavecontent variable="json_input_order">[<cfloop query="qTimeSlot">{"planorder":"#qTimeSlot.Code#","listingorder":"#qTimeSlot.ListingOrder#","description":"#qTimeSlot.Description#"},</cfloop>{}]</cfsavecontent>
	<input type="hidden" name="input_order" id="input_order" value='#json_input_order#'>
</cfoutput>	
<tr>	

			<td style="padding-top:3px;padding-right:5px" valign="top" class="labelmedium">
			<cf_divscroll>		
			<table width="100%" cellspacing="0" cellpadding="0" align="center" valign="top">
				
				<cfoutput>
					
				<tr valign="top">
					<td style="padding-top:3px;padding-right:5px" valign="top" class="labelmedium">
						<cfquery name="qPerson"
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">									
								SELECT PE.PersonNo,PE.FullName
								FROM Person PE INNER JOIN PersonAssignment PA
								ON PE.PersonNo = PA.PersonNo
								WHERE PA.DateEffective<=GETDATE() 
								AND PA.DateExpiration>=GETDATE()
								AND PA.AssignmentStatus in (0,1)
								ORDER BY FirstName ASC
							</cfquery>	 									
							
							<cfoutput>
								<select name="sPersonNo" style="font-size:28px;height:35px" id="sPersonNo" class="regularxl" onchange="javascript:setPlanDriver(this.value,'','#url.date#','')">
							    <cfloop query="qPerson">
									<option value="#qPerson.PersonNo#">#qPerson.FullName#</option>
								</cfloop>
								</select>
							</cfoutput>
					</td>
					
					<td>
						<cfif qFlow.recordcount gt 0>
							<button onclick="javascript:processcluster('','#url.date#','')">Calculate</button>
						</cfif>	
					</td>
					<td>
						<cfif qFlow.recordcount gt 0>
							<button onclick="javascript:confirmcluster('#url.date#')">Save</button>
						</cfif>	
					</td>	
						
				</tr>

				
				<tr class="labelmedium line" id="rlisting">
				
					<td colspan="3" style="padding:4px">
						<table>
							<tr>
							<td width="5%">
								<button type="button" class="button3" style="border:1px solid silver" onclick="javascript:deleteNodes('#URL.Date#','','')">
									 <img style="cursor:pointer" onclick="" src="#client.root#/images/deny.png" alt="" border="0">
								</button>								
							</td>
							<td width="5%"></td>
							<td width="5%">
									<button type="button" class="button3" style="border:1px solid silver" onclick="javascript:goUp();">
										 <img style="cursor:pointer" onclick="" src="#client.root#/images/up6.png" alt="" border="0">
									</button>								
							</td>	
							<td width="5%">
									<button type="button" class="button3" style="border:1px solid silver" onclick="javascript:goDown();">
										 <img style="cursor:pointer" onclick="" src="#client.root#/images/down6.png" alt="" border="0">
									</button>								
							</td>
							<td width="80%"></td>							
							</tr>
						</table>	
					</td>	
					
				</tr>	
				
				<tr id="trAdding" name="trAdding" class="hide">
					<td colspan="7">
						<table width="100%">
						<tr height="10px"><td colspan="3"></td></tr>							
						<tr>
							<td width="10%"></td>
							<td bgcolor="E6E6E6" id="tdAdding" name="tdAdding" colspan="6" style="border-radius:5px;padding-left:8px;border:1px solid gray;width:200px"></td>
							<td width="10%"></td>
						</tr>
						<tr height="10px"><td colspan="3"></td></tr>			
						</table>
					</td>
				</tr>	
				
				<!--- we need to change this to pick this up at runtime --->
				
				<tr><td colspan="7" height="600" style="padding-right:1px">
				
				<cf_divscroll style="height:100%">
				
				<table class="navigation_table" width="99%" cellspacing="0" cellpadding="0" align="center" id="WorkOrderAssigned" name="WorkOrderAssigned" valign="top">
							
				<cfset vDistance = 0>
				<cfset vDuration = 0>	
				
				<cfloop query="qFlow">
					<cfset current_color = "##B1D6F7">
					
					<tr id="row_#qFlow.Node#" class="line navigation_row">
					
						<td width="8%" align="center" style="height:40px" bgcolor="#current_color#">
						
							<input type="hidden" name="order_#qFlow.Node#" id="order_#qFlow.Node#" value="#qFlow.ListingOrder#" class="sorting_input">
							<input type="hidden" name="branch_#qFlow.Node#" id="branch_#qFlow.Node#" value="#qFlow.branch#">								
								
								<cfif qFlow.ActionStatus neq 9>
									<input type="checkbox" name="assigned_#qFlow.Node#" id="assigned_#qFlow.Node#" value="#qFlow.Node#" class="radiol nassigned" onclick="marknode('#URL.Id#','#qFlow.Node#','#qFlow.Branch#')">
								<cfelse>
									<cf_img icon="open" tooltip="reinstate in planning" onclick="reinstateNode('#URL.Date#','#qFlow.Node#','','')">
								</cfif>
					
								<cfquery name="qChildren"
									datasource="AppsTransaction" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT *
								    FROM   stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
									WHERE  Date = #dts#
									AND    Branch = 0
									AND    OrgUnitOwner = '#qFlow.OrgUnitOwner#'
								</cfquery>									
							<cfsavecontent variable="json_input">[<cfloop query="qChildren">{"node":"#qChildren.Node#","customer":"#qChildren.CustomerName#","latitude":"#qChildren.Latitude#","longitude":"#qChildren.Longitude#"},</cfloop>{}]</cfsavecontent>
							<input type="hidden" name="input_assigned_#qFlow.Node#" id="input_assigned_#qFlow.Node#" value='#json_input#'>
							
						</td>
						
						<td style="height:22px;padding-left:3px" width="15%">
							
								<cfif qFlow.ActionStatus eq 9>
									<cfset vStyle = "border-radius:4px;border:1px solid gray; visibility: hidden">
								<cfelse>
									<cfset vStyle = "border-radius:4px;border:1px solid gray">
								</cfif>	
								
								<select name="select_#qFlow.Node#" id="select_#qFlow.Node#" class="regularxl sorting_select" style="#vStyle#">
								<cfloop query="qTimeSlot">
									<option value="#code#" <cfif code eq qFlow.PlanOrder>selected</cfif> >#description#</option>
								</cfloop>
								</select>
						</td>	
						
						<td width="5%" align="center" class="labelit">
							<cfif qFlow.Distance gte 100000>
								<img style="cursor:pointer" src="#client.root#/images/warning.gif" alt="It is located far away" border="0">	
							</cfif>	
						</td>
						<cfif qFlow.Branch eq "1">
						
							<td colspan="3" bgcolor="e5e5e5" style="padding-left:5px" class="labelmedium">
							
							<b>#qFlow.OrgUnitName# </b>
								<cfquery name="qChildren"
									datasource="AppsTransaction" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT COUNT(1) as Total
								     FROM stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
									 WHERE Date = #dts#
									 AND Branch = 0
									 AND OrgUnitOwner = '#qFlow.OrgUnitOwner#'
								</cfquery>				
								(#qChildren.Total#)
								
							</td>
							
						<cfelse>
						
						    <td colspan="3">
								<table width="100%">
									<tr>
									    <td width="40%" style="padding-left:10px;height:15px" class="labelit">#qFlow.CustomerName#</td>
										<td width="30%" class="labelit" align="left" style="padding-left:10px;padding-right:5px">
											#qFlow.OrgUnitName#
										</td>																
									</tr>
									<tr>    
										<td class="labelit" style="padding-left:20px;padding-right:5px;">
											<cfquery name="qCity"
												datasource="AppsWorkOrder" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													  SELECT City
													  FROM WorkOrderLine WL INNER JOIN WorkOrder W ON W.WorkOrderId = WL.WorkOrderId
													  				INNER JOIN Customer C ON W.CustomerId = C.CustomerId
													  where WL.WorkOrderLineId ='#qFlow.WorkOrderLineId#'
											</cfquery>											
											#qCity.City#
										</td>
										<td class="labelit" align="left" style="padding-left:10px">
											#qFlow.ZipCode#	
										</td>	
									</tr>
									
									<cfquery name="qDetails"
										datasource="AppsWorkOrder" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											  SELECT TopicValue 
											  FROM WorkOrderLine WL INNER JOIN WorkOrderLineTopic WLT
											  ON WL.WorkOrderId = WLT.WorkOrderId AND WL.WorkOrderLine=WLT.WorkOrderLine
											  where WL.WorkOrderLineId ='#qFlow.WorkOrderLineId#'
											  AND Topic in ('f007')											
									</cfquery>
									<!--- I removed also 'f008' ---->
									<!----
									<tr>
									<td class="labelit" colspan="2" style="padding-left:20px;padding-right:5px;">
										<cfloop query="qDetails">											
											<!--- #qDetails.TopicValue# ---->
										</cfloop>
									</td>
									</tr>
									---->	
								</table>						    	
						    </td>	
						    
						</cfif>									
							
					</tr>	
									
					<cfif qFlow.ActionStatus neq 9>
						<cfset vDistance = vDistance + qFlow.Distance>
						<cfset vDuration = vDuration + qFlow.Duration>		
					</cfif>	
										
				</cfloop>							
							
				</table>
				
				</cf_divscroll>
				
				</td></tr>			
				
				</cfoutput>	
				
				<tr><td height="3"></td></tr>
				
			</table>	
		
		</cf_divscroll>				
		</td>	
	
</tr>	

</table>




