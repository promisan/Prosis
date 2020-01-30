
	<cfset req = RequisitionNo>
	<cfset row = currentrow>
	
	<cfquery name="Class" 
	    datasource="AppsPurchase" 
	    username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 DELETE FROM  InvoicePurchaseClass
		 WHERE InvoiceId = '#Guid#'
		 AND   RequisitionNo = '#Req#'
	</cfquery>		
					
	<cfquery name="PurchaseClass" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_PurchaseClass 
	WHERE   SetAsDefault = 0
	</cfquery>
		
	<cfloop query="PurchaseClass">
	
		<cfparam name="Form.req#row#_#code#" default="">
		
		<cfset vc = evaluate("Form.req#row#_#code#")>
		<cfset vc = replace(vc,',','',"ALL")>
		
		<cfif LSisNumeric(vc) and vc neq "0">
		
			 <cfquery name="Check1" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  *
					FROM    PurchaseLineClass 
					WHERE   RequisitionNo = '#Req#'
					AND     PurchaseClass = '#Code#'					
			</cfquery>
			
			<cfif check1.recordcount eq "0">
				  <cfquery name="PurchaseClass" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO PurchaseLineClass 
						(RequisitionNo, 
						 PurchaseClass, 
						 AmountPurchase, 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName)
						VALUES
						('#req#',
						 '#Code#',
						 '0',
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#')
					</cfquery>
			</cfif>
		
			 <cfquery name="InsertClassLine" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO InvoicePurchaseClass
				 (InvoiceId,
				  RequisitionNo,
				  PurchaseClass,
				  AmountInvoiced,
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName) 
			  VALUES
				  ('#Guid#', 
				   '#req#',
				   '#code#',
				   '#Round(vc*100)/100#',
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#') 
			 </cfquery>									 
					
		</cfif>				
	
	</cfloop>
	
	<!--- default recording --->
	
	<cfquery name="PurchaseClass" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_PurchaseClass 
	WHERE SetAsDefault = 1
	</cfquery>
	
	<cfset def = PurchaseClass.code>
	
	<cfquery name="Class" 
	    datasource="AppsPurchase" 
	    username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
		 SELECT sum(AmountInvoiced) as Total
		 FROM  InvoicePurchaseClass
		 WHERE InvoiceId = '#Guid#'
		 AND   RequisitionNo = '#RequisitionNo#'
	</cfquery>			
	
	<cfif class.total eq "">
	  <cfset t = 0>
	<cfelse>
	  <cfset t = class.total>  
	</cfif>

	<cftry>
		<cfset x=#v#-#t#>
	<cfcatch>
		<cfset x="0">
	</cfcatch>
	</cftry>		
	
	<cfif x neq "0">
	
		<cftry>
		
			<cfquery name="InsertClass" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO PurchaseLineClass
				 (RequisitionNo,
				  PurchaseClass,
				  AmountPurchase,
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName) 
			  VALUES
				  ('#RequisitionNo#',
				   '#def#',
				   '0',
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#') 
			 </cfquery>		
		 
		 <cfcatch></cfcatch>
		 </cftry>
		
		<cfquery name="InsertDefaultClass" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO InvoicePurchaseClass
			 (InvoiceId,
			  RequisitionNo,
			  PurchaseClass,
			  AmountInvoiced,
			  OfficerUserId, 
			  OfficerLastName, 
			  OfficerFirstName) 
		  VALUES
			  ('#Guid#', 
			   '#RequisitionNo#',
			   '#def#',
			   '#v-t#',
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#') 
		 </cfquery>		
		 	
	</cfif>						
	