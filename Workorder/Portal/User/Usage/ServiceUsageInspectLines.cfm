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
<cfparam name="url.reference" default = "">
<cfparam name="url.mission"   default="O">
<cfparam name="url.content"   default="">

<cfif url.content eq "NonBillable">
    <cfset dbselect = "NonBillable">
<cfelse>
    <cfset dbselect = "">		
</cfif>

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT    * 
		FROM      WorkorderLine 
		WHERE     WorkorderLineId = '#url.workorderlineid#'
</cfquery>

<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT    * 
		FROM      Workorder 
		WHERE     WorkorderId = '#get.workorderid#'
</cfquery>
 
<cfquery name="hasPlannedUnits"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#"> 	
   					  
	  SELECT  DISTINCT U.Unit		
	  FROM    WorkOrderLineBillingDetail BD INNER JOIN
              WorkOrderLineBilling B ON BD.WorkOrderId = B.WorkOrderId AND BD.WorkOrderLine = B.WorkOrderLine AND 
              BD.BillingEffective = B.BillingEffective INNER JOIN
              WorkOrderLine L ON B.WorkOrderId     = L.WorkOrderId AND B.WorkOrderLine = L.WorkOrderLine INNER JOIN		  
			  ServiceItemUnit U ON BD.ServiceItem  = U.ServiceItem AND BD.ServiceItemUnit = U.Unit					  		   
	  WHERE   L.WorkOrderId   = '#get.workorderid#'	 
      AND     L.WorkOrderLine = '#get.workorderline#'
	  	
	  UNION
	  
	  SELECT  DISTINCT U.Unit
	  FROM    ServiceItemUnit U, Ref_UnitClass R
	  WHERE   U.ServiceItem = '#workorder.serviceitem#'
	  AND     R.Code        = U.UnitClass
	  AND     R.isPlanned   = 1  <!--- even if provisionin = 0, it is considered as planned --->		
	     						  	  
</cfquery>	

<!--- get a lits of all items to be shown under planned --->
<cfset plannedunits = quotedvaluelist(hasPlannedUnits.unit)>

<cfif client.selectedmonth neq "" and client.selectedmonth neq "0">

	<cfquery name="Check" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT TOP 1 TransactionDate
		FROM       WorkOrderLineDetail#dbselect# D INNER JOIN 
		           ServiceItemUnit U ON D.ServiceItem = U.ServiceItem and D.ServiceItemUnit = U.Unit
		WHERE      WorkOrderId            = '#get.workorderid#'
		AND        WorkOrderLine          = '#get.workorderline#' 
		AND        Year(TransactionDate)  = '#url.year#'		
		AND        Month(TransactionDate) = '#client.selectedmonth#'	
		<cfif dbselect eq "">
		AND		   D.ActionStatus != '9'
		</cfif>		
	</cfquery>
		
<cfelse>

	<cfset url.month = month(now())>

</cfif> 

<cfquery name="getGroup" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT UsageTopicGroup, UsageTopicDetail 
	FROM   ServiceItem 
	WHERE  Code = '#workorder.serviceitem#'
</cfquery>

<!--- get transactions by header --->

