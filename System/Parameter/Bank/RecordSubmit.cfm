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
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   Ref_BankAccount
WHERE  BankName  = '#Form.Bank#'  
AND    AccountNo = '#Form.AccountNo#'
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("A record for this account has been registered already!")
     
   </script>  
  
   <cfelse>
   
        <cf_assignId>
   
		<cfquery name="Insert" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_BankAccount
		         (BankId,
				 BankName,
				 BankAddress,
				 AccountNo,
				 AccountName,
				 AccountABA,
				 Currency,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		  VALUES ('#rowguid#',
		          '#Form.Bank#', 
				  '#Form.BankAddress#', 
		          '#Form.AccountNo#',
				  '#Form.AccountName#',
				  '#Form.AccountABA#',
				  '#Form.Currency#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())</cfquery>
				  
			<cfif Form.GLAccount neq "">
				  
			<cfquery name="Update" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Ref_Account
				SET BankId = '#rowguid#'
				WHERE GLAccount = '#Form.GLAccount#'
			</cfquery>
			
			</cfif>	  
						  
    </cfif>		
	           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_BankAccount
	SET 
	BankName          = '#Form.Bank#',
	BankAddress       = '#Form.BankAddress#',
	AccountNo         = '#Form.AccountNo#',
	AccountName       = '#FORM.AccountName#',
	AccountABA        = '#FORM.AccountABA#',
	AccountAddress    = '#Form.BankAddress#'
	WHERE BankId        = '#Form.BankId#'
</cfquery>

<cfquery name="Update" 
  datasource="AppsLedger" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	UPDATE Ref_Account
	SET BankId = NULL
	WHERE BankId = '#Form.BankId#'
</cfquery>

<cfif Form.GLAccount neq "">
				  
		<cfquery name="Update" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_Account
			SET BankId = '#Form.BankId#'
			WHERE GLAccount = '#Form.GLAccount#'
		</cfquery>
			
</cfif>	  

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="Update" 
	  datasource="AppsLedger" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		UPDATE Ref_Account
		SET BankId = NULL
		WHERE BankId = '#Form.BankId#'
	</cfquery>
			
	<cfquery name="Delete" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_BankAccount
		WHERE BankId   = '#Form.BankId#'
	</cfquery>
	
</cfif>
	

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  
