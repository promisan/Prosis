
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfset vBankAddress = "">
<cfloop index = "j" from = "1" to = 5> 
	<cfif vBankAddress eq "">
		<cfset vBankAddress = Evaluate("FORM.BankAddress#j#")>
	<cfelse>
		<cfset vBankAddress = "#vBankAddress# | #Evaluate('FORM.BankAddress#j#')#">	
	</cfif>
</cfloop>		


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
				 AccountAddress,
				 Currency,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		  VALUES ('#rowguid#',
		          '#Form.Bank#', 
				  '#vBankAddress#', 
		          '#Form.AccountNo#',
				  '#Form.AccountName#',
				  '#Form.AccountABA#',
				  '#Form.AccountAddress#',
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
	BankAddress       = '#vBankAddress#',
	AccountNo         = '#Form.AccountNo#',
	AccountName       = '#FORM.AccountName#',
	AccountABA        = '#FORM.AccountABA#',
	AccountAddress    = '#Form.AccountAddress#'
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
	 opener.location.reload()
        
</script>  