<cfquery name="List" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT    D.TransactionId,
	
	          D.Reference,
			  <!---
	          CASE 
	
				WHEN	(SELECT TopicValue 
						 FROM   WorkOrderLineDetailTopic#dbselect# 
						 WHERE  TransactionId = D.TransactionId 							
						 AND    Topic = '#getGroup.UsageTopicGroup#' <!--- 'T034' --->
							) = 'Incoming' THEN 'Incoming'
				WHEN D.Reference = '0' THEN ''
				ELSE D.Reference
				END AS Reference,
				
				--->
							   
			  CASE 
			  
				WHEN	(SELECT TopicValue 
						 FROM   WorkOrderLineDetailTopic#dbselect#
						 WHERE  TransactionId = D.TransactionId 							
						 AND    Topic = '#getGroup.UsageTopicGroup#' <!--- 'T034' --->
							) = 'Incoming' THEN	'Incoming'
				ELSE D.Reference
				END +'['+LTRIM(STR(DAY(TransactionDate)))+']' AS TransactionDay,
				
			   (SELECT TopicValue 
				   FROM   WorkOrderLineDetailTopic#dbselect#
				   WHERE  TransactionId = D.TransactionId 				  
				   AND    Topic = '#getGroup.UsageTopicDetail#' <!--- 'T031' ---> 
				   ) as Destination,
				   
			   <!--- grouping --->	   
		    
			   (SELECT TopicValue 
				   FROM   WorkOrderLineDetailTopic#dbselect#
				   WHERE  TransactionId = D.TransactionId 				  
				   AND    Topic = '#getGroup.UsageTopicGroup#' <!--- 'T034' ---> 
				   ) as TopicGroup,
				
				 (SELECT CONVERT(varchar,TopicValue) 
				   FROM   WorkOrderLineDetailTopic#dbselect#
				   WHERE  TransactionId = D.TransactionId 				  
				   AND    Topic = '#getGroup.UsageTopicGroup#' <!--- 'T034' ---> 
				   ) +'['+LTRIM(STR(DAY(TransactionDate)))+']' as TopicGroupDay,
								   
			   L.Reference as LineReference,				
			   DU.ReferenceAlias

	FROM       WorkOrderLineDetail#dbselect# D INNER JOIN 
	           ServiceItemUnit U ON D.ServiceItem = U.ServiceItem and D.ServiceItemUnit = U.Unit INNER JOIN
			   WorkOrderLine L ON D.WorkOrderId = L.WorkOrderId AND D.WorkOrderLine = L.WorkOrderLine INNER JOIN
			   WorkOrder W ON W.WorkOrderId = L.WorkOrderId INNER JOIN
			   ServiceItemLoad IL ON IL.Mission = W.Mission AND IL.ServiceItem = D.ServiceItem AND IL.ServiceUsageSerialNo = D.ServiceUsageSerialNo

			   LEFT OUTER JOIN WorkOrderLineDetailUser DU ON D.WorkOrderId = DU.WorkOrderId AND D.WorkOrderLine = DU.WorkOrderLine AND D.Reference = DU.Reference
	WHERE      D.WorkOrderId            = '#get.workorderid#'
	AND        D.WorkOrderLine          = '#get.workorderline#' 
	AND        Year(D.TransactionDate)  = '#url.year#'
	AND        Month(D.TransactionDate) = '#url.month#'		
	AND	  	   IL.ActionStatus = '1'	
	
		
	<cfif dbselect eq "">
	AND        D.ActionStatus != '9'
	</cfif>
	
	<cfif url.day neq "">	
	AND        Day(D.TransactionDate) = '#url.day#'
	</cfif>
	
	<!--- made generic to show only unplanned costs : this has been disabled on Sunday 19/6 
	as we also want to be able to revise planned/provisioned costs
	AND		   U.Unit NOT IN (#preservesinglequotes(plannedunits)#)		
	--->
		       
	<cfif url.reference neq "">
			
	AND       (
	          D.Reference LIKE ('%#url.reference#%')	
			  OR
			  D.Reference IN (
			                  SELECT Reference 
			                  FROM   WorkOrderLineDetailUser
							  WHERE  WorkOrderId   = D.WorkOrderId
							  AND    WorkOrderLine = D.WorkOrderLine
							  AND    Reference     = D.Reference
							  AND    ReferenceAlias LIKE ('%#url.reference#%')	
							  )   
	          )
	
	</cfif>	
	
	ORDER BY CASE 
	
		WHEN (SELECT TopicValue FROM WorkOrderLineDetailTopicNonBillable WHERE TransactionId = D.TransactionId 
			<!---AND Topic='T034'--->
			AND Topic = (SELECT UsageTopicGroup 
			             FROM   ServiceItem 
						 WHERE  Code = '#workorder.serviceitem#')) = 'Incoming' THEN ' Incoming' 
		WHEN D.Reference = '0' THEN '' 
		ELSE D.Reference 
		END , TransactionDay
		
		
</cfquery>

<!--- check or initialization --->

<cfif list.recordcount eq "0">

	<cfif client.selectedmonth neq "" and client.selectedmonth neq "0">
		<cfset tmonth = client.selectedmonth>
	<cfelse>
		<cfset tmonth = url.month>
	</cfif>		
	
	<cfset tdate = createdate(url.year,tmonth,1)>
	<cfset expline = "0">

	<!--- if effective date of current line gt Date searched, check if there is an expired record for the date searched--->
	<cfif get.DateEffective gt tdate>
		<cfquery name="Expiration" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT *
			FROM	ServiceItemMission  
			WHERE   Mission		= '#WorkOrder.Mission#'
			AND     ServiceItem = '#WorkOrder.ServiceItem#' 		
		</cfquery>
						
		<cfif tdate lt dateadd("d",Expiration.SettingDaysExpiration,now()) >	
		
			<cfquery name="ExpiredLines" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT COUNT(*)
				FROM	vwWorkOrderLine
				WHERE  	ServiceItem		= '#WorkOrder.ServiceItem#'
				AND     PersonNo      	= '#get.PersonNo#' 
				AND		Reference			= '#get.reference#'
				AND		WorkOrderLineId	<> '#url.workorderlineid#'
				AND     Operational		= 1
				AND		DateExpiration	< (getdate() - #Expiration.SettingDaysExpiration#)			
			</cfquery>
			
			<cfif ExpiredLines.recordcount neq "0">
				<cfset expline = "1">	
			</cfif>
		</cfif>
	</cfif>
		
	<table align="center">
		
		<tr><td align="center" class="labelit">
		<font size="2" color="0080C0">
		<cfif expline eq "0">
			No records found to show in this view.
		<cfelse>
			Previous usage associated to this device can no longer be shown as it belongs to an expired period. <br><br> Please contact your administrator 
		</cfif>
		
		<script>
		    Prosis.busy('no')
		    try {
			document.getElementById('filterme').className = "hide" } catch(e) {}
		</script>
		</td></tr>
		
		<!--- make sure the body is empty --->
		<script language="JavaScript">	     
			 ColdFusion.navigate('ServiceLayoutBody.cfm?workorderlineid=','body');					
		</script>	
			
	</table>		
 
<cfelse>

	<script>
	      try {
			document.getElementById('filterme').className = "regular" } catch(e) {}
		</script>

    <!-- get all the values for a reference in a string --->
	<cfset dl = ValueList(List.TransactionDay)>
	<!--- triming more --->	
	<cfset dl = replaceNoCase(dl," ","","ALL")> 
	
	<!-- get all the values for a reference in a string --->
	<cfset dd = ValueList(List.TopicGroupDay)>
	<!--- triming more --->	
	<cfset dd = replaceNoCase(dd," ","","ALL")> 
	
	<cfset dt = CreateDateTime("#url.year#","#url.month#","01","0","0","0")> 
			
	<cftry>
		<cfset dt = CreateDateTime("#url.year#","#url.month#","01","0","0","0")> 
		<cfset days = daysinMonth(dt)>
		<cfcatch>		
			<cfset days = "30">
		</cfcatch>	
	</cftry>		
	
		<cf_divscroll style="height:100%">
	
		<table width="100%" style="padding-left:10px;padding-right:10px;padding-bottom:10px" cellpadding="0" cellspacing="0" class="navigation_table">					
				
								
			<cfif getGroup.UsageTopicGroup neq "">
				
				<tr><td colspan="2" class="line"></td></tr>	
						
				<!--- get transactions directions --->
				
				<cfquery name="getDirection" dbtype="query">
					SELECT   *
					FROM     List		
					WHERE    TopicGroup is not NULL	AND TopicGroup != ''				
					ORDER BY TopicGroup			
				</cfquery>		
				
				<cfset vSelDirection ="">
				
				<cfoutput query="getDirection" group="TopicGroup">
						
				<tr bgcolor="ffffdf" class="navigation_row">
						
						<!--- option to set alias and personal --->
									
						<td colspan="2" style="padding-left:4px;cursor:pointer"> 	
						
							<table cellspacing="0" cellpadding="0" width="100%" align="center">
								
							<!--- summary --->
																	
							<tr class="navigation_action" onclick="showusageDetail('#url.content#','#workorderlineid#','#url.year#','#url.month#','#url.day#','','#TopicGroup#')">														
								<td height="20" class="labelmedium">#TopicGroup#</td>		
								
								<cfquery name="getSummary" dbtype="query">
									SELECT    COUNT(*) AS Total
									FROM      getDirection			
									WHERE     TopicGroup = '#TopicGroup#'			
								</cfquery>	
								
								<td align="right" style="padding-right:3px"  class="labelmedium">#getSummary.Total#</td>																
							</tr>	
							
							<!--- dates --->
												
							<tr>
										
								<td height="5" colspan="3" style="padding:1px">
								
									<table width="97%" 
									       height="100%"  
										   align="center" 
										   cellspacing="0" 
										   cellpadding="0">
										   
										<tr>
										
										<cfloop index="d" from="1" to="#days#">	
										
											<cfif reference eq "">									
												<td width="4" height="5" bgcolor="95d3ff" style="border: 1px solid silver"></td>																						
											<cfelseif find("#TopicGroup#[#d#]",dd)>
												<td height="5" width="4" bgcolor="549DEC" style="border: 1px solid silver"></td>																				
											<cfelse>														
												<td height="5" width="4" bgcolor="eaeaea" style="border: 1px solid silver"></td>										
											</cfif>	
										
										</cfloop>	
										
										</tr>
									</table>
									
								</td>
										
							</tr>	
							
							<tr><td height="3"></td></tr>
												
							</table>
						
						</td>
				</tr>
					<cfset vSelDirection = TopicGroup>
				</cfoutput>
					
				<cfoutput>
				<input type="hidden" id="sdirection" name="sdirection" value="#vSelDirection#">		
				</cfoutput>
				
			</cfif>	
					
			<cfif List.recordcount gte "1">
					
					
				<tr  class="line">
				<td></td>
				<td>
					<table cellspacing="0" cellpadding="0" width="96%" align="center">		
										
					<tr class="labelmedium">	
						<td width="50%"><cf_tl id="Number"></b></td>
						<td width="3"></td>
						<td align="right"><cf_tl id="Destination"></td>
					</tr>
					</table>
				</td>
				</tr>	
				
			
			</cfif>	
			
			<!--- we show only on the group/reference level in this view --->
			
			<cfoutput query="List" group="Reference">	
								
			    <cfif Reference neq TopicGroup or Reference eq "">
					
				<!--- some planned costs have the Line reference as the transaction reference (Other Charges)  --->
			
				<cfif Reference neq LineReference>
				
					<tr class="filterrow navigation_row" >
						<!--- option to set alias and personal --->				
						<td width="3" style="padding-left:2px;padding-top:1px"
						  onclick="userpref('#url.workorderlineid#','#reference#','#currentrow#','refcontent_#currentrow#');ColdFusion.navigate('ServiceUsageBody.cfm?content=#url.content#&workorderlineid=#url.workorderlineid#&year=#url.year#&month=#url.month#&reference=#Reference#&Calldirection=#TopicGroup#','body')">
							
							<cfif reference neq "">
							
								<img src="#SESSION.root#/Images/toggle_up.png" alt="" 
										id="det_#currentrow#exp" name="det_#currentrow#exp" border="0" class="regular" 
										align="absmiddle" style="cursor: pointer">
											
								<img src="#SESSION.root#/Images/toggle_down.png" 
										id="det_#currentrow#min" name="det_#currentrow#min" alt="" border="0" 
										align="absmiddle" class="hide" style="cursor: pointer;">
					
							</cfif>
						</td>
									
						<td> 	
							<table cellspacing="0" cellpadding="0" width="97%" align="center">
							
							<tr class="navigation_action labelmedium" onclick="showusageDetail('#url.content#','#url.workorderlineid#','#year#','#month#','#day#','#reference#','#TopicGroup#')">
																					
									<cfif Reference eq "" >
									
									    <td colspan="2" width="100%" height="20" style="padding-right:5px;padding:2px;">	
										<table cellspacing="0" cellpadding="0">
										<tr><td><img src="#SESSION.root#/Images/charges.gif" border="0"></td>
										<td class="labelmedium" style="padding-left:9px">Plan, surcharges, fixed charges</td>
										</tr>
										</table>	
										</td>								
																	
									<cfelse>
									
										<td class="filtercontent" width="50%" height="20" id="set_#currentrow#" style="padding-right:5px;padding:2px;padding-left:2px;">	
										
										<cfif url.reference eq "">
										
											<cfif ReferenceAlias neq "">#ReferenceAlias#<cfelse>#Reference#</cfif>		
										
										<cfelse>	
																									
											<cfif ReferenceAlias neq "">
											    <cfset ref = replaceNoCase(ReferenceAlias,url.reference,"<b><u>#url.reference#</u></b>","ALL")>									
											<cfelse>
											    <cfset ref = replaceNoCase(Reference,url.reference,"<b><u>#url.reference#</u></b>","ALL")>									
											</cfif>																								
											#ref#
											
										</cfif>	
										
										</td>
										<td class="filtercontent" align="right" style="padding-right:2px;">#Destination#
										<div class="hide filtercontent">#topicgroup#</div>	
										</td>
										
									</cfif>
							
								</td>		
														
						</tr>
						
						<!--- --------------------------------------- --->	
						<!--- target to record details for alias etc. --->
						<!--- --------------------------------------- --->
										
						<tr id="ref_#currentrow#" class="hide">			
						     <td colspan="2" width="100%" onmouseover="refreshlines('content=#url.content#&workorderlineid=#url.workorderlineid#&year=#url.year#&month=#url.month#&reference=#Reference#&calldirection=#TopicGroup#');">						 						 
						     <table width="100%" cellspacing="0" cellpadding="0">
							     <tr><td class="filterrow" width="100%">						 		
								 <table width="100%" border="0" cellspacing="0" cellpadding="0">
									 <tr><td id="refcontent_#currentrow#" bgcolor="white"></td></tr>
								 </table>
								 <div class="hide filtercontent">#Reference# #ReferenceAlias# #Destination#</div>
								 </tr>
							 </table>
							 </td>					 
						</tr>					
							
							<cfif reference neq "">
							
							<tr>
							
							<td height="5" colspan="3" style="padding:1px">
							
								<table width="97%" height="100%" align="center"  cellspacing="0" cellpadding="0">
								<tr>
									
									<cfloop index="d" from="1" to="#days#">	
																					
										<cfif find("#Reference#[#d#]",dl)>
										
											<cf_UIToolTip sourcefortooltip="#SESSION.root#/workorder/portal/user/Usage/serviceUsageInspectLinesTooltip.cfm?content=#url.content#&workorderlineid=#url.workorderlineid#&year=#url.year#&month=#url.month#&day=#d#&ref=#Reference#">
												<!---<td height="5px" width="5px" bgcolor="00FF00"></td>--->
												<td height="5px" width="5px" bgcolor="549DEC"></td>
											</cf_UIToolTip>
											
										<cfelse>	
																						
											<td height="5px" width="5px" bgcolor="eaeaea" style="border: 1px solid silver"></td>		
																		
										</cfif>	
									
									</cfloop>	
									
									</tr>
								</table>
								
							</td>
							
							</tr>
							
							</cfif>
							
							</table>
						
						</td>
					</tr>	
						
					
					<tr class="filterrow line navigation_row_child">
					<div class="hide filtercontent">#Reference# #ReferenceAlias# #Destination# #topicgroup#</div>		
					  <td colspan="2" height="1" style="padding-top:2px"></td>
				     </tr>
				
					
				</cfif>	
				
				</cfif>
				
			</cfoutput>
			
		</table>
	
	</cf_divscroll>		
	
	<cfoutput>
		
	<cfif getGroup.UsageTopicGroup neq "">
		
		<!--- make sure the body is empty --->
		
		<script language="JavaScript">
		   
			<!--- populated the main body now based on the selections --->
		    _cf_loadingtexthtml= "<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy10.gif'/>"	     
			ColdFusion.navigate('ServiceUsageBody.cfm?content=#url.content#&workorderlineid=#url.workorderlineid#&year=#url.year#&month=#url.month#&day=#url.day#&CallDirection=#getDirection.TopicGroup#','body')			
			_cf_loadingtexthtml='';
			
		</script>	
		
	</cfif>		
	
	</cfoutput>
		
</cfif>

<script>
	Prosis.busy('no')
</script>

<cfset ajaxOnLoad("doHighlight")>
