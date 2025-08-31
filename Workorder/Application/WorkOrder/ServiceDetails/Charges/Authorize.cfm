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
<cfquery name="ServiceItem"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
   SELECT * 
   FROM   ServiceItem 
   WHERE  Code = '#url.serviceitem#'
</cfquery> 

<cfquery name="ServiceItemUnit"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
   SELECT TOP 1 labelCurrency
   FROM   ServiceItemUnit
   WHERE  ServiceItem = '#url.serviceitem#'
   AND labelCurrency IS NOT NULL
</cfquery> 
	
<cfquery datasource="AppsWorkorder" name="TotalPersonal">
							 			 			     
		SELECT  SUM(D.Amount) as TotalAmount, 
		        MIN(D.Currency) as Currency
	    FROM    WorkOrderLine WL
				INNER JOIN WorkOrderLineDetail AS D ON D.WorkOrderId = WL.WorkOrderId AND D.WorkOrderLine = WL.WorkOrderLine 						
				INNER JOIN ServiceItemUnit U ON U.ServiceItem = D.Serviceitem AND U.Unit = D.ServiceItemUnit
		        INNER JOIN WorkOrderLineDetailCharge AS C 
						ON  D.WorkOrderId     = C.WorkOrderId 
						AND D.WorkOrderLine   = C.WorkOrderLine 
						AND D.ServiceItem     = C.ServiceItem 
						AND D.ServiceItemUnit = C.ServiceItemUnit 
						AND D.Reference       = C.Reference 
						AND D.TransactionDate = C.TransactionDate 
						
				LEFT OUTER JOIN Ref_ServiceItemDomainClass DC ON DC.ServiceDomain = WL.ServiceDomain AND DC.Code = WL.ServiceDomainClass	
					 
	   WHERE     WL.WorkOrderId IN (SELECT WorkorderId 
		                             FROM   WorkOrder 
									 WHERE  WorkorderId = WL.Workorderid 
									 AND    ServiceItem = '#url.serviceitem#')			   
	   AND	     WL.PersonNo = '#client.personno#'	
       AND		 WL.Operational = 1 	   
	   	  
	   AND       D.Charged      <> '0'  
	   AND       C.Charged      = '2'  	
	   AND       D.ActionStatus != '9'
	   
	   <!---
	   AND       C.ActionStatus = '0'	
	   --->
	      		 
	   <!--- 29/06/2011.  JDiaz. Added to filter based on the portal processing date for the service --->
	   
	   AND		D.TransactionDate >= (
	   				SELECT 	ISNULL(DatePortalProcessing,convert(datetime,'01/01/1900',101)) 
					FROM 	ServiceItemMission
					WHERE   Mission     = '#url.mission#'
					AND	    ServiceItem = '#url.serviceitem#')	
					
	   <!--- 2014-03-12 Added to filter transactions from closed periods (prior to DatePostingCalculate) --->
	   AND		D.TransactionDate >= (
		   				SELECT 	ISNULL(DatePostingCalculate,convert(datetime,'01/01/1900',101)) 
						FROM 	ServiceItemMission
						WHERE   Mission     = '#url.mission#'
						AND  	ServiceItem = '#url.serviceitem#')		
							
	   AND      D.ServiceUsageSerialNo > (SELECT ISNULL(MAX(SerialNo),0)
	                                      FROM   WorkOrderLineAction
										  WHERE  WorkorderId   = WL.WorkOrderId
										  AND    WorkOrderLine = WL.WorkOrderLine
										  AND    ActionClass   = '#Serviceitem.UsageActionClose#'
										  AND	 ActionStatus <> '9' ) 	   
										  
		AND     D.ServiceUsageSerialNo NOT IN ( SELECT  L1.ServiceUsageSerialNo
						      					FROM    ServiceItemLoad L1
								    			WHERE   L1.Mission     = '#url.mission#'
									    		AND	    L1.ServiceItem = '#url.serviceitem#'
										    	AND     L1.ActionStatus = '0' )								  
												
		AND ((DC.ChargeTagging IS NULL ) OR (DC.ChargeTagging ='1'))										
	   	   		
</cfquery>

