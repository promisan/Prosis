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

<cfif ParameterExists(Form.Insert)> 
	
	<cfquery name="Verify" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_DiscountType
		WHERE  Code  = '#Form.Code#' 
	</cfquery>

   <cfif Verify.recordCount eq "1">
   
	   <script language="JavaScript">   
		     alert("A record with this code has been registered already!")     
	   </script>  
  
   <cfelse>
	   
		<cfquery name="Insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  INSERT INTO Ref_DiscountType
		          (Code,
				   Description,
				   OfficerUserId,
				   OfficerLastName,
				   OfficerFirstName)
		  VALUES  ('#Form.Code#',
		           '#Form.Description#', 
				   '#SESSION.acc#',
		    	   '#SESSION.last#',		  
			  	   '#SESSION.first#')
		</cfquery>
		 
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		                     action="Insert" 
							 content="#form#">
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_DiscountType
		SET   Code         = '#Form.code#',
		      Description  = '#Form.Description#'
		WHERE code         = '#Form.CodeOld#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#form#">

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="appsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	  	SELECT 	DiscountType
		FROM 	PromotionElement
		WHERE 	DiscountType = '#Form.codeOld#'
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">    
		   alert("Discount type is in use. Operation aborted.")	        
	     </script>  
	 
    <cfelse>
	
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
             action="Delete" 
			 content="#form#">
			
		<cfquery name="Delete" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_DiscountType
			WHERE CODE = '#FORM.codeOld#'
	    </cfquery>
	
	</cfif>	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
