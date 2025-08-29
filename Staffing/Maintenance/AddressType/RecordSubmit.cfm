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

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AddressType
WHERE 
AddressType  = '#Form.AddressType#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Address Type" 
ActionType="Enter" 
ActionReference="#Form.AddressType#" 
ActionScript="">   

<cfquery name="Insert" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_AddressType
         (AddressType,
		 Description,
		 Listingorder,
		 <cfif trim(form.color) neq "">MarkerColor,</cfif>
		 EntityClass,
		 Operational,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
  VALUES ('#Form.AddressType#',
          '#Form.Description#', 
		  '#form.ListingOrder#',
		  <cfif trim(form.color) neq "">'#form.color#',</cfif>
		  '#form.entityclass#',
		  #form.operational#,
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')</cfquery>
		  
		<cf_LanguageInput
			TableCode       = "Ref_AddressType" 
			Mode            = "Save"
			Key1Value       = "#Form.AddressType#"
			Name1           = "Description">
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<CF_RegisterAction 
	SystemFunctionId="0999" 
	ActionClass="AddressType" 
	ActionType="Update" 
	ActionReference="#Form.AddressType#" 
	ActionScript="">   

<cfquery name="Update" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_AddressType
	SET    AddressType     = '#Form.AddressType#',
	       Description     = '#Form.Description#',
		   ListingOrder    = '#form.ListingOrder#',
		   MarkerColor     = <cfif trim(form.color) eq "">null<cfelse>'#Form.color#'</cfif>,
		   EntityClass     = '#Form.EntityClass#',
		   Operational     = #Form.Operational#
	WHERE  AddressType  = '#Form.AddressTypeOld#'
</cfquery>

<cf_LanguageInput
			TableCode       = "Ref_AddressType" 
			Mode            = "Save"
			Key1Value       = "#Form.AddressType#"
			Name1           = "Description">

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT AddressType
      FROM   vwPersonAddress
      WHERE  AddressType  = '#Form.AddressTypeOld#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Address Type is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
	
		<CF_RegisterAction 
	SystemFunctionId="0999" 
	ActionClass="AddressType" 
	ActionType="Remove" 
	ActionReference="#Form.AddressTypeOld#" 
	ActionScript="">   
			
		<cfquery name="Delete" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_AddressType
	WHERE AddressType = '#FORM.AddressTypeOld#'
	    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
