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


<cf_preventCache>

 <cfparam name="Form.FundType" default="">
 
<cfif not ParameterExists(Form.VerifyAvailability)> 
  <cfparam name="Form.VerifyAvailability" default="0">
</cfif>  

<cfif not ParameterExists(Form.ControlView)> 
  <cfparam name="Form.ControlView" default="0">
</cfif> 

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Fund
	WHERE  Code  = '#Form.Code#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
	<cfquery name="Insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Fund
	         (code,
			 Description,
			 ListingOrder,
			 VerifyAvailability,
			 ControlView,
			 Currency,
			 FundType,
			 FundingMode,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	  VALUES ('#Form.Code#',
	          '#Form.Description#', 
			  '#Form.ListingOrder#',
			  '#Form.VerifyAvailability#',
			  '#Form.ControlView#',
			  '#Form.Currency#',
			  <cfif fundtype eq "">
			  NULL,
			  <cfelse>
			  '#Form.FundType#',
			  </cfif>
			  '#Form.FundingMode#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
	  </cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	
<cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT Fund
      FROM Ref_AllotmentEditionFund
      WHERE Fund = '#Form.codeOld#' 
    </cfquery>
	
	
	
	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Fund
	SET <cfif CountRec.recordCount eq 0>
	    Code                = '#Form.code#',
		</cfif>
	    Description         = '#Form.Description#',
		ListingOrder        = '#Form.ListingOrder#',
		VerifyAvailability  = '#Form.VerifyAvailability#',
		ControlView			= '#Form.ControlView#',
		<cfif fundtype eq "">
		 FundType = NULL,
		<cfelse>
		 FundType = '#Form.FundType#',
		</cfif>
		FundingMode         = '#Form.FundingMode#',
	    Currency            = '#Form.Currency#'
	WHERE code              = '#Form.CodeOld#'
	</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT Fund
      FROM Ref_AllotmentEditionFund
      WHERE Fund = '#Form.codeOld#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Fund is in use. Operation aborted.")
	        
     </script>  
	 
    <cfelse>
			
	<cfquery name="Delete" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_Fund
		WHERE code = '#FORM.codeOld#'
    </cfquery>
	
	</cfif>
	
</cfif>	


<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  

