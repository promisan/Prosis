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

<cfif ParameterExists(Form.Save)> 

<cfquery name="Verify" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_UnitClass
	WHERE code  = '#Form.code#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
	 history.back()
     
   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_UnitClass
		         (Code,
				 Description,
				 listingOrder,
				  OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		  VALUES ('#Form.Code#','#Form.Description#', #Form.listingOrder#,
		          '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())
		</cfquery>
		
		<cf_LanguageInput
			TableCode       = "Ref_UnitClass" 
			Mode            = "Save"
			DataSource      = "AppsWorkOrder"
			Key1Value       = "#Form.Code#"
			Name1           = "Description">	
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>	

	<cfparam name="Form.Code" default="#Form.CodeOld#">

	<cfquery name="Update" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_UnitClass
		SET 
		      Code   = '#Form.Code#', 
			  Description = '#Form.Description#',
			  listingOrder = #Form.listingOrder#
		WHERE Code   = '#Form.CodeOld#'
	</cfquery>
	
	<cf_LanguageInput
		TableCode       = "Ref_UnitClass" 
		Mode            = "Save"
		DataSource      = "AppsWorkOrder"
		Key1Value       = "#Form.Code#"
		Name1           = "Description">	

</cfif>	

<cfif ParameterExists(Form.Delete)> 	
		
	<cfquery name="Delete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_UnitClass
		WHERE Code = '#FORM.Code#'
	</cfquery>
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
