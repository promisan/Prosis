
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Operational" default="0">
<cfparam name="Form.EnableProcurement" default="0">

<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Currency
	WHERE  Currency  = '#Form.Currency#' 
	</cfquery>

   <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
	   
	     alert("A currency with this acronym has been registered already!")
	     
	   </script>  
  
   <cfelse>
   	
	<cfquery name="Insert" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Currency
	         (Currency,
			 Description,
			 ExchangeRate,
			 ExchangeRateModified,
			 GLAccountInvoiceTax,
			 GLAccountSalesTax,
			 EnableProcurement,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
	  VALUES ('#Form.Currency#', 
	          '#Form.Description#',
			  '#Form.ExchangeRate#',
			  getDate(),
			  '#Form.GLAccount1#',
			  '#Form.GLAccount2#',
			  '#Form.EnableProcurement#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())</cfquery>
			  
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.EffectiveDate#">
	<cfset STR = #dateValue#>		  
			  
	<cfquery name="Insert" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO CurrencyExchange
	         (Currency,
			 ExchangeRate,
			 EffectiveDate,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
	  VALUES ('#Form.Currency#', 
	          '#Form.ExchangeRate#',
			  #STR#,
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())</cfquery>		  
			  
	    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.EffectiveDate#">
	<cfset STR = #dateValue#>	
	
	<cfquery name="Verify" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Currency
		WHERE  Currency  = '#Form.Currency#' 
	</cfquery>	  
				
	<cfif Verify.ExchangeRate neq Form.ExchangeRate>
	
		<cfquery name="Check" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   CurrencyExchange
			WHERE  Currency      = '#Form.Currency#'
			AND    EffectiveDate = #STR#
		</cfquery>		
	
		<cfif Check.recordCount eq "0">
		
			<cfquery name="Insert" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO CurrencyExchange
				         (Currency,
						 ExchangeRate,
						 EffectiveDate,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				  VALUES ('#Form.Currency#', 
				          '#Form.ExchangeRate#',
						  #STR#,
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#')</cfquery>		
				
		<cfelse>
		
			<cfquery name="Update" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   UPDATE CurrencyExchange
				   SET    ExchangeRate   = '#FORM.ExchangeRate#'
				   WHERE  Currency       = '#Form.Currency#'
				   AND    EffectiveDate  = #STR#
				</cfquery>		
			  
		</cfif>		
		
	</cfif>	    
	
	<cfquery name="get" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 * FROM CurrencyExchange
		WHERE  Currency       = '#Form.Currency#'
		ORDER BY EffectiveDate DESC
	</cfquery>	
		
	<cfquery name="Update" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Currency
			SET    Description           = '#Form.Description#',
			       ExchangeRate          = '#get.ExchangeRate#',
			       ExchangeRateModified  = '#get.Created#',
			       Operational           = '#Form.Operational#',
			       EnableProcurement     = '#Form.EnableProcurement#',
			       GLAccountInvoiceTax   = '#Form.GLAccount1#',
			       GLAccountSalesTax     = '#Form.GLAccount2#'
			WHERE  Currency              = '#Form.Currency#'
	</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

 <cfquery name="CountRec" 
      datasource="AppsLedger" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT Currency
      FROM  Journal
      WHERE Currency  = '#Form.Currency#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
         alert("Currency is in use. Operation aborted.")
      </script>  
	 
    <cfelse>
			
	<cfquery name="Delete" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Currency 
		WHERE Currency  = '#Form.Currency#' 
    </cfquery>
	
	</cfif>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  
