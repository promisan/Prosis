<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<cf_systemscript>

<cfif ParameterExists(Form.clear)> 

    <cftransaction>
	
	<cfquery name="getQuote" 
			 datasource="AppsPurchase" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">			 
				SELECT * FROM RequisitionLineQuote
				WHERE  QuotationId = '#url.id#'
	</cfquery>

	<cfquery name="DeleteQuote" 
			 datasource="AppsPurchase" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">			 
				DELETE FROM RequisitionLineQuote
				WHERE  QuotationId = '#url.id#'
	</cfquery>
			
	<cfquery name="Job" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Job 
		WHERE  JobNo ='#getQuote.JobNo#'
	</cfquery>
	
	<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ParameterMission
			WHERE  Mission = '#Job.Mission#' 
	</cfquery>
	
	<cfquery name="Insert" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 INSERT INTO RequisitionLineQuote 
				 
						 (RequisitionNo, 
						  JobNo, 
						  OrgUnitVendor, 
						  VendorItemDescription, 
						  TaxIncluded,
					      TaxExemption,
						  QuoteTax, 					  
						  QuotationQuantity, 
						  QuotationUoM, 
						  Currency,
						  ExchangeRate,
						  
						  <cfif Parameter.EnableQuickQuote eq "1">
						 
						 	<cfif Parameter.TaxExemption eq "1">	
							
							  QuotePrice,
							  QuoteAmountCost,
							  QuoteAmountBaseCost, 						  
							  
							 <cfelse> 	
													 
							  QuotePrice,
							  QuoteAmountCost,
							  QuoteAmountBaseCost, 	
							  QuoteAmountTax,
							  QuoteAmountBaseTax,
							 					 
							 </cfif>
							 
							 Selected,				   
							  
						 </cfif>						
						  
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
						  
				 SELECT  RequisitionNo, 
				         '#getQuote.JobNo#', 
						 '#getQuote.OrgUnitVendor#', 
						 RequestDescription, 
						 '#Parameter.DefaultTaxIncluded#',
						 '#Parameter.TaxExemption#',
						 '#Parameter.TaxDefault#', 
						 RequestQuantity, 
						 QuantityUoM, 
						 RequestCurrency,						 
						 
						 (RequestCurrencyPrice*RequestQuantity)/RequestAmountBase,  <!--- exchange rate --->
						
						 <cfif Parameter.EnableQuickQuote eq "1">	
						
							<cfif Parameter.TaxExemption eq "1">										  
							
							  RequestCurrencyPrice,
							  RequestCurrencyPrice*RequestQuantity,
							  RequestAmountBase,									  
							  
							<cfelseif Parameter.DefaultTaxIncluded eq "1">
							
							  <!--- we have to split the tax out of the requisition price --->
							
							  RequestCurrencyPrice,
							  1 / (1+#Parameter.TaxDefault#) * (RequestCurrencyPrice*RequestQuantity),
							  1 / (1+#Parameter.TaxDefault#) * RequestAmountBase,	
							  #Parameter.TaxDefault# /(1+#Parameter.TaxDefault#) * (RequestCurrencyPrice*RequestQuantity),
							  #Parameter.TaxDefault# /(1+#Parameter.TaxDefault#) * (RequestCurrencyPrice*RequestQuantity) / ((RequestCurrencyPrice*RequestQuantity)/RequestAmountBase),
							 
							<cfelse>
							
							  RequestCurrencyPrice,
							  RequestCurrencyPrice*RequestQuantity,
							  RequestAmountBase,	
							  #Parameter.TaxDefault# *( RequestCurrencyPrice*RequestQuantity),
							  #Parameter.TaxDefault# *( RequestCurrencyPrice*RequestQuantity) / ((RequestCurrencyPrice*RequestQuantity)/RequestAmountBase),
							 
							</cfif>  
							
							'1',
						 
						 </cfif>						 
						 
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#'
				 FROM   RequisitionLine
				 WHERE  JobNo = '#getQuote.JobNo#'
				  <!--- does not have an occurance --->
				 AND   RequisitionNo NOT IN (SELECT RequisitionNo 
				                             FROM   RequisitionLineQuote 
											 WHERE  OrgUnitVendor = '#getQuote.OrgUnitVendor#') 
			</cfquery>
	
		</cftransaction>
		
		<script>
			try {				
				parent.parent.opener.document.getElementById("mybut").click()				
				} catch(e) {}	
			parent.window.close()			
		</script>

<cfelseif ParameterExists(Form.delete)> 

	<cfquery name="GetQuote" 
			 datasource="AppsPurchase" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT *
				FROM   RequisitionLineQuote
				WHERE  QuotationId = '#url.id#'
	</cfquery>

	<cfquery name="UpdateRequisitionLine" 
			 datasource="AppsPurchase" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				UPDATE RequisitionLine
				SET    ActionStatus = '2k', 
				       JobNo = NULL
				WHERE  RequisitionNo = '#GetQuote.RequisitionNo#'
	</cfquery>
	
	<cfquery name="InsertAction" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     INSERT INTO RequisitionLineAction 
				 (RequisitionNo, 
				  ActionStatus, 
				  ActionDate, 
				  ActionMemo,
				  ActionContent,
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName) 
	     VALUES ('#GetQuote.RequisitionNo#',
		         '1', 
				  getDate(), 
				 'Removed from job',
				 'Requistion removed from JOB No: #GetQuote.JobNo#',
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
				 '#SESSION.first#')
	</cfquery>
	

	<cfquery name="DeleteQuote" 
			 datasource="AppsPurchase" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				DELETE 
				FROM   RequisitionLineQuote
				WHERE  QuotationId = '#url.id#'
	</cfquery>
	
	<script>
			
				try {				
				parent.parent.opener.document.getElementById("mybut").click()				
				} catch(e) {}	
				parent.window.close()		
	</script>

	
	
<cfelse>

		<cfparam name="Form.Award"          default="">
		<cfparam name="Form.AwardRemarks"   default="">
		
		<cfif Len(Form.AwardRemarks) gt 200>
			 <cf_message message = "Your entered award remarks that exceeded the allowed size of 200 characters."
			  return = "back">
			  <cfabort>
		</cfif>
		
		<cfif Form.Award neq "">
		
			<cfquery name="Update" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				UPDATE RequisitionLineQuote
				SET    Award           = NULL,
				       AwardRemarks    = NULL,
				       Selected        = 0
				WHERE  RequisitionNo IN (SELECT RequisitionNo 
				                         FROM   RequisitionLineQuote 
										 WHERE  QuotationId = '#URL.ID#')
			</cfquery>
		
		</cfif> 
		
		<cfparam name="Form.Award"        default="">
		<cfparam name="Form.QuoteZero"    default="0">
		<cfparam name="Form.TaxExemption" default="0">
		<cfparam name="Form.QuotePrice"   default="0">
		
		<cfset quoteprice = replace(form.quoteprice,',','',"ALL")>
		
		<cfset base = Form.QuotationQuantity*quoteprice*(100-Form.QuoteDiscount)>
		<cfset tax  = Form.QuoteTax>
		<cfset exc  = Form.ExchangeRate>
		
		<cfif Form.TaxIncluded eq "1">
			<cfset cost  = (base)*(100/(100+Tax))>	
			<cfset QuoteAmountCost = round(cost)/100>		
			<cfset atax  = base*(Tax/(100+Tax))>	
			<cfset QuoteAmountTax  = round(atax)/100>		
		<cfelse>
			<cfset cost            = base>
			<cfset QuoteAmountCost = round(cost)/100>	
			<cfset atax            = base*(Tax/100)>
			<cfset QuoteAmountTax  = round(atax)/100>
		</cfif>	
		
		<cfset QuoteAmountBaseCost = round(cost/exc)/100>
		<cfset QuoteAmountBaseTax  = round(atax/exc)/100>
		
		<cfif Len(Form.AwardRemarks) gt 350>
		    <cfset rem = left(Form.AwardRemarks,350)>
		<cfelse>
			<cfset rem = Form.AwardRemarks>  
		</cfif>
		
		<cfif Len(Form.VendorItemDescription) gt 250>
		    <cfset des = left(Form.VendorItemDescription,250)>
		<cfelse>
			<cfset des = Form.VendorItemDescription>  
		</cfif>
		
		<cfquery name="Update" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE RequisitionLineQuote
		  SET  VendorItemNo          = '#Form.VendorItemNo#',
			   VendorItemDescription = '#des#',
			   QuotationQuantity     = '#Form.QuotationQuantity#', 
			   QuotationUoM          = '#Form.QuotationUoM#', 
			   QuotationMultiplier   = '#Form.QuotationMultiplier#',
			   Currency              = '#Form.Currency#',
			   <cfif Form.QuoteZero eq "1" and Form.CostPriceB eq "0">
			 	 QuoteZero         = 1,
				 QuotePrice        = 0,
			   <cfelse>
				 QuoteZero         = 0,
				 QuotePrice        = '#QuotePrice#',
			   </cfif>
			   QuoteDiscount         = '#Form.QuoteDiscount/100#',
			   QuoteTax              = '#Form.QuoteTax/100#', 
			   TaxIncluded           = '#Form.TaxIncluded#',
			   QuoteAmountCost       = '#QuoteAmountCost#',
			   <cfif Form.TaxExemption eq "1">
			    QuoteAmountTax       = 0,	
			   <cfelse>
			    QuoteAmountTax       = '#QuoteAmountTax#',
			   </cfif>		
			   ExchangeRate          = '#Form.ExchangeRate#',
			   QuoteAmountBaseCost   = '#QuoteAmountBaseCost#',
			   <cfif Form.TaxExemption eq "1">
			    QuoteAmountBaseTax   = 0,	
			   <cfelse>
			    QuoteAmountBaseTax   = '#QuoteAmountBaseTax#',
			   </cfif>			
			   <cfif Form.Award neq "">
				   Award           = '#Form.Award#',
				   AwardRemarks    = '#rem#',
				   Selected        = 1,
			   <cfelse>
			   	   Award           = null,
				   AwardRemarks    = null,
				   Selected        = 0,
			   </cfif> 
			   TaxExemption          = '#Form.TaxExemption#',
			   Remarks               = '#Form.Remarks#',
			   Created               = getDate() 
		  WHERE QuotationId        = '#URL.ID#'
		</cfquery>
		
		<cfif ParameterExists(Form.SaveClose)> 
			
			<script>
				
				try {				
				parent.parent.opener.document.getElementById("mybut").click()				
				} catch(e) {}		
				parent.window.close()		
			</script>
		
		<cfelse>
			
			<cfoutput>
			<script>
				try {				
				parent.parent.opener.document.getElementById("mybut").click()				
				} catch(e) {}								
				ptoken.location("QuotationEdit.cfm?id=#url.id#&mode=#url.mode#")
			</script>
			</cfoutput>
		
		</cfif>

</cfif>