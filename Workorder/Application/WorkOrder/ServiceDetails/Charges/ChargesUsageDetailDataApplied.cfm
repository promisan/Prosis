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
<cfparam name="url.year"            default="2011">
<cfparam name="url.month"           default="5">
<cfparam name="url.day"             default="0">
<cfparam name="url.content"         default="">
<cfparam name="url.mode"            default="">

<cfparam name="url.action"          default="">
<cfparam name="url.scope"           default="data">
<cfparam name="url.CallDirection"   default="Incoming">

<cfparam name="form.transactionlistcontent"   default="">

<!--- ------------------------------------------------------------------- --->
<!--- if is update mode and an db action is needed because of a check box --->
<!--- ------------------------------------------------------------------- --->
	
	<cfquery name="WorkOrder"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
	   SELECT  W.*,
		       C.CustomerName, 
			   R.Description,
			   UsageActionClose,
			   R.UsageTopicGroup
	   FROM    Workorder W, Customer C, ServiceItem R
	   WHERE   W.Customerid = C.CustomerId
	   AND     W.ServiceItem = R.Code
	   AND     W.WorkOrderId = '#url.workorderid#'	       
	</cfquery>	
			
	<!--- startdate --->
	
	<cfquery name="PortalStart"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
	   	SELECT 	ISNULL(DatePortalProcessing,convert(datetime,'01/01/2000',101)) as StartDate
	   	FROM 	ServiceItemMission
       	WHERE   Mission     =  '#workorder.mission#'
	   	AND  	ServiceItem = '#workorder.serviceitem#'
	 </cfquery>  
	
	<!--- retrieve the prior closing --->
		
	<cfquery name="PriorClosing"
	     datasource="AppsWorkOrder"
	     username="#SESSION.login#"
	     password="#SESSION.dbpw#">
		  	SELECT TOP 1 * 
			FROM   WorkOrderLineAction 			
			WHERE  WorkOrderId     = '#url.WorkOrderId#'
			AND    WorkOrderLine   = '#url.WorkOrderLine#'	
			AND    ActionClass     = '#workorder.UsageActionClose#'	
			AND	   ActionStatus <> '9'
			ORDER BY Created DESC			
	</cfquery>	
	
	<cfif PriorClosing.serialNo eq "">
	   <cfset ser = 0>
	<cfelse>
	   <cfset ser = PriorClosing.SerialNo>
	</cfif>
		
	<cfquery name="hasPlannedUnits"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#"> 						  
		  SELECT  DISTINCT U.Unit		
		  FROM    WorkOrderLineBillingDetail BD INNER JOIN
	              WorkOrderLineBilling B ON BD.WorkOrderId = B.WorkOrderId AND BD.WorkOrderLine = B.WorkOrderLine AND 
	              BD.BillingEffective = B.BillingEffective INNER JOIN
	              WorkOrderLine L ON B.WorkOrderId = L.WorkOrderId AND B.WorkOrderLine = L.WorkOrderLine INNER JOIN		  
				  ServiceItemUnit U ON BD.ServiceItem = U.ServiceItem AND BD.ServiceItemUnit = U.Unit					  		   
		  WHERE   L.WorkOrderId   = '#url.workorderid#'	 
	      AND     L.WorkOrderLine = '#url.workorderline#'			    
		  UNION	 
		  SELECT  DISTINCT U.Unit
		  FROM    ServiceItemUnit U, Ref_UnitClass R
		  WHERE   U.ServiceItem = '#workorder.serviceitem#' 
		  AND     R.Code = U.UnitClass
		  AND     R.isPlanned = 1  <!--- even if provisionin = 0, it is considered as planned --->	   						  	  
	</cfquery>	
	
	<!--- get a lits of all items to be shown under planned --->
	<cfset plannedunits = quotedvaluelist(hasPlannedUnits.unit)>
	
	<cfparam name="url.ServiceItem"  default="#workorder.serviceitem#">
					
	<cfif url.day gte "1">
		<cfset str = CreateDate(year,month,day)>
		<cfset end = CreateDate(year,month,day)>	
	<cfelse>
		<cfset str = CreateDate(year, month, "1")>
		<cfset end = CreateDate(year,month,daysinmonth(str))>	
	</cfif>	
	<cfset end = DateAdd("d","1", end)>
	
	<!--- perform the threshold validation if this is defined --->
		
	<cfquery name="getThreshold"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		    SELECT TOP 1 *
			FROM   WorkOrderThreshold
			WHERE  WorkOrderId      = '#url.workorderid#'	 
			AND    WorkOrderLine    = '#url.workorderline#'
			AND    DateEffective  <= #str#
			ORDER BY DateEffective DESC		
	</cfquery>	
	
	<cfif getThreshold.recordcount eq "0">
	
		<cfquery name="getThreshold"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		    SELECT   TOP 1 *
			FROM     WorkOrderThreshold
			WHERE    WorkOrderId      = '#url.workorderid#'	 
			AND      WorkOrderLine    = '0'			
			AND      DateEffective   <= #str#
			ORDER BY DateEffective DESC		
	    </cfquery>		
		
	</cfif>
	
	<cfset threshold = getThreshold.Threshold>
	
	<cfif threshold eq "0">
	     <cfset threshold = "">
	</cfif>
	
	<cfset threshold = "10">
		
	<!--- ---------------------- --->
	<!--- get the summary totals --->
	<!--- ---------------------- --->
	
	<!--- initially populate charge records in case these were not loaded yet --->
		
	<cftry>
	
		<cfquery name="InitBusiness"
			   datasource="AppsWorkOrder"
			   username="#SESSION.login#"
			   password="#SESSION.dbpw#">
		       INSERT INTO WorkOrderLineDetailCharge
			             (TransactionId, 
						  WorkOrderId, 
						  WorkOrderLine, 
						  ServiceItem, 
						  ServiceItemUnit, 
						  Reference, 
						  TransactionDate, 
						  Charged, 
						  OfficerUserId, 
						  OfficerLastName, 
			              OfficerFirstName)
	           SELECT     D.TransactionId, 
			              D.WorkOrderId, 
						  D.WorkOrderLine, 
						  D.ServiceItem, 
						  D.ServiceItemUnit, 
						  D.Reference, 
						  D.TransactionDate, 
						  '1', 
	                      '#SESSION.acc#', 
						  '#SESSION.last#', 
						  '#SESSION.first#'
	           FROM       WorkOrderLineDetail AS D LEFT OUTER JOIN
	                      WorkOrderLineDetailCharge AS C ON D.WorkOrderId = C.WorkOrderId AND D.WorkOrderLine = C.WorkOrderLine AND 
	                      D.ServiceItem = C.ServiceItem AND D.ServiceItemUnit = C.ServiceItemUnit AND D.Reference = C.Reference AND 
	                      D.TransactionDate = C.TransactionDate
	           WHERE      D.WorkOrderId   = '#url.workorderid#'			   
			   AND	      D.WorkOrderLine = '#url.workorderline#'	
			   AND        D.TransactionDate >= #str#
			   AND        D.TransactionDate <= #end#		
			   <!--- added hanno 13/11/2017 --->
			   AND        D.ActionStatus != '9'
	           GROUP BY   D.TransactionId, 
			              D.WorkOrderId, 
						  D.WorkOrderLine, 
						  D.ServiceItem, 
						  D.ServiceItemUnit, 
						  D.Reference, 
						  D.TransactionDate, 
	                      C.Charged
	           HAVING     C.Charged IS NULL
		</cfquery>		
	
		<cfcatch></cfcatch>	
	
	</cftry>		
	
				
	<cfquery name="UsageAll"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">   
	
		   SELECT  DATEADD(dd ,DATEDIFF(dd, 0, D.Transactiondate), 0) AS TransactionDate,
		           D.ServiceUsageSerialNo,
				   C.Charged,
				   sum(D.Amount) as Amount
				   
		   FROM    WorkOrderLineDetail AS D 
		   		   INNER JOIN ServiceItemUnit U 
				                 ON U.ServiceItem = D.Serviceitem AND U.Unit = D.ServiceItemUnit			   
				   INNER JOIN WorkOrderLineDetailCharge AS C 
				                 ON  D.WorkOrderId     = C.WorkOrderId 
								 AND D.WorkOrderLine   = C.WorkOrderLine 
								 AND D.ServiceItem     = C.ServiceItem 
								 AND D.ServiceItemUnit = C.ServiceItemUnit 
								 AND D.Reference       = C.Reference 
								 AND D.TransactionDate = C.TransactionDate

		   WHERE   D.WorkOrderId   = '#url.workorderid#'			   
		   AND	   D.WorkOrderLine = '#url.workorderline#'
		   AND     D.ActionStatus != '9'
		   
		   <!--- select records that are of active and  NOT closed yet --->	
		   
		  <cfif url.scope eq "portal">		
		  
		     AND	    D.TransactionDate >= (
		   			
						SELECT 	ISNULL(DatePortalProcessing,convert(datetime,'01/01/2000',101)) 
						FROM 	ServiceItemMission
						WHERE   Mission     = '#workorder.mission#'
						AND  	ServiceItem = '#url.serviceitem#')	 
								   
		   </cfif>	   		   
		  		   
		   <!--- filter on the reference, keep in mind referece = '' has a meaning --->
			   
		    <!--- --------------------------------------------------- --->
		   <!--- special code to be reviewed as it is more for calls --->	
		   <!--- --------------------------------------------------- --->
				   		   
		   <cfif url.reference neq "" and url.reference neq "undefined">		
		   					
				AND     D.Reference      = '#url.reference#'		
								
		   <cfelseif url.calldirection neq "">
															
			  	AND EXISTS (
							SELECT *
							FROM   WorkorderLineDetailTopic T
							WHERE  D.TransactionId = T.TransactionId							
							AND    Topic      = '#workorder.UsageTopicGroup#'
							AND    TopicValue = '#url.Calldirection#')	
							
									
		   </cfif> 		   
		   		
								  				 				  	  
		   <cfif url.mode eq "planned">	  
				  
			   		AND	  (
					       U.Unit IN (#preservesinglequotes(plannedunits)#)  AND (D.Amount > U.ThresholdProvision OR D.Reference = '')	
						  )					
							
		   <cfelseif url.mode eq "unplanned">	
				   
			        AND	(
						    U.Unit NOT IN (#preservesinglequotes(plannedunits)#)	
						    OR D.Amount <= U.ThresholdProvision	
						)	
									
		   </cfif>
		   
			GROUP BY DATEADD(dd ,DATEDIFF(dd, 0, D.Transactiondate), 0),
		           		D.ServiceUsageSerialNo,
				   		C.Charged		   
	</cfquery>	

	
	
	<cfquery name="GetLastSerialNo"
		datasource="AppsWorkOrder"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">   
		SELECT   ISNULL(MAX(SerialNo),0) as SerialNo
		FROM     WorkOrderLineAction A INNER JOIN WorkOrder W ON W.WorkOrderId = A.WorkOrderId
		WHERE    A.WorkorderId   = '#url.workorderid#'
		AND      A.WorkOrderLine = '#url.workorderline#'
		AND      A.ActionClass   = (SELECT UsageActionClose
		                            FROM   ServiceItem S 
									WHERE  S.Code = W.ServiceItem)
		AND	     A.ActionStatus <> '9'		   
	</cfquery>		
		
	<cfloop index="itm" list="periodTotal,periodPersonal,listTotal,listPersonal">
		
		<cfquery name="Usage#itm#" dbtype="query">   
		
			SELECT  SUM(Amount) AS Amount 
			FROM    UsageAll
			WHERE   1=1
			<cfif itm eq "listPersonal" or itm eq "listTotal">
		   	AND     TransactionDate >= #str# AND TransactionDate < #end#
		   	</cfif>			
			<cfif itm eq "periodPersonal" or itm eq "periodTotal">	   		     
			AND     ServiceUsageSerialNo > #ser#
			</cfif>
		    <cfif itm eq "listPersonal" OR itm eq "periodPersonal">
		   	AND    Charged = '2'		   
		    <cfelseif itm eq "listTotal">
		    AND    Charged != '0'
					   
		    </cfif> 
		    <cfif itm neq "listTotal" and itm neq "listPersonal" and itm neq "listOfficial">
		   	AND      ServiceUsageSerialNo > #GetLastSerialNo.SerialNo#								  
			</cfif>		
												  			
		</cfquery>	
		
	</cfloop>
	
	
	<cfif UsagePeriodTotal.amount eq "">
		<cfset OverallUsage     = "0">
	<cfelse>
		<cfset OverallUsage     = UsagePeriodTotal.amount>
	</cfif>

	<cfif UsagePeriodPersonal.amount eq "">
		<cfset OverallPersonal  = "0">
	<cfelse>
		<cfset OverallPersonal  = UsagePeriodPersonal.amount>	
	</cfif>
	
	<cfset OverallOfficial  = OverallUsage-OverallPersonal>	

	<cfif UsageListTotal.amount eq "">
		<cfset listTotal  = "0">
	<cfelse>
		<cfset listTotal        = UsageListTotal.amount>	
	</cfif>
	
	<cfif UsageListPersonal.amount eq "">
		<cfset listPersonal  = "0">
	<cfelse>
		<cfset listPersonal     = UsageListPersonal.Amount>
	</cfif>		
	
	<cfset listOfficial     = listTotal-ListPersonal>
		
	<cfquery name="getUsageLabel"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#"> 						  
		  SELECT   TOP 1 ISNULL(LabelCurrency,'$') as LabelCurrency				
		  FROM     ServiceItemUnit L INNER JOIN
				   Ref_UnitClass C ON L.UnitClass = C.Code	 	  	  
		  WHERE    ServiceItem = '#url.ServiceItem#'			
	</cfquery>		
	
<cfoutput>


<table height="100%" width="310" align="right" cellpadding="0" cellspacing="0">

   <!--- top box with all usage since last closing --->
  	
<tr>
	<td colspan="2" style="padding-top:3px; padding-bottom:3px">
	
		<!---
		<cf_tableround totalwidth="100%" totalheight="70" mode="solidborder" color="c4e1ff" align="right">
		--->
		<!---
		<table cellpadding="0" cellspacing="0" width="100%" border="0">		
				
		    <tr>
			   <cfif priorclosing.recordcount gte "1" and (priorclosing.DateTimePlanning gt PortalStart.StartDate)>
			   <td class="labelit" height="20" style="border-bottom:1px dotted silver;padding-left:3px"><font color="gray">Charges since last approval <!---#dateformat(priorclosing.datetimeplanning,'DD/MM')#--->:</b></font></td>
			   <cfelse>
			   <td class="labelit" height="20" style="border-bottom:1px dotted silver;padding-left:3px"><font color="black">#url.calldirection#<cfif url.reference neq "undefined" and url.reference neq "">:#url.reference#</cfif> since #dateformat(PortalStart.StartDate,'MM/YYYY')#:</b></font></td>
			   </cfif>				 
			   <td class="labelit" align="right" style="border-bottom:1px dotted silver;padding-right:2px">#getUsageLabel.LabelCurrency# #numberformat(OverallUsage,"__,__.__")#</b></td>
			</tr>
							
			<tr>
			   
			    <td class="labelit" style="padding-left:15px">Marked as Business:</td>
							   		  			
				<!---<cfif OverallOfficial gt getThreshold.threshold AND
				      getThreshold.threshold neq "" AND
					  getThreshold.Charged eq "1">--->
					  
				<cfif listOfficial gt getThreshold.threshold AND
				      getThreshold.threshold neq "" AND
					  getThreshold.Charged eq "1">
					 
				  <td class="labelit" bgcolor="red" style="padding-left:4px;border:1px solid black;padding-right:2px; cursor:pointer" align="right" onclick="javascript:alert('Your threshold for this month exceeded, only $#getThreshold.threshold# are allowed. Check with your EO for more information.');">			   
				  <cf_UIToolTip  tooltip="Threshold for this month exceeded, only $#getThreshold.threshold# are allowed.">
				  <img src="#SESSION.root#/Images/warning.gif" border="0">		  
				  <font size="3" color="FFFFFF">#getUsageLabel.LabelCurrency# #numberformat(OverallOfficial,"__,__.__")#
				  </cf_UIToolTip>
				  </font>
				  </td>		
				  
				<!---<cfelseif OverallOfficial lte getThreshold.threshold AND
				      getThreshold.threshold neq "" AND
					  getThreshold.Charged eq "1"> --->
					  
				<cfelseif listOfficial lte getThreshold.threshold AND
				      getThreshold.threshold neq "" AND
					  getThreshold.Charged eq "1"> 						  
					  
					   <td class="labelit" bgcolor="008040" style="padding-left:4px;border:1px solid black;padding-right:2px; cursor:pointer" align="right" onclick="javascript:alert('Your Personal usage for this month is still within the $#getThreshold.threshold# threshold established by your EO.');">		
					   	  <img src="#SESSION.root#/Images/check_icon.gif" border="0" align="absmiddle">		 
						  <font color="white">#getUsageLabel.LabelCurrency# #numberformat(OverallOfficial,"__,__.__")#</font>
					  </td>		 
				  
				<cfelse>
				
				  <td class="labelit" bgcolor="white" align="right" style="padding-right:2px"><font color="gray">#getUsageLabel.LabelCurrency# #numberformat(OverallOfficial,"__,__.__")#</font></td>				
				  
				</cfif>
			
			</tr>
			
			<tr>
			   <td class="labelit" height="18" style="padding-left:15px">Marked as Personal:</td>
			   <td class="labelit" align="right" style="padding-right:2px">#getUsageLabel.LabelCurrency# #numberformat(OverallPersonal,"__,__.__")#</b></td>
			</tr>
		</table>
		--->
		<!---
		</cf_tableround>
		--->
		
	</td>
</tr>

<!--- box with all usage as shown --->
			
<tr>
	<td colspan="2" bgcolor="c4e1ff" style="padding:6px">
	
	<cfif url.content eq "">	
		
			<table cellpadding="0" cellspacing="0" border="0" width="96%" align="center">			
						
				<tr>
				   	<td class="labelit" height="18" style="height:35px;padding-left:3px"><b>Total selected below:</b></td>	
					<td class="labelit" align="right"  style="padding-right:2px"><b>#getUsageLabel.LabelCurrency# #numberformat(ListTotal,"__,__.__")#</b></td>
				</tr>		
					
				<!---					
				<cfif ListTotal neq ListOfficial>
				--->
				<tr>		   
				    <td class="labelit" height="18"  style="padding-left:15px">Marked as Business:</td>		   		   
					<td class="labelit" align="right" style="padding-right:2px">#getUsageLabel.LabelCurrency# #numberformat(ListOfficial,"__,__.__")#</td>									
				</tr>
				<!---
				</cfif>
				--->
				<tr><td height="1"></td></tr>							
								
				<tr style="border:1px dotted white">
				   <td class="labelit" bgcolor="white" height="18" style="border-top:dotted silver 1px;padding-left:15px">Marked as Personal:</td>		   
				   <td class="labelit" bgcolor="white" align="right" style="border-top:dotted silver 1px;padding-right:2px"><font size="2" color="black">#getUsageLabel.LabelCurrency# #numberformat(ListPersonal,"__,__.__")#</font></b></td>
				</tr>					
				
			</table>		
		
	</cfif>
	
	</td>
</tr>		

</table>

</cfoutput>
	
		
