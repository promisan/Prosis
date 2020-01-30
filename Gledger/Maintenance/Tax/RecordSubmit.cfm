
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 


<cf_preventCache>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  Ref_Tax
WHERE TaxCode  = '#Form.TaxCode#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
   <cfelse>

<cfquery name="Insert" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_Tax
         (TaxCode,
		 Description,
		 Percentage,
		 TaxCalculation,
		 TaxRounding,
		 GLAccountPaid,
		 GLAccountReceived,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.TaxCode#', 
          '#Form.Description#',
		  '#Form.Percentage/100#',
		  '#Form.TaxCalculation#',
		  '#Form.TaxRounding#',
		  '#Form.GLAccountPaid#',
		  '#Form.GLAccountReceived#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_Tax
	SET    Description        = '#Form.Description#',
       	   Percentage         = '#FORM.Percentage/100#',
      	   TaxCalculation     = '#FORM.TaxCalculation#',
      	   TaxRounding        = '#Form.TaxRounding#',
      	   GLAccountPaid      = '#Form.GLAccountPaid#',
	       GLAccountReceived  = '#Form.GLAccountReceived#'
	WHERE  TaxCode      = '#Form.TaxCode#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 
				
		<cfquery name="Delete" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Ref_Tax WHERE TaxCode  = '#Form.TaxCode#' 
	    </cfquery>
		
</cfif>	

<script language="JavaScript">   
     window.close()
	 opener.history.go()        
</script>  
