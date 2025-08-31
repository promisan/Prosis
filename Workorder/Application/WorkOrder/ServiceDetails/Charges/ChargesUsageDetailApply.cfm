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
<cfparam name="url.src" default="">

<!--- you may pass transactionid to apply directly --->

<cfif url.action eq "update">

    <cfparam name="transactionids" default="#url.id#">
	
<cfelse>
  
    <cfparam name="form.TransactionListContent" default="">
    <cfparam name="transactionids" default="#form.transactionlistcontent#">
	
	<!--- JDiaz 2011-11-30. If is batch processing, gets the total amount first in order to validate the threshold --->
	
	<cfif transactionids neq "">
	
		<cfquery name="getListTotal"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		   SELECT  sum(Amount) as TotalAmount
		   FROM    WorkOrderLineDetail
		   WHERE   TransactionId IN ('#replace(transactionids,",","','","ALL")#') 
		</cfquery>

		<cfset ListTotal = getListTotal.TotalAmount>		
		
	<cfelse>
	
		<cfset ListTotal = "0">
		
	</cfif>

</cfif>

<cfoutput>

<cfset row = "0">

<cfloop index="traid" list="#transactionids#">

	<cfif isValid("GUID",traid) and traid neq ""> 

    <cfset row = row+1>

	<cfquery name="getDetail"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
	   SELECT  *
	   FROM    WorkOrderLineDetail
	   WHERE   TransactionId = '#traid#'
	</cfquery>
		
	<cfquery name="Check"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
	     SELECT *
	     FROM   WorkOrderLineDetailCharge
	     WHERE  TransactionId = '#traid#'
	</cfquery>

	<cfif check.recordcount eq "0">
	
		<!--- JDiaz 2012-03-22 check by the 6 common fields if no record found by transactionid --->
		<cfquery name="Check"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		     SELECT *
		     FROM   WorkOrderLineDetailCharge 
		     WHERE  WorkOrderId     = '#getDetail.WorkOrderId#'
			 AND	WorkOrderLine   = '#getDetail.WorkOrderLine#'
			 AND	ServiceItem     = '#getDetail.ServiceItem#'
			 AND	ServiceItemUnit = '#getDetail.ServiceItemUnit#'
			 AND	Reference       = '#getDetail.Reference#'
			 AND	TransactionDate = '#getDetail.TransactionDate#'
		</cfquery>
		
		<!--- JDiaz 2013-01-09 if the transactionId in WorkroderLineDetailCharge is not the same as in WorkOrderLineDetail,
				get the transactionId obtained by the 6 common fields  --->
				
		<cfif check.TransactionId neq "">		
			<cfset traid=check.TransactionId>
		</cfif>	
		
	</cfif>	
	
	<!--- --------------------------------------------------- --->
	<!--- perform the threshold validation if this is defined --->
	<!--- --------------------------------------------------- --->
	<!---	
	<cfquery name="Threshold"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		    SELECT   TOP 1 *
			FROM     WorkOrderThreshold
			WHERE    WorkOrderId    =  '#getDetail.WorkOrderId#'
			AND      WorkOrderLine  =  '#getDetail.WorkOrderLine#'	
			AND      DateEffective  <= '#getDetail.TransactionDate#'
			ORDER BY DateEffective DESC		
	</cfquery>	
	
	<cfif Threshold.recordcount eq "0">
	
		<cfquery name="Threshold"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		    SELECT   TOP 1 *
			FROM     WorkOrderThreshold			
			WHERE    WorkOrderId      = '#getDetail.WorkOrderId#'
			AND      WorkOrderLine    = '0'
			AND      DateEffective   <= '#getDetail.TransactionDate#'			
			ORDER BY DateEffective DESC		
			
	    </cfquery>		
		
	</cfif>	
	--->
	
	<cfset apply = "1">
	
	<!---		
	<cfif Threshold.recordcount gte "1" and url.charged eq Threshold.Charged>
	--->	
		<!--- determine month of the transaction and then check if a threshold is exceeded --->
			
		<cfset str = CreateDate(year(getdetail.transactiondate),month(getdetail.transactiondate), "1")>
		<cfset end = CreateDate(year(getdetail.transactiondate),month(getdetail.transactiondate),daysinmonth(str))>	
				
		<cfset end = DateAdd("d","1", end)>
									
		<!--- determine total amount for business + transactionamount --->
		
		<cfquery name="ValidateAmount"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">   
		   SELECT  isnull(SUM(Amount),0) AS Amount
		   FROM    WorkOrderLineDetail AS D INNER JOIN
				   ServiceItemUnit U ON U.ServiceItem = D.Serviceitem AND U.Unit = D.ServiceItemUnit			   
				   
				   INNER JOIN
		           WorkOrderLineDetailCharge AS C ON D.WorkOrderId = C.WorkOrderId AND D.WorkOrderLine = C.WorkOrderLine AND 
		           D.ServiceItem = C.ServiceItem AND D.ServiceItemUnit = C.ServiceItemUnit AND D.Reference = C.Reference AND 				   
	    	       D.TransactionDate = C.TransactionDate
				  
				   				   
		   WHERE   D.WorkOrderId   = '#getDetail.workorderid#'			   
		   AND	   D.WorkOrderLine = '#getDetail.workorderline#'	
		   AND     D.TransactionDate >= #str#
		   AND     D.TransactionDate < #end#	
		   AND	   C.Charged = '#url.Charged#'
		   AND     D.ActionStatus != '9'
		   <!---			   	   	   
		   AND     C.Charged = '#Threshold.Charged#' 
		   --->
		</cfquery>				
				
		<!--- compare total with threshold amount --->

		<cfif url.action neq "updatebatch" or (url.action eq "updatebatch" and url.charged eq "1" )>		
							
			<cfif url.action eq "updatebatch">
			
				<cfset total = ValidateAmount.Amount + ListTotal>
				
			<cfelse>
			
				<cfset total = ValidateAmount.Amount + getDetail.Amount>
				
			</cfif>

			<cfinvoke component = "Service.Process.WorkOrder.ValidateWorkorder"  
				method			= "CheckThreshold"
				mode			= "transaction"
				WorkOrderId	 	= "#getDetail.WorkOrderId#"
				WorkOrderline	= "#getDetail.WorkOrderLine#"
				TransactionDate	= "#getDetail.TransactionDate#"
				Amount			= "#total#"
				Charged			= "#url.charged#"
				returnVariable	= "ThresholdValidated">
			
			<cfinvoke component = "Service.Process.WorkOrder.ValidateWorkorder"  
				method			= "GetThresholdAmount"
				WorkOrderId	 	= "#getDetail.WorkOrderId#"
				WorkOrderline	= "#getDetail.WorkOrderLine#"
				TransactionDate	= "#getDetail.TransactionDate#"
				Charged			= "#url.charged#"
				returnVariable	= "AmountAllowed">
				
			<cfif AmountAllowed gt "0" and total gte AmountAllowed>			
				<cfoutput>
				<script>
				<!---alert('You are about to exceed your monthly threshold amount of $#numberformat(Threshold.Threshold,"__,__.__")#. Action interrupted.')			--->
				alert('You are about to exceed your monthly threshold amount of $#numberformat(AmountAllowed,"__,__.__")#. Action interrupted.')
				try {
				document.getElementById("chk_#traid#_1").checked = false
				document.getElementById("chk_#traid#_2").checked = true
				} catch(e) {}
				</script>
				</cfoutput>					
				<cfexit method="EXITTEMPLATE">
			</cfif> 
				
		</cfif>
	<!---	
	</cfif>	
	--->
	<!--- directly update the screen without reload --->
					
	<cfif url.action eq "updatebatch">
				
		<cfoutput>		
			
		<script>	
			<cfif url.charged eq "2">
				if (document.getElementById("chk_#traid#_1")) {document.getElementById("chk_#traid#_1").checked = false}
				if (document.getElementById("chk_#traid#_2")) {document.getElementById("chk_#traid#_2").checked = true}
			<cfelseif url.charged eq "1">
				if (document.getElementById("chk_#traid#_1")) {document.getElementById("chk_#traid#_1").checked = true}
				if (document.getElementById("chk_#traid#_2")) {document.getElementById("chk_#traid#_2").checked = false}
			</cfif>
		</script>
		
		</cfoutput>		
			
	</cfif>	
		
	<cfif apply eq "1">
	
		<cfif check.recordcount eq "0">
						
			<cfquery name="ClearPossiblePriorThisIsSame"
			   datasource="AppsWorkOrder"
			   username="#SESSION.login#"
			   password="#SESSION.dbpw#">
			    DELETE WorkOrderLineDetailCharge		
				WHERE  WorkOrderId      = '#getDetail.WorkOrderId#'
				AND    WorkOrderLine    =  #getDetail.WorkOrderLine#
				AND    ServiceItem      = '#getDetail.ServiceItem#'
				AND    ServiceItemUnit  = '#getDetail.ServiceItemUnit#'
				AND    Reference        = '#getDetail.Reference#'
				AND    TransactionDate  = '#getDetail.TransactionDate#'
			</cfquery>	
					
			<cfquery name="addCharges"
			   datasource="AppsWorkOrder"
			   username="#SESSION.login#"
			   password="#SESSION.dbpw#">
			    INSERT INTO  WorkOrderLineDetailCharge				
						
						(WorkOrderId, 
						 WorkOrderLine, 
						 ServiceItem, 
						 ServiceItemUnit, 
						 Reference, 
						 TransactionDate, 
						 TransactionId, 
						 DetailReference, 
						 Charged, 						
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName)
				 
			    SELECT   WorkOrderId, 
				         WorkOrderLine, 
					     ServiceItem, 
					     ServiceItemUnit, 
					     Reference, 
					     TransactionDate, 
					     TransactionId,
					     DetailReference,
					     '#url.charged#',					    
					     '#SESSION.acc#',
					     '#SESSION.last#',
					     '#SESSION.first#'
				
				 FROM   WorkOrderLineDetail
				WHERE   TransactionId = '#traid#'
				
			</cfquery>	
						
		<cfelse>	
					
				<cfquery name="ResetRecord"
				   datasource="AppsWorkOrder"
				   username="#SESSION.login#"
				   password="#SESSION.dbpw#">
				    UPDATE WorkOrderLineDetailCharge
					SET    Charged          = '#url.charged#',
					       OfficerUserId    = '#SESSION.acc#',
						   OfficerLastName  = '#SESSION.last#',
						   OfficerFirstName = '#SESSION.first#', 
						   Created          = getDate()
					WHERE  TransactionId    = '#traid#'		
				</cfquery>	
										
		</cfif>
			
		
	<cfelse>
				
		<cfexit method="LOOP">	
	
	</cfif>
	
   </cfif>	
	
</cfloop>
			
</cfoutput>	

<cfif url.src neq "inspect">
	<cfif url.scope eq "data">
		<cfinclude template="ChargesUsageDetailDataApplied.cfm">
	<cfelse>
		<cfinclude template="ChargesUsageDetailApprovalApplied.cfm">
	</cfif>
</cfif>

<script>
	Prosis.busy('no')	
</script>
