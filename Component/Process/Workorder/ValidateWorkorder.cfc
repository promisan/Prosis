
<!--- 
   Name : /Component/Process/ValidateWorkorder.cfc
   Description : Validation Functions  
   1.1.  Threshold
   1.2.  ...
   1.3.  ...
   1.4.  ...    
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Validation Queries">
	
	<cffunction name="CheckThreshold"
        access="public"
        returntype="string"
        displayname="Validate Threshold for WorkOrder Line">
		
		<cfargument name="mode"        		type="string"	required="true"  default="transaction">   <!--- transaction : validates threshold for 1 transaction.  overall: validates the overal threshold for the month --->
		<cfargument name="WorkOrderId"      type="string" 	required="true"  default="">	 
		<cfargument name="WorkOrderline"    type="string" 	required="true"  default="">
		<cfargument name="TransactionDate"  type="date" 	required="true">
		<cfargument name="Amount"    		type="string"	required="true"	 default="0">
		<cfargument name="Charged"    		type="string"	required="true">
								
		<!--- ------------------------------------------ --->
		<!--- ----- get the threshold for the line ----- --->
		<!--- ------------------------------------------ --->		

			<cfquery name="getThreshold"
				   datasource="AppsWorkOrder"
				   username="#SESSION.login#"
				   password="#SESSION.dbpw#">
				    SELECT TOP 1 *
					FROM   WorkOrderThreshold
					WHERE  WorkOrderId      = '#workorderid#'	 
					AND    WorkOrderLine    = '#workorderline#'
					AND    DateEffective  <= '#TransactionDate#'
					AND	   Charged = '#charged#'
					ORDER BY DateEffective DESC		
			</cfquery>	
			
			<cfif getThreshold.recordcount eq "0">
			
				<cfquery name="getThreshold"
				   datasource="AppsWorkOrder"
				   username="#SESSION.login#"
				   password="#SESSION.dbpw#">
				    SELECT   TOP 1 *
					FROM     WorkOrderThreshold
					WHERE  WorkOrderId      = '#workorderid#'	 
					AND    WorkOrderLine    = '0'			
					AND    DateEffective  <= '#TransactionDate#'
					AND	   Charged = '#charged#'
					ORDER BY DateEffective DESC		
			    </cfquery>		
		
			</cfif>
			
			<cfif getThreshold.recordcount eq "0">
				<cfreturn "1">
			<cfelse>
				<!--- If threshold defined check the business amount for the month --->
				
				<cfset dstart  = createdate(year(TransactionDate), month(TransactionDate), 1)>
				<cfset dend  = createdate(year(TransactionDate), month(TransactionDate), daysInMonth(Transactiondate))>
				
				<cfif mode eq "transaction" or (mode eq "overall" and Amount eq "0")>				
					<cfquery name="ValidateAmount"
					   datasource="AppsWorkOrder"
					   username="#SESSION.login#"
					   password="#SESSION.dbpw#">   
					   SELECT  isnull(SUM(Amount),0) AS Amount
					   FROM    WorkOrderLineDetail AS D INNER JOIN
					           WorkOrderLineDetailCharge AS C ON D.WorkOrderId = C.WorkOrderId AND D.WorkOrderLine = C.WorkOrderLine AND 
					           D.ServiceItem = C.ServiceItem AND D.ServiceItemUnit = C.ServiceItemUnit AND D.Reference = C.Reference AND 				   
				    	       D.TransactionDate = C.TransactionDate
							  
							   				   
					   WHERE   D.WorkOrderId   = '#workorderid#'			   
					   AND	   D.WorkOrderLine = '#workorderline#'	
					   AND     D.TransactionDate >= #dstart#
					   AND     D.TransactionDate < #dend#				   	   	   
					   AND     C.Charged = '#Charged#' 
					</cfquery>			
					
					<cfset AmountMonth = ValidateAmount.Amount + Amount>
				<cfelse>
				
					<cfset AmountMonth = Amount>				
				
				</cfif>
				
				

				<cfif getThreshold.Threshold gt AmountMonth>
					<cfreturn "1">
				<cfelse>
					<cfreturn "0">
				</cfif>
			</cfif>
			
				
	</cffunction>	
	

	<cffunction name="GetThresholdAmount"
        access="public"
        returntype="string"
        displayname="Validate Threshold for WorkOrder Line">
		
		<cfargument name="WorkOrderId"      type="string" 	required="true"  default="">	 
		<cfargument name="WorkOrderline"    type="string" 	required="true"  default="">
		<cfargument name="TransactionDate"  type="date" 	required="true">
		<cfargument name="Charged"    		type="string"	required="true">

			<cfquery name="getThreshold"
				   datasource="AppsWorkOrder"
				   username="#SESSION.login#"
				   password="#SESSION.dbpw#">
				    SELECT TOP 1 *
					FROM   WorkOrderThreshold
					WHERE  WorkOrderId      = '#workorderid#'	 
					AND    WorkOrderLine    = '#workorderline#'
					AND    DateEffective  <= '#TransactionDate#'
					AND	   Charged = '#charged#'
					ORDER BY DateEffective DESC		
			</cfquery>	
			
			<cfif getThreshold.recordcount eq "0">
			
				<cfquery name="getThreshold"
				   datasource="AppsWorkOrder"
				   username="#SESSION.login#"
				   password="#SESSION.dbpw#">
				    SELECT   TOP 1 *
					FROM     WorkOrderThreshold
					WHERE  WorkOrderId      = '#workorderid#'	 
					AND    WorkOrderLine    = '0'			
					AND    DateEffective  <= '#TransactionDate#'
					AND	   Charged = '#charged#'
					ORDER BY DateEffective DESC		
			    </cfquery>		
		
			</cfif>

			<cfif getThreshold.recordcount eq "0">
				<cfreturn "0">
			<cfelse>
				<cfreturn getThreshold.Threshold>
			</cfif>

	
	</cffunction>	
</cfcomponent>			 