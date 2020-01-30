<cfparam name="URL.date" 		default = "06/01/2015">
<cfparam name="URL.starttime" 	default = 7>
<cfparam name="URL.id" 			default = "">
	
<cfset dateValue = "">
<CF_DateConvert Value="#URL.date#">
<cfset DTS = dateValue>		

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

<cfif URL.Id eq "">
	<cfset URL.Step="Final">
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
	         F.ActionStatus,
	         P.Step
	  FROM   stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# F INNER JOIN stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# N
			ON   F.Node = N.Node AND F.Date = N.Date 
		INNER JOIN Organization.dbo.Organization O
			ON   N.OrgUnitOwner = O.OrgUnit
		INNER JOIN stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# P ON P.RouteId = F.RouteId
	  WHERE
	    
	  <cfif URL.step eq "Final">
	  	   F.ActionStatus in ('1','1a')
	  	   AND F.Date         = #dts#
	  	ORDER BY P.Step ASC, F.ListingOrder ASC
	  <cfelse>
	  	   F.RouteId = '#URL.Id#'
	  	   AND F.ActionStatus!='9'
	    ORDER BY F.ListingOrder
	  </cfif>	 
</cfquery>

<cfif URL.step eq "Final">
	<cfquery name="qFlowMax" dbtype="Query">
		SELECT MAX(Step) as Step
		FROM qFlow 
	</cfquery>
	<cfset vCompiled = True>
	
	<cfif qFlowMax.Step neq "">
		<cfset URL.Step = qFlowMax.Step+1>
	<cfelse>	
		<cfset URL.Step = 1>
	</cfif>	
	
<cfelse>
	<cfset vCompiled = False> 
</cfif>	

<cfquery name="qTimeSlot"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#"> 
	SELECT Code,Description,ListingOrder
	FROM Ref_PlanOrder
	ORDER BY ListingOrder
</cfquery>	

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" style="border:1px dotted gray">

<tr style="padding:5px">

	<td style="padding:4px;height:45px" align="center" width="100%">
	
	<cfoutput>
			<cfsavecontent variable="json_input_order">[<cfloop query="qTimeSlot">{"planorder":"#qTimeSlot.Code#","listingorder":"#qTimeSlot.ListingOrder#","description":"#qTimeSlot.Description#"},</cfloop>{}]</cfsavecontent>
			<input type="hidden" name="input_order" id="input_order" value='#json_input_order#'>
			<table width="100%">
			<tr>
			<cfif NOT vCompiled>
				<td align="left"><input type="button" value="Reset all"  class="button10g" style="border:1px solid black;border-radius:10px;height:34px;width:150px;background-color:c00; color:ffffff;" onclick="resetcluster('#url.date#',0)"></td>					
				<td align="right"><input type="button" value="Save and Next"  class="button10g" style="border:1px solid black;border-radius:10px;height:34px;width:150px;background-color:02B656; color:ffffff;" onclick="processcluster('#url.id#','#url.date#','#url.step+1#')"></td>		
			<cfelse>
			    <td><input type="button" value="Confirm" class="button10g" style="height:34px;width:100px" onclick="confirmcluster('#url.date#')"></td>
			</cfif>
			</tr>
			</table>	
		</cfoutput>	
	</td>
	
</tr>	