<cfquery name="OfficialByMonth"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">

   SELECT  	WL.WorkOrderid,
   			WL.WorkOrderLine,
			WL.Reference,
			Year(D.TransactionDate) as YearTransaction,
			Month(D.TransactionDate) as MonthTransaction,					
   			SUM(isnull(Amount,0)) AS Amount
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
   AND		 WL.Operational = 1    
   
   <!--- Business transactions --->
   AND     C.Charged      = '1'  	
   AND     D.ActionStatus != '9'   		   
   AND 	   D.ServiceUsageSerialNo <= (SELECT MAX(SerialNo)
   										FROM WorkOrderLineAction A
										WHERE A.WorkOrderId = WL.WorkOrderId
										AND A.WorkOrderLine = A.WorkOrderLine
										AND	 ActionStatus <> '9')

   AND	   D.TransactionDate >= (SELECT ISNULL(DatePortalProcessing,convert(datetime,'01/01/1900',101)) 
							      FROM 	 ServiceItemMission
							      WHERE  Mission     = WO.Mission
							      AND    ServiceItem = '#url.serviceitem#')		
								  
	   <!--- 2014-03-12 Added to filter transactions from closed periods (prior to DatePostingCalculate) --->
   AND		D.TransactionDate >= (
	   				SELECT 	ISNULL(DatePostingCalculate,convert(datetime,'01/01/1900',101)) 
					FROM 	ServiceItemMission
					WHERE   Mission     = '#url.mission#'
					AND  	ServiceItem = '#url.serviceitem#')									      

	GROUP BY WL.WorkOrderId, WL.WorkOrderLine, WL.Reference,Year(D.TransactionDate),Month(D.TransactionDate)
						
 </cfquery>		


<cfset ThresholdExceeded = "0">
<cfset ThresholdAllowed = "0">
<cfset ThresholdExceededRef = "">
<cfset ThresholdExceededMonth = "">

<cfloop query="OfficialByMonth">

	<cfset dtrans = DateFormat(createdate(YearTransaction,MonthTransaction,"1"),"YYYY-MM-DD")>

	<cfinvoke component = "Service.Process.WorkOrder.ValidateWorkorder"  
		method			= "CheckThreshold"
		mode			= "overall"
		WorkOrderId	 	= "#WorkOrderId#"
		WorkOrderline	= "#WorkOrderLine#"
		TransactionDate	= "#dtrans#"
		Amount			= "#OfficialByMonth.Amount#"
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
 
<cfoutput>

<table cellpadding="0" cellspacing="0" border="0" height="100%" width="100%" bgcolor="white">

<tr><td>

	<table cellpadding="0" cellspacing="0" border="0" width="90%" align="center" bgcolor="white">
	
		<tr>
			<td colspan="2" class="labelmedium" style="padding-top: 0px; padding-left: 15px; padding-right: 15px; line-height: 2;" align="justify">
				
				<cfif ThresholdExceeded eq "0">
				
				I, <u>#SESSION.first# #SESSION.last#</u>, hereby certify that I have reviewed myUNcalls usage and marked Personal and Business calls accordingly. I understand that <b>#ServiceItemUnit.LabelCurrency# <span id="approvalamount">#numberformat(TotalPersonal.TotalAmount,"__,__.__")#</span></b> related to my personal calls will be recovered through payroll or my Executive Office.
				
				<cfelse>
				
					Your device #ThresholdExceededRef# exceeded the threshold for #ThresholdExceededMonth#, only $#ThresholdAllowed# are allowed. Check with your EO for more information. 
					
				</cfif>
			</td>
		</tr>
		
		<tr><td height="7"></td></tr>

		<tr><td colspan="2" class="line"></td></tr>

		<tr><td height="8"></td></tr>
		
		<tr>
		
			<cfif ThresholdExceeded eq "0">
			
				<td colspan="2" width="100%" align="center">
				
					<input class="button10s" style="font-size:14;width:300;height:35" type="button" value="Authorise charges" 
					onclick="ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/servicedetails/charges/chargesUsageSubmit.cfm?mission=#url.mission#&serviceitem=#url.serviceitem#','target'); ColdFusion.Window.hide('Auth');">
				
			 	</td>
				
			</cfif>	
		
		</tr>
		
		<tr><td height="8"></td></tr>
		
	</table>
	
	</td>
	</tr>
	
	<tr><td height="10"></td></tr>
	
</table>

</cfoutput>
