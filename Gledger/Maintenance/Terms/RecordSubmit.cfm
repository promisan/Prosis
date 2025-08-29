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

<cfquery name="Insert" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_Terms
         (Description,
		 PaymentDays,
		 DiscountDays,
		 Discount,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.Description#',
          '#Form.PaymentDays#',
		  '#Form.DiscountDays#',
		  '#Form.Discount#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_Terms
SET 
Description       = '#Form.Description#',
Discount          = #FORM.Discount/100#,
Discountdays      = #FORM.DiscountDays#,
PaymentDays       = #Form.PaymentDays#
WHERE Code        = #FORM.Code#
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 
			
	<cfquery name="Delete" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_Terms WHERE Code  = #Form.Code# 
    </cfquery>
	
</cfif>	

<script language="JavaScript">
     window.close()
	 opener.history.go()
</script>  
