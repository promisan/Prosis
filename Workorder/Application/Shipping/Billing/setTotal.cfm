
<!--- set total --->

<cfparam name="Form.selected" default="">
<cfif url.workORderID eq "">
	<cfset url.workorderid = "00000000-0000-0000-0000-000000000000">
</cfif>

<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     WorkOrder
	WHERE    WorkOrderId   = '#url.workorderid#'	
</cfquery>	

<cfif workorder.recordcount eq "1">
	
	<cfquery name="customer" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      Customer
		WHERE     CustomerId = '#workorder.customerid#'	
	</cfquery> 
	
	<cfquery name="getTotalTransaction" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    SUM(TransactionQuantity)*-1 AS TotalQuantity
		FROM      ItemTransaction
		<cfif form.selected neq "">
		WHERE     TransactionId IN (#preservesinglequotes(Form.Selected)#) 	
		<cfelse>
		WHERE 1=0
		</cfif>
	</cfquery>
	
	<cfquery name="getTotal" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    SUM(SalesTotal)  AS Total,
				  SUM(SalesAmount) AS SaleIncome,
				  SUM(SalesTax)    AS SaleTax
		FROM      ItemTransactionShipping
		<cfif form.selected neq "">
		WHERE     TransactionId IN (#preservesinglequotes(Form.Selected)#) 	
		<cfelse>
		WHERE 1=0
		</cfif>
	</cfquery>  
	
	<cfif form.selected neq "">
		
		<cfset sale    = getTotal.SaleIncome>
		
		<cfif sale neq "0" and sale neq "" and customer.taxexemption eq "0">
			<cfset sale    = getTotal.SaleIncome>		
			<cfset tax     = getTotal.SaleTax>		
		    <cfset taxrate = round(tax*1000 / sale)/1000>  <!--- line 0.12 --->
		<cfelseif customer.taxexemption eq "1">		
		    <cfset sale    = sale + getTotal.SaleTax>	
			<cfset tax     = 0>		
		    <cfset taxrate = 0>		   
		<cfelse>   
			<cfset tax     = 0>		
		    <cfset taxrate = 0>
		</cfif>
			
		<cfset total   = sale + tax>	
		
		<cfquery name="Entry" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					   SELECT   *
					   FROM     Ref_ParameterMissionGLedger G INNER JOIN
				                Ref_AreaGLedger R ON G.Area = R.Area
					   WHERE    R.BillingEntry = 1
					   AND      G.Mission = '#workorder.mission#'
					   ORDER BY R.ListingOrder
			</cfquery>
			
			<cfset row = "0">
			<cfset ar=ArrayNew(2)>	
			
			<cfloop query="Entry">
			
				 <!--- overruling account --->
				 
				 <cfquery name="getArea" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   SELECT   *
					   FROM     WorkOrderGLedger
					   WHERE    WorkOrderId = '#url.workorderid#'
					   AND      Area        = '#Area#'			 
				 </cfquery>
				 	
				 <cfset val   = evaluate("Form.Amount_#Area#")>
				 <cfset val   = replace(val,",","","ALL")>
				 
				 <cfif val neq "" and LSIsNumeric(val) and val neq "">
							 								  
						<cfset row = row+1>
													  
					  	<cfset sale = sale + val>		
						
						<cfif applyTax eq "1" and customer.taxexemption eq "0">
						
						    <cfset tax = tax + (val * taxrate)>					
																																		
						</cfif>
						
						<cfset total = sale + tax>				
				 
				 </cfif>
			 	
			</cfloop>
		
		<cfoutput>	
		
		  <script>  	 
			  document.getElementById('saleamount').value      = '#numberformat(getTotal.SaleIncome + getTotal.SaleTax,",__.__")#'	
			  document.getElementById('totalamount').value     = '#numberformat(sale,",__.__")#'	
			  document.getElementById('taxamount').value       = '#numberformat(tax,",__.__")#'
			  document.getElementById('payableamount').value   = '#numberformat(total,",__.__")#'
		  </script>
			
		</cfoutput>
	
	<cfelse>
	
		<cfoutput>	
		
		  <script>  
		   try {    
			  	  
			  document.getElementById('totalamount').value     = '0.00'		  
			  document.getElementById('taxamount').value       = '0.00'		  
			  document.getElementById('payableamount').value   = '0.00'
			  document.getElementById('saleamount').value      = '0.00'		
			  
			  } catch(e) {}
		  </script>
			
		</cfoutput>
			
	</cfif>
	
</cfif>	

