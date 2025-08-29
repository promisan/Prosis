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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Operational" default="0">

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_clause
WHERE Code   = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">   
		     alert("A clause with this code has been registered already!")     
	   </script>  
  
   <cfelse>

		<cfquery name="Insert" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_Clause
			         (Code,
					 ClauseName, 
					 ClauseText,
					 Operational,
					 LanguageCode,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,
					 Created)
			  VALUES ('#Form.Code#', 
			          '#Form.ClauseName#',
					  '#Form.ClauseText#',
					  '#Form.Operational#',
					  '#Form.Languagecode#',
				   	  '#SESSION.acc#',	
					  '#SESSION.last#',		
					  '#SESSION.first#',			  
				  	  getDate())
		  </cfquery>
  
     </cfif>

</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Clause
		SET ClauseName       = '#Form.ClauseName#', 
		    ClauseText       = '#Form.ClauseText#',
			Operational      = '#Form.Operational#',
			LanguageCode     = '#Form.Languagecode#'
		WHERE Code      = '#Form.Code#'
	</cfquery>
	

</cfif>	

<cfif ParameterExists(Form.Delete)> 
	
	<cfquery name="CountRec" 
	      datasource="AppsPurchase" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT *
	      FROM PurchaseClause
	      WHERE ClauseCode      = '#Form.Code#'      
	</cfquery>
	
	<cfif #CountRec.recordCount# gt 0>
			 
	     <script language="JavaScript">	    
		   alert("Clause is in use. Operation aborted.")	     
	     </script>  
		 
    <cfelse>
		
		<cfquery name="Remove" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE Ref_Clause
			WHERE Code     = '#Form.Code#'
		</cfquery> 
	
  </cfif>	
  
</cfif>  

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  
