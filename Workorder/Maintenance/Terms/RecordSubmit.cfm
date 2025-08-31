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
<cfif ParameterExists(Form.Insert)> 
   
<cfquery name="Insert" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_Terms
         (
		 Description,
		 paymentDays,
		 discount,
		 discountDays,
		 operational,
		  OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
  VALUES (
  			'#Form.Description#', 
			#Form.paymentDays#, 
			#Form.discount#, 
			#Form.discountDays#, 
			#Form.operational#,
          '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')</cfquery>  
           
</cfif>

<cfif ParameterExists(Form.Update)>	

	<cfquery name="Update" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Terms
	SET 
		  Description = '#Form.Description#',
		  paymentDays = #Form.paymentDays#,
		  discount = #Form.discount#,
		  discountDays = #Form.discountDays#,
		  operational = #Form.operational#
	WHERE Code   = '#Form.CodeOld#'
	</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 	
			
	<cfquery name="Delete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_Terms
		WHERE Code = '#FORM.CodeOld#'
	</cfquery>
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
