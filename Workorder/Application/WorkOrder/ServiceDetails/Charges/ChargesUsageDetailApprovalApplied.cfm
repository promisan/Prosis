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
<cfoutput>

<cfparam name="url.ServiceItem"  default="">

	<cfquery name="getUsageLabel"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#"> 						  
		  SELECT   TOP 1 ISNULL(LabelCurrency,'$') as LabelCurrency				
		  FROM     ServiceItemUnit L INNER JOIN
				   Ref_UnitClass C ON L.UnitClass = C.Code	 	  	  
		  WHERE    ServiceItem = '#url.ServiceItem#'			
	</cfquery>		
	
	<cfquery name="ServiceItem"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   ServiceItem 
	   WHERE  Code = '#url.serviceitem#'
	</cfquery>   	
	
	<cfquery name="UsageTotals"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
	   SELECT  	C.Charged,
	   			isnull(SUM(round(Amount,2)),0) AS Amount
	   FROM    WorkOrder W 
	           INNER JOIN WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId 
			   INNER JOIN WorkOrderLineDetail AS D ON D.WorkOrderId = WL.WorkOrderId AND D.WorkOrderLine = WL.WorkOrderLine 
			   INNER JOIN ServiceItemUnit U ON U.ServiceItem = D.Serviceitem AND U.Unit = D.ServiceItemUnit
			   LEFT OUTER JOIN WorkOrderLineDetailCharge AS C 
						ON  D.WorkOrderId     = C.WorkOrderId 
						AND D.WorkOrderLine   = C.WorkOrderLine 
						AND D.ServiceItem     = C.ServiceItem 
						AND D.ServiceItemUnit = C.ServiceItemUnit 
						AND D.Reference       = C.Reference 
						AND D.TransactionDate = C.TransactionDate <!--- AND C.Charged = '2' ---> 	

			   
			   <!--- INNER JOIN ServiceItemLoad IL ON IL.Mission = W.Mission AND IL.ServiceItem = D.ServiceItem AND IL.ServiceUsageSerialNo = D.ServiceUsageSerialNo --->
			   
			   LEFT OUTER JOIN Ref_ServiceItemDomainClass DC ON DC.ServiceDomain = WL.ServiceDomain AND DC.Code = WL.ServiceDomainClass
			   
	   WHERE  WL.WorkOrderId IN (SELECT WorkorderId 
	                             FROM   WorkOrder 
								 WHERE  WorkorderId = WL.Workorderid 
								 AND    ServiceItem = '#url.serviceitem#')		
								 	   
	   AND	  WL.PersonNo = '#client.personno#'		
   	   AND	  WL.Operational = 1 		   
	   <!--- is to be charged --->  
	   AND    D.ActionStatus != '9'
	   AND    D.Charged      <> '0' 
	   <!--- AND	  IL.ActionStatus = '1'		 --->  		  
	   
	   <!--- 29/06  JDiaz. Added to filter based on the portal processing date for the service --->
	   AND		D.TransactionDate >= (
	   				SELECT 	ISNULL(DatePortalProcessing,convert(datetime,'01/01/2000',101)) 
					FROM 	ServiceItemMission
					WHERE   Mission     = W.Mission
					AND  	ServiceItem = '#url.serviceitem#')	   					
	  
	   <!--- 2014-03-12 Added to filter transactions from closed periods (prior to DatePostingCalculate) --->
	   AND		D.TransactionDate >= (
	   				SELECT 	ISNULL(DatePostingCalculate,convert(datetime,'01/01/1900',101)) 
					FROM 	ServiceItemMission
					WHERE   Mission     = W.Mission
					AND  	ServiceItem = '#url.serviceitem#')	
	    		    
	   AND      D.ServiceUsageSerialNo > (
	                                      SELECT ISNULL(MAX(SerialNo),0)
	                                      FROM   WorkOrderLineAction
										  WHERE  WorkorderId   = WL.WorkOrderId
										  AND    WorkOrderLine = WL.WorkOrderLine
										  AND    ActionClass   = '#Serviceitem.UsageActionClose#'
										  AND	 ActionStatus <> '9'
										  )
		
			
		AND D.ServiceUsageSerialNo NOT IN (
			SELECT L1.ServiceUsageSerialNo
			FROM ServiceItemLoad L1
			WHERE L1.Mission = W.Mission
			AND L1.ServiceItem = D.ServiceItem
			AND L1.ActionStatus = '0'
		)
										  
		AND ((DC.ChargeTagging IS NULL ) OR (DC.ChargeTagging ='1')) 	<!--- 2013-01-22 Disable Custodian devices for approval --->						  
		
												   	   
	   GROUP BY C.Charged

	   <!----Provision to guarantee  0 amount in the query of queries below --->
	   UNION 
	   SELECT '1' AS Charged, 0 as Amount
	   UNION
	   SELECT '2' AS Charged, 0 as Amount
	</cfquery>	
		
	<cfloop index="itm" list="Personal,Total">
	
		<cfquery name="Usage#itm#" dbtype="query">
			
			SELECT SUM(amount) as Amount
			FROM   UsageTotals
			WHERE  1=1
	  		<!--- :: transactions associated to a load which lies after the last closing and are not closed yet 
	  			in principle C.ActionStatus is updated to 1 which should also reflect inro the workorderline detail --->	 
	   		<cfif itm eq "Personal"> 
		   		AND    Charged      = '2'  			   
	   		</cfif>		
			
		</cfquery>
				
	</cfloop>

	
	<!--- --------------------------------------------------------------------- --->
	<!--- determine how much is to be posted at this moment based on the totals --->
	<!--- --------------------------------------------------------------------- --->
	
	<!--- 
	    total ready for posting 
	    -/- total posted 
	    = total pending for posting		   
	--->   
	
	<!--- get conformed charges --->

	<cfquery name="OfficialByMonth"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">

	   SELECT  	DISTINCT WL.WorkOrderid,
	   			WL.WorkOrderLine,
				WL.Reference,
				Year(D.TransactionDate) as YearTransaction,
				Month(D.TransactionDate) as MonthTransaction
	   FROM     WorkOrderLine WL INNER JOIN WorkOrderLineDetail AS D 
	                    ON  D.WorkOrderId = WL.WorkOrderId AND D.WorkOrderLine = WL.WorkOrderLine 
						        LEFT OUTER JOIN WorkOrderLineDetailCharge AS C 
						ON  D.WorkOrderId = C.WorkOrderId 
						AND D.WorkOrderLine = C.WorkOrderLine 
						AND D.ServiceItem = C.ServiceItem 
						AND D.ServiceItemUnit = C.ServiceItemUnit 
						AND D.Reference = C.Reference 
						AND D.TransactionDate = C.TransactionDate
					INNER JOIN WorkOrder WO ON WO.WorkOrderId = WL.WorkOrderId
			   
	   WHERE    WL.WorkOrderId IN (SELECT WorkorderId 
	                              FROM   WorkOrder 
								  WHERE  WorkorderId  = WL.Workorderid 
								  AND    ServiceItem  = '#url.serviceitem#')			   
								  
	   AND	    WL.PersonNo = '#client.personno#'		  	  
	   AND	    WL.Operational = 1		   
	   <!--- Business transactions --->
	   AND      C.Charged      = '1'  	
	   AND      D.ActionStatus != '9'
	 	   
       <!--- check if the loaded transaction was closed by an action equal or higher than the loaded serialno ---> 	 
		   AND 	    D.ServiceUsageSerialNo <= (SELECT MAX(SerialNo)
	   									  FROM   WorkOrderLineAction A
										  WHERE  A.WorkOrderId   = WL.WorkOrderId
										  AND    A.WorkOrderLine = A.WorkOrderLine
										  AND    A.ActionClass   = 'Closing'
										  AND	 A.ActionStatus <> '9')

	  		   
       <!--- 23/09/2011.  JDiaz. Added to filter based on the portal processing date for the service --->		   
	   AND	    D.TransactionDate >= (SELECT ISNULL(DatePortalProcessing,convert(datetime,'01/01/1900',101)) 
								      FROM 	 ServiceItemMission
								      WHERE  Mission     = WO.Mission
								      AND    ServiceItem = '#url.serviceitem#')		    

	   <!--- 2014-03-12 Added to filter transactions from closed periods (prior to DatePostingCalculate) --->
	   AND		D.TransactionDate >= (
	   				SELECT 	ISNULL(DatePostingCalculate,convert(datetime,'01/01/1900',101)) 
					FROM 	ServiceItemMission
					WHERE   Mission     = WO.Mission
					AND  	ServiceItem = '#url.serviceitem#')	
	
		ORDER BY WL.WorkOrderId, WL.WorkOrderLine, Year(D.TransactionDate),Month(D.TransactionDate)
							
	 </cfquery>		
	
	<!---		
	<cfoutput>
		#cfquery.executiontime#
	</cfoutput>
	--->		
	
	
	<cfquery name="ReadyForPosting"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">

	   SELECT  	ISNULL(SUM(isnull(Amount,0)),0) AS Amount
	   FROM    WorkOrderLine WL INNER JOIN WorkOrderLineDetail AS D 
	                    ON  D.WorkOrderId = WL.WorkOrderId AND D.WorkOrderLine = WL.WorkOrderLine 
						        LEFT OUTER JOIN WorkOrderLineDetailCharge AS C 
						ON  D.WorkOrderId = C.WorkOrderId 
						AND D.WorkOrderLine = C.WorkOrderLine 
						AND D.ServiceItem = C.ServiceItem 
						AND D.ServiceItemUnit = C.ServiceItemUnit 
						AND D.Reference = C.Reference 
						AND D.TransactionDate = C.TransactionDate
					INNER JOIN WorkOrder WO ON WO.WorkOrderId = WL.WorkOrderId
			   
	   WHERE   WL.WorkOrderId IN (SELECT WorkorderId 
	                              FROM   WorkOrder 
								  WHERE  WorkorderId  = WL.Workorderid 
								  AND    ServiceItem  = '#url.serviceitem#')			   
								  
	   AND	   WL.PersonNo = '#client.personno#'		  	  
	   AND	   WL.Operational = 1
	   <!--- transaction tagged as personal --->
	   AND     C.Charged      = '2'  	
	   AND     D.ActionStatus != '9'
	   
	   <!--- was closed through an action recorded in workorderlineaction : closing --->
	   <!---AND     C.ActionStatus = '1' --->
	   <!--- maybe we need to tune this even more in case of a reset --->
	   
	   <!--- 06/12/2011. JDiaz.  Replaced the validation of the ActionStatus with the following validation--->		   
	   AND 	   D.ServiceUsageSerialNo <= (SELECT   TOP 1 SerialNo
	   									  FROM     WorkOrderLineAction A
										  WHERE    A.WorkOrderId = WL.WorkOrderId
										  AND      A.WorkOrderLine = A.WorkOrderLine
										  AND      A.ActionClass   = 'Closing'
										  AND	   A.ActionStatus <> '9'
										  ORDER BY SerialNo DESC)

	  		   
       <!--- 23/09/2011.  JDiaz. Added to filter based on the portal processing date for the service --->		   
	   AND	   D.TransactionDate >= (SELECT ISNULL(DatePortalProcessing,convert(datetime,'01/01/1900',101)) 
								      FROM 	 ServiceItemMission
								      WHERE  Mission     = WO.Mission
								      AND    ServiceItem = '#url.serviceitem#')		    

	   <!--- 2014-03-12 Added to filter transactions from closed periods (prior to DatePostingCalculate) --->
	   AND		D.TransactionDate >= (
	   				SELECT 	ISNULL(DatePostingCalculate,convert(datetime,'01/01/1900',101)) 
					FROM 	ServiceItemMission
					WHERE   Mission     = WO.Mission
					AND  	ServiceItem = '#url.serviceitem#')	
									
	</cfquery>
	 	 		
	<!--- get threshold --->

	<cfset ThresholdExceeded       = "0">
	<cfset ThresholdAllowed        = "0">
	<cfset ThresholdExceededRef    = "">
	<cfset ThresholdExceededMonth  = "">
	
	
	<cfif UsageTotal.Amount eq "">	
		<cfset Total = 0>		
	<cfelse>
	    <cfset Total = UsageTotal.Amount>	
	</cfif>
	
	<cfif UsagePersonal.Amount eq "">	
		<cfset Personal = 0>		
	<cfelse>
	    <cfset Personal = UsagePersonal.Amount>	
	</cfif>
	
	<cfset OverallOfficial  = Total - Personal>	
	
	<cfif OverallOfficial eq "">
		<cfset OverallOfficial = 0>
	</cfif>
	
	<cfloop query="OfficialByMonth">		
	
		<cfset dtrans = DateFormat(createdate(YearTransaction,MonthTransaction,"1"),"YYYY-MM-DD")>

		<cfinvoke component = "Service.Process.WorkOrder.ValidateWorkorder"  
			method			= "CheckThreshold"
			mode			= "overall"
			WorkOrderId	 	= "#WorkOrderId#"
			WorkOrderline	= "#WorkOrderLine#"
			TransactionDate	= "#dtrans#"
			Amount			= "0"
			Charged			= "1"
			returnVariable	= "ThresholdValidated">
		
		<cfif ThresholdValidated eq "0" and ThresholdExceeded eq "0">
			<cfset ThresholdExceeded = "1">
			<cfset ThresholdExceededRef = OfficialByMonth.Reference>
			<cfset ThresholdExceededMonth = DateFormat(createdate(YearTransaction,MonthTransaction,"1"),"MMM YYYY") >
							
			<cfinvoke component = "Service.Process.WorkOrder.ValidateWorkorder"  
				method			= "GetThresholdAmount"
				WorkOrderId	 	= "#WorkOrderId#"
				WorkOrderline	= "#WorkOrderLine#"
				TransactionDate	= "#dtrans#"
				Charged			= "1"
				returnVariable	= "ThresholdAllowed">
				
			    <cfbreak>

		</cfif>			
		
	</cfloop>
	
	 <cfquery name="PostingTotal"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
		SELECT    isnull(SUM(Amount),0) AS Amount
		FROM      Payroll.dbo.PersonMiscellaneous 
		WHERE     PersonNo = '#client.personno#'
		AND       PayrollItem IN ( SELECT TOP 1 PayrollItem
				  	               FROM   ServiceItemUnit 
					               WHERE  ServiceItem = '#url.serviceitem#')					   
	</cfquery>		
			
	<cfif ReadyForPosting.recordcount eq "0">
		<cfset ReadyForPostingTot = "0">
	<cfelse>
		<cfset ReadyForPostingTot = ReadyForPosting.Amount>
	</cfif>

	<cfset pending = ReadyForPostingTot - PostingTotal.Amount>
	
	<table width="100%" cellspacing="0" cellpadding="0">
								
	<tr>
	   <td class="labelmedium" height="25"><b>Pending</b> for Approval:</td>
	   <td align="right" colspan="2" class="labelmedium" style="padding-right:5px"><font size="2" color="gray">#getUsageLabel.LabelCurrency# #numberformat(UsageTotal.Amount,"__,__.__")#</font></b></td>
	</tr>
	
	<tr>
	   <td width="50%" style="height:25px;padding-left:10px" class="labelmedium">Business Charges:</td>	  

	   <cfif total neq "0">
	   <td width="50" align="right" class="labelmedium">
		(#numberformat((OverallOfficial*100)/Total,"_._")#%)
		</td>
	   </cfif>	
		
	   <td id="chargebusiness" align="right" style="height:24px;padding-right:5px" class="labelmedium">
							
			<cfif ThresholdExceeded eq "1">
			
			  <cf_UIToolTip tooltip="Threshold for this month exceeded, only $#ThresholdAllowed# are allowed.">
			  
				  <img src="#SESSION.root#/Images/warning.gif" border="0">		  
				  <font color="red">#getUsageLabel.LabelCurrency# #numberformat(OverallOfficial,"__,__.__")#
				  
			  </cf_UIToolTip>
			  
			 <cfelse> 
			
			      #getUsageLabel.LabelCurrency# #numberformat(OverallOfficial,"__,__.__")#
			   
			  </cfif> 
			
		</td>
		
		

	</tr>
	
	<tr style="border:1px solid gray">
	   <td class="labelmedium" bgcolor="white" height="18" style="border-top:dotted silver 1px;padding-left:15px">Personal Charges: </td>
	   
	   <cfif total neq "0">
	    <td width="50" align="right" class="labelmedium" bgcolor="white" height="18" style="border-top:dotted silver 1px;padding-left:15px"><font color="0080C0">
		(#numberformat((Personal*100)/Total,"_._")#%)
		</td>
	   </cfif>	
		
	   <td id="chargepersonal" align="right" style="padding-right:5px;border:0px solid gray;padding-left:15px" id="chargepersonal" class="labellarge" bgcolor="white" height="18">
	   		<b><font color="0080C0">#getUsageLabel.LabelCurrency# #numberformat(Personal,"__,__.__")#</b>
	   </td>	   
	 
	</tr>
	
	</table>
	
</cfoutput>	