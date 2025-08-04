<!--
    Copyright © 2025 Promisan

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