<tr>	

			<td style="padding:4px;padding-left:0px;height:100%" width="100%">
					
			<table height="100%" width="100%" cellspacing="0" cellpadding="0" align="center" valign="top">
				
				<cfoutput>
				
				<tr class="labelmedium line" id="rlisting">
				
					<td colspan="3" style="padding:4px">
						<table>
							<tr>
							<td width="5%">
								<button type="button" class="button3" style="border:1px solid silver" onclick="javascript:showPending('#URL.Date#','#URL.Id#','#URL.step#')">
									 <img style="cursor:pointer" onclick="" src="#client.root#/images/add.png" alt="" border="0">
								</button>								
							</td>
							<td width="5%">
								<button type="button" class="button3" style="border:1px solid silver" onclick="javascript:deleteNodes('#URL.Date#','#URL.Id#','#URL.step#')">
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
					
					<!---				
					<td><cf_tl id="Customer">/<cf_tl id="Branch"></td>
					<td><cf_tl id="Postal"></td>
					<td align="left">From branch</td>					
					<td align="center">Kms</td>					
					--->
	
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
				
				<table class="navigation_table" height="100%" width="99%" cellspacing="0" cellpadding="0" align="center" id="WorkOrderAssigned" name="WorkOrderAssigned" valign="top">
							
				<cfset vDistance = 0>
				<cfset vDuration = 0>	
				
				<cfloop query="qFlow">
					
					<cfswitch Expression="#qFlow.Step#">
						<cfcase value="1">
							<!--- Light Blue --->
							<cfset current_color = "##B1D6F7">
						</cfcase>	
						<cfcase value="2">
							<!--- Green --->
							<cfset current_color = "##2FB158">
						</cfcase>	
						<cfcase value="3">
							<!--- Red --->
							<cfset current_color = "##F6001C">
						</cfcase>	
						<cfcase value="4">
							<!--- Yellow --->
							<cfset current_color = "##F8E150">
						</cfcase>
						<cfcase value="5">
							<!--- Orange --->
							<cfset current_color = "##F6863A">
						</cfcase>		
						<cfcase value="6">
							<!--- Purple --->
							<cfset current_color = "##CEA7F5">
						</cfcase>												
						<cfcase value="7">
							<!--- Black --->
							<cfset current_color = "##B5B3B7">
						</cfcase>						
						<cfcase value="8">
							<!--- Blue --->
							<cfset current_color = "##0CADD9">
						</cfcase>		
					    <cfdefaultcase>
					       <cfset current_color = "##0CADD9">
					    </cfdefaultcase>																				
					</cfswitch>		
					
					<cfif qFlow.Distance gte 100000>
						<cfset current_color = "##FF6699">
					</cfif>
					
					<tr id="row_#qFlow.Node#" class="line navigation_row">
					
						<td width="8%" align="center" style="height:40px" bgcolor="#current_color#">
						
							<input type="hidden" name="order_#qFlow.Node#" id="order_#qFlow.Node#" value="#qFlow.ListingOrder#" class="sorting_input">
							<input type="hidden" name="branch_#qFlow.Node#" id="branch_#qFlow.Node#" value="#qFlow.branch#">								
								
							<cfif NOT vCompiled>
								<cfif qFlow.ActionStatus neq 9>
									<input type="checkbox" name="assigned_#qFlow.Node#" id="assigned_#qFlow.Node#" value="#qFlow.Node#" class="radiol nassigned" onclick="marknode('#URL.Id#','#qFlow.Node#','#qFlow.Branch#')">
								<cfelse>
									<cfif NOT vCompiled>
										<cf_img icon="open" tooltip="reinstate in planning" onclick="reinstateNode('#URL.Date#','#qFlow.Node#','#URL.Id#','#URL.step#')">
									</cfif>		
								</cfif>
							</cfif>
								<cfquery name="qChildren"
									datasource="AppsTransaction" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT *
								    FROM   stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
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
								     FROM stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
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
									    <td width="40%" style="padding-left:10px;height:15px" class="labelmedium">#qFlow.CustomerName#</td>
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
									<tr>
									<td class="labelit" colspan="2" style="padding-left:20px;padding-right:5px;">
										<cfloop query="qDetails">											
											#qDetails.TopicValue#
										</cfloop>
									</td>
									</tr>	
								</table>						    	
						    </td>	
						    
						</cfif>									
	
						<td valign="top" align="right" style="padding-right:4px" class="labelit" width="10%">#round(qFlow.Distance/1000)#</td>						
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
				
		</td>	
	
</tr>	

</table>

<cfset AjaxOnLoad("block_selection")>


